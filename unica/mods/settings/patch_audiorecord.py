#!/usr/bin/env python3
import sys, re

if len(sys.argv) < 2:
    print("Usage: patch_audiorecord.py <path-to-AudioRecord.smali>")
    sys.exit(1)

path = sys.argv[1]
with open(path, "r", encoding="utf-8") as f:
    code = f.read()

# 1. Byte array: native_read_in_byte_array
pat_byte = re.compile(
    r'(invoke-[a-z/]+\s*\{[^}]+\},\s*Landroid/media/AudioRecord;->native_read_in_byte_array\([^\)]+\)I\s*\n\s*move-result\s+([vp0-9]+))'
)
code = pat_byte.sub(
    r'\1\n\n    invoke-static {p0, p1, p2, \2}, Lio/mesalabs/unica/audio/VoiceChangerAudioRecordHook;->onAudioRecordRead(Landroid/media/AudioRecord;[BII)V',
    code
)

# 2. Short array: native_read_in_short_array
pat_short = re.compile(
    r'(invoke-[a-z/]+\s*\{[^}]+\},\s*Landroid/media/AudioRecord;->native_read_in_short_array\([^\)]+\)I\s*\n\s*move-result\s+([vp0-9]+))'
)
code = pat_short.sub(
    r'\1\n\n    invoke-static {p0, p1, p2, \2}, Lio/mesalabs/unica/audio/VoiceChangerAudioRecordHook;->onAudioRecordRead(Landroid/media/AudioRecord;[SII)V',
    code
)

# 3. Direct buffer: native_read_in_direct_buffer
pat_buf = re.compile(
    r'(invoke-[a-z/]+\s*\{[^}]+\},\s*Landroid/media/AudioRecord;->native_read_in_direct_buffer\([^\)]+\)I\s*\n\s*move-result\s+([vp0-9]+))'
)
code = pat_buf.sub(
    r'\1\n\n    invoke-static {p0, p1, \2}, Lio/mesalabs/unica/audio/VoiceChangerAudioRecordHook;->onAudioRecordRead(Landroid/media/AudioRecord;Ljava/nio/ByteBuffer;I)V',
    code
)

with open(path, "w", encoding="utf-8") as f:
    f.write(code)

print(f"AudioRecord.smali successfully patched: {path}")
