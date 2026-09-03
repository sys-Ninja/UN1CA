#!/usr/bin/env python3
import sys, re

if len(sys.argv) < 2:
    print("Usage: patch_audiorecord.py <path-to-AudioRecord.smali>")
    sys.exit(1)

path = sys.argv[1]
with open(path, "r", encoding="utf-8") as f:
    code = f.read()

# 1. Byte array: native_read_in_byte_array
# Fix: if move-result targets p0 (overwrites 'this'!), rewrite to v1 (free after invoke).
pat_byte = re.compile(
    r'(invoke-[a-z/]+\s*\{[^}]+\},\s*Landroid/media/AudioRecord;->native_read_in_byte_array\([^\)]+\)I\s*\n\s*move-result\s+([vp0-9]+))'
)
def replace_byte(m):
    full, reg = m.group(1), m.group(2)
    if reg == 'p0':
        fixed = full.replace('move-result p0', 'move-result v1')
        result_reg = 'v1'
    else:
        fixed = full
        result_reg = reg
    return fixed + '\n\n    invoke-static {p0, p1, p2, ' + result_reg + '}, Lio/mesalabs/unica/audio/VoiceChangerAudioRecordHook;->onAudioRecordRead(Landroid/media/AudioRecord;[BII)V'
code = pat_byte.sub(replace_byte, code)

# Fix return statement: if we changed move-result p0 → v1, the 'return p0' must become 'return v1'
code = re.sub(
    r'(invoke-static \{p0, p1, p2, v1\}, Lio/mesalabs/unica/audio/VoiceChangerAudioRecordHook;->onAudioRecordRead\(Landroid/media/AudioRecord;\[BII\)V\s*\n\s*)return p0',
    r'\1return v1',
    code
)

# 2. Short array: native_read_in_short_array
pat_short = re.compile(
    r'(invoke-[a-z/]+\s*\{[^}]+\},\s*Landroid/media/AudioRecord;->native_read_in_short_array\([^\)]+\)I\s*\n\s*move-result\s+([vp0-9]+))'
)
def replace_short(m):
    full, reg = m.group(1), m.group(2)
    if reg == 'p0':
        fixed = full.replace('move-result p0', 'move-result v1')
        result_reg = 'v1'
    else:
        fixed = full
        result_reg = reg
    return fixed + '\n\n    invoke-static {p0, p1, p2, ' + result_reg + '}, Lio/mesalabs/unica/audio/VoiceChangerAudioRecordHook;->onAudioRecordRead(Landroid/media/AudioRecord;[SII)V'
code = pat_short.sub(replace_short, code)

code = re.sub(
    r'(invoke-static \{p0, p1, p2, v1\}, Lio/mesalabs/unica/audio/VoiceChangerAudioRecordHook;->onAudioRecordRead\(Landroid/media/AudioRecord;\[SII\)V\s*\n\s*)return p0',
    r'\1return v1',
    code
)

# 3. Direct buffer: native_read_in_direct_buffer
pat_buf = re.compile(
    r'(invoke-[a-z/]+\s*\{[^}]+\},\s*Landroid/media/AudioRecord;->native_read_in_direct_buffer\([^\)]+\)I\s*\n\s*move-result\s+([vp0-9]+))'
)
def replace_buf(m):
    full, reg = m.group(1), m.group(2)
    if reg == 'p0':
        fixed = full.replace('move-result p0', 'move-result v1')
        result_reg = 'v1'
    else:
        fixed = full
        result_reg = reg
    return fixed + '\n\n    invoke-static {p0, p1, ' + result_reg + '}, Lio/mesalabs/unica/audio/VoiceChangerAudioRecordHook;->onAudioRecordRead(Landroid/media/AudioRecord;Ljava/nio/ByteBuffer;I)V'
code = pat_buf.sub(replace_buf, code)

code = re.sub(
    r'(invoke-static \{p0, p1, v1\}, Lio/mesalabs/unica/audio/VoiceChangerAudioRecordHook;->onAudioRecordRead\(Landroid/media/AudioRecord;Ljava/nio/ByteBuffer;I\)V\s*\n\s*)return p0',
    r'\1return v1',
    code
)

with open(path, "w", encoding="utf-8") as f:
    f.write(code)

print(f"AudioRecord.smali successfully patched: {path}")
