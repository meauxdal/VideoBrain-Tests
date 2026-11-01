#!/usr/bin/env bash
set -eu
cd "$(dirname "$0")"
./dasm/dasm-2.20.14.1-linux-x64/dasm TimingBaseline.asm -f3 -oTimingBaseline.bin -lTimingBaseline.lst -sTimingBaseline.sym
./dasm/dasm-2.20.14.1-linux-x64/dasm TimingScreen.asm -f3 -oTimingScreen.bin -lTimingScreen.lst -sTimingScreen.sym
