#!/usr/bin/env python3
"""Line coverage of lib/ from coverage/lcov.info, generated code (lib/l10n) left out; fails under the threshold."""
import sys

THRESHOLD = float(sys.argv[1]) if len(sys.argv) > 1 else 80.0
hit = total = 0
current = None
for line in open("coverage/lcov.info"):
    if line.startswith("SF:"):
        current = line[3:].strip()
    elif line.startswith("DA:") and "/l10n/" not in current:
        total += 1
        hit += int(line[3:].split(",")[1]) > 0
percent = 100 * hit / total
print(f"Line coverage of lib/ (generated code excluded): {percent:.1f} % ({hit}/{total}), threshold {THRESHOLD} %")
sys.exit(0 if percent >= THRESHOLD else 1)
