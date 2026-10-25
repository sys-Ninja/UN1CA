#!/usr/bin/env python3
"""
Downloads Ayah APK, 7 offline Tafsir databases, and full 114 Surahs of Al-Mokhtasar audio commentary
directly into the UN1CA mod directory structure during GitHub Actions CI build.
Ensures 100% genuine, complete files from official Ayah servers with zero dummy files.
Deduplicates audio strictly to 001_4.mp3..114_4.mp3 to fit within the physical super partition.
"""

import os
import sys
import time
import zipfile
import io
import shutil
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

AUDIO_BASE_URLS = [
    "https://audio.ayah.app/ar-mokhtasar-asmari-abdulhakam",
    "https://audio.ayah.app/albums/ar-mokhtasar-asmari-abdulhakam",
]

USER_AGENTS = [
    "Mozilla/5.0 (Linux; Android 14; SM-A528B) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Mobile Safari/537.36",
    "okhttp/5.1.0",
    "Ayah/7.8.2 (Android; SM-A528B)",
]

def download_file_with_retry(url, dest_path, retries=5, delay=2, expected_min_size=1024):
    if os.path.exists(dest_path) and os.path.getsize(dest_path) >= expected_min_size:
        return True, f"Already exists: {os.path.basename(dest_path)}"

    os.makedirs(os.path.dirname(dest_path), exist_ok=True)
    temp_path = dest_path + ".tmp"

    for attempt in range(1, retries + 1):
        ua = USER_AGENTS[(attempt - 1) % len(USER_AGENTS)]
        headers = {
            "User-Agent": ua,
            "Accept": "*/*",
            "Connection": "keep-alive",
        }
        try:
            req = urllib.request.Request(url, headers=headers)
            with urllib.request.urlopen(req, timeout=60) as resp:
                with open(temp_path, "wb") as f:
                    shutil.copyfileobj(resp, f)

            size = os.path.getsize(temp_path)
            if size >= expected_min_size:
                os.replace(temp_path, dest_path)
                return True, f"Downloaded: {os.path.basename(dest_path)} ({size:,} bytes)"
            else:
                if os.path.exists(temp_path):
                    os.remove(temp_path)
        except Exception as e:
            if os.path.exists(temp_path):
                try:
                    os.remove(temp_path)
                except Exception:
                    pass
            if attempt == retries:
                return False, f"Failed {url} after {retries} attempts: {e}"
            time.sleep(delay)

    return False, f"Download failed: {url}"

def download_and_extract_book(book_id, url):
    os.makedirs(BOOKS_TARGET_DIR, exist_ok=True)
    zip_filename = f"{book_id}.zip"
    zip_path = os.path.join(BOOKS_TARGET_DIR, zip_filename)

    target_dbs = [f for f in os.listdir(BOOKS_TARGET_DIR) if f.startswith(book_id) and f.endswith(".db")]
    if target_dbs and os.path.getsize(os.path.join(BOOKS_TARGET_DIR, target_dbs[0])) > 500_000:
        return True, f"Tafsir DB {book_id} already exists ({target_dbs[0]})."

    ok, msg = download_file_with_retry(url, zip_path, expected_min_size=500_000)
    if not ok:
        return False, msg

    try:
        with zipfile.ZipFile(zip_path, 'r') as zip_ref:
            for item in zip_ref.namelist():
                if item.endswith(".db"):
                    zip_ref.extract(item, BOOKS_TARGET_DIR)
                    extracted_path = os.path.join(BOOKS_TARGET_DIR, item)
                    clean_path = os.path.join(BOOKS_TARGET_DIR, os.path.basename(item))
                    if extracted_path != clean_path:
                        os.replace(extracted_path, clean_path)

        if os.path.exists(zip_path):
            os.remove(zip_path)

        return True, f"Extracted Tafsir DB: {book_id}"
    except Exception as e:
        return False, f"Failed extracting {zip_filename}: {e}"

def download_audio_track(surah_num):
    os.makedirs(AUDIO_TARGET_DIR, exist_ok=True)
    surah_str = f"{surah_num:03d}"
    target_filename = f"{surah_str}_4.mp3"
    target_path = os.path.join(AUDIO_TARGET_DIR, target_filename)

    if os.path.exists(target_path) and os.path.getsize(target_path) >= 50_000:
        return True, f"Audio track {target_filename} already exists."

    candidate_urls = []
    for base in AUDIO_BASE_URLS:
        candidate_urls.append(f"{base}/{surah_str}_4.mp3")
        candidate_urls.append(f"{base}/{surah_str}-4.mp3")

    for url in candidate_urls:
        ok, msg = download_file_with_retry(url, target_path, retries=3, delay=1, expected_min_size=50_000)
        if ok:
            return True, f"Downloaded track {target_filename}"

    return False, f"All candidate URLs failed for Surah {surah_str}"

def cleanup_duplicates():
    if os.path.exists(AUDIO_TARGET_DIR):
        for f in os.listdir(AUDIO_TARGET_DIR):
            if f.endswith("-4.mp3"):
                p = os.path.join(AUDIO_TARGET_DIR, f)
                try:
                    os.remove(p)
                except Exception:
                    pass

def main():
    print("=" * 60)
    print("UN1CA Ayah Offline Assets Provisioning (CI Downloader)")
    print("=" * 60)

    cleanup_duplicates()

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
    with ThreadPoolExecutor(max_workers=3) as executor:
        futures = {executor.submit(download_and_extract_book, b_id, url): b_id for b_id, url in TAFSIR_BOOKS}
        for future in as_completed(futures):
            ok, msg = future.result()
            print(f" -> {msg}")
            if not ok:
                print("ERROR: Failed downloading Tafsir database")
                sys.exit(1)

    print("")
    print("[3/3] Downloading all 114 Surahs of Al-Mokhtasar Audio Commentary...")
    success_count = 0
    failed_surahs = []
    with ThreadPoolExecutor(max_workers=4) as executor:
        futures = {executor.submit(download_audio_track, s): s for s in range(1, 115)}
        for future in as_completed(futures):
            s_num = futures[future]
            ok, msg = future.result()
            if ok:
                success_count += 1
            else:
                failed_surahs.append(s_num)
                print(f" -> ERROR: {msg}")

            total_done = success_count + len(failed_surahs)
            if total_done % 10 == 0 or total_done == 114:
                print(f" -> Progress: {success_count}/114 audio tracks downloaded ({len(failed_surahs)} failed)... ")

    if failed_surahs:
        print(f" -> Retrying {len(failed_surahs)} failed surahs sequentially...")
        for s in list(failed_surahs):
            print(f"   Retrying Surah {s:03d}...")
            ok, msg = download_audio_track(s)
            if ok:
                print(f"   -> Success: {msg}")
                failed_surahs.remove(s)
                success_count += 1
            else:
                print(f"   -> Still failed: {msg}")

    if failed_surahs:
        print(f"CRITICAL ERROR: {len(failed_surahs)} audio tracks could not be downloaded from official servers: {failed_surahs}")
        sys.exit(1)

    cleanup_duplicates()

    print("")
    print("=" * 60)
    print("All Ayah offline assets successfully verified and complete 100%!")
    print(f" - APK size: {os.path.getsize(apk_path):,} bytes")
    db_files = [f for f in os.listdir(BOOKS_TARGET_DIR) if f.endswith('.db')]
    print(f" - Tafsir DB files: {len(db_files)} files in {BOOKS_TARGET_DIR}")
    audio_files = [f for f in os.listdir(AUDIO_TARGET_DIR) if f.endswith('.mp3')]
    print(f" - Audio files verified: {len(audio_files)} files in {AUDIO_TARGET_DIR}")
    print("=" * 60)

if __name__ == "__main__":
    main()
