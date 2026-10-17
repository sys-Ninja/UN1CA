#!/usr/bin/env python3
"""
Downloads Ayah APK, 7 offline Tafsir databases, and 114 Surahs of Al-Mokhtasar audio commentary
directly into the UN1CA mod directory structure during GitHub Actions CI build.
Zero local data consumption. Runs entirely in CI runner.
"""

import os
import sys
import time
import zipfile
import io
import urllib.request
import urllib.error
from concurrent.futures import ThreadPoolExecutor, as_completed

BASE_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
AYAH_MOD_DIR = os.path.join(BASE_DIR, "unica", "mods", "ayah")
APK_TARGET_DIR = os.path.join(AYAH_MOD_DIR, "system", "app", "Ayah")
BOOKS_TARGET_DIR = os.path.join(AYAH_MOD_DIR, "system", "etc", "ayah", "books")
AUDIO_TARGET_DIR = os.path.join(AYAH_MOD_DIR, "system", "etc", "ayah", "audio", "ar-mokhtasar-asmari-abdulhakam")

APK_URL = "https://github.com/sys-Ninja/UN1CA/releases/download/assets-common/Ayah.apk"

TAFSIR_BOOKS = [
    ("ar-muyassar", "https://cdn.ayah.app/books/ar-muyassar/ar-muyassar-2024-10-26.db.zip"),
    ("ar-saadi", "https://cdn.ayah.app/books/ar-saadi/ar-saadi-2025-02-25.db.zip"),
    ("ar-ibn-kathir", "https://cdn.ayah.app/books/ar-ibn-kathir/ar-ibn-kathir-2024-04-21.db.zip"),
    ("ar-baghawi", "https://cdn.ayah.app/books/ar-baghawi/ar-baghawi-2025-04-17.db.zip"),
    ("ar-tabari", "https://cdn.ayah.app/books/ar-tabari/ar-tabari-2024-10-23.db.zip"),
    ("ar-tafsir-irab", "https://cdn.ayah.app/books/ar-tafsir-irab/ar-tafsir-irab-2025-04-21.db.zip"),
    ("ar-tafsir-sarf", "https://cdn.ayah.app/books/ar-tafsir-sarf/ar-tafsir-sarf-2024-03-23.db.zip"),
]

AUDIO_BASE_URL = "https://audio.ayah.app/albums/ar-mokhtasar-asmari-abdulhakam"

HEADERS = {
    "User-Agent": "Mozilla/5.0 (Linux; Android 14; SM-A528B) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Mobile Safari/537.36",
    "Accept": "*/*",
}

def download_file_with_retry(url, dest_path, retries=5, delay=2, expected_min_size=1024):
    if os.path.exists(dest_path) and os.path.getsize(dest_path) >= expected_min_size:
        return True, f"Already exists: {os.path.basename(dest_path)}"

    os.makedirs(os.path.dirname(dest_path), exist_ok=True)
    temp_path = dest_path + ".tmp"

    for attempt in range(1, retries + 1):
        try:
            req = urllib.request.Request(url, headers=HEADERS)
            with urllib.request.urlopen(req, timeout=60) as resp:
                with open(temp_path, "wb") as f:
                    while chunk := resp.read(65536):
                        f.write(chunk)

            if os.path.getsize(temp_path) < expected_min_size:
                raise ValueError(f"Downloaded file too small ({os.path.getsize(temp_path)} bytes)")

            os.replace(temp_path, dest_path)
            return True, f"Downloaded {os.path.basename(dest_path)} ({os.path.getsize(dest_path):,} bytes)"
        except Exception as e:
            if os.path.exists(temp_path):
                try: os.remove(temp_path)
                except Exception: pass
            if attempt == retries:
                return False, f"Failed {url} after {retries} attempts: {e}"
            time.sleep(delay * attempt)

    return False, f"Failed {url}"

def download_and_extract_book(book_id, url):
    os.makedirs(BOOKS_TARGET_DIR, exist_ok=True)
    for attempt in range(1, 5):
        try:
            req = urllib.request.Request(url, headers=HEADERS)
            with urllib.request.urlopen(req, timeout=60) as resp:
                data = resp.read()

            with zipfile.ZipFile(io.BytesIO(data)) as z:
                db_files = [n for n in z.namelist() if n.endswith(".db")]
                if not db_files:
                    raise ValueError(f"No .db file found in {url}")
                for db_name in db_files:
                    extracted_path = os.path.join(BOOKS_TARGET_DIR, os.path.basename(db_name))
                    with open(extracted_path, "wb") as f:
                        f.write(z.read(db_name))
                    alias_path = os.path.join(BOOKS_TARGET_DIR, f"{book_id}.db")
                    if alias_path != extracted_path:
                        with open(alias_path, "wb") as f:
                            f.write(z.read(db_name))
            return True, f"Tafsir {book_id} extracted ({len(data):,} bytes zip)"
        except Exception as e:
            if attempt == 4:
                return False, f"Tafsir {book_id} failed: {e}"
            time.sleep(attempt * 2)
    return False, f"Tafsir {book_id} failed"

def download_audio_track(surah_num):
    cdn_filename = f"{surah_num:03d}-4.mp3"
    url = f"{AUDIO_BASE_URL}/{cdn_filename}"
    local_primary = os.path.join(AUDIO_TARGET_DIR, f"{surah_num:03d}_4.mp3")
    local_secondary = os.path.join(AUDIO_TARGET_DIR, f"{surah_num:03d}-4.mp3")

    ok, msg = download_file_with_retry(url, local_primary, expected_min_size=10240)
    if ok and not os.path.exists(local_secondary):
        try:
            os.link(local_primary, local_secondary)
        except Exception:
            try:
                import shutil
                shutil.copy2(local_primary, local_secondary)
            except Exception:
                pass
    return ok, msg

def main():
    print("=" * 60)
    print("UN1CA Ayah Offline Assets Provisioning (CI Downloader)")
    print("=" * 60)

    print("")
    print("[1/3] Downloading Ayah.apk...")
    apk_path = os.path.join(APK_TARGET_DIR, "Ayah.apk")
    ok, msg = download_file_with_retry(APK_URL, apk_path, expected_min_size=50_000_000)
    print(f" -> {msg}")
    if not ok:
        print("ERROR: Failed to download Ayah.apk")
        sys.exit(1)

    print("")
    print("[2/3] Downloading and extracting 7 Tafsir databases...")
    with ThreadPoolExecutor(max_workers=4) as executor:
        futures = {executor.submit(download_and_extract_book, b_id, url): b_id for b_id, url in TAFSIR_BOOKS}
        for future in as_completed(futures):
            ok, msg = future.result()
            print(f" -> {msg}")
            if not ok:
                print("ERROR: Failed downloading Tafsir database")
                sys.exit(1)

    print("")
    print("[3/3] Downloading 114 Surahs of Al-Mokhtasar Audio Commentary (parallel workers)...")
    success_count = 0
    with ThreadPoolExecutor(max_workers=8) as executor:
        futures = {executor.submit(download_audio_track, s): s for s in range(1, 115)}
        for future in as_completed(futures):
            ok, msg = future.result()
            if ok:
                success_count += 1
            else:
                print(f" -> ERROR: {msg}")
                sys.exit(1)
            if success_count % 20 == 0 or success_count == 114:
                print(f" -> Downloaded {success_count}/114 audio tracks...")

    print("")
    print("=" * 60)
    print("All Ayah offline assets successfully downloaded and prepared!")
    print(f" - APK size: {os.path.getsize(apk_path):,} bytes")
    print(f" - Tafsir DB files: {len(os.listdir(BOOKS_TARGET_DIR))} files in {BOOKS_TARGET_DIR}")
    print(f" - Audio tracks: {len([f for f in os.listdir(AUDIO_TARGET_DIR) if f.endswith('.mp3')])} files in {AUDIO_TARGET_DIR}")
    print("=" * 60)

if __name__ == "__main__":
    main()
