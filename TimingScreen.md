# Screen timing diagnostic, experimental

`TimingScreen.bin` is a standard 2 KiB cartridge. It shows four hexadecimal results for a photograph. It has not been validated on an original VideoBrain.

Each test waits for current video line `$20`, executes 255 iterations, and reads the current line again. The displayed bytes are the finishing lines, left to right:

1. Control: load RAM address and execute `LIS 0`.
2. RAM read: load RAM address and read it.
3. RAM write: load RAM address and write it.
4. Cartridge read: load cartridge address and read it.

The tests include instruction fetches, loop overhead and register accesses. The result is a coarse raster position, not a direct count of memory wait states. Polling starts at an uncertain point within the line, so a result can vary by one or more lines between runs. The cartridge holds the first set of results on screen while leaving the BIOS video display active. Differences can reflect video contention, but are not proof of a particular bus delay.

For comparison, use 480i on MiSTer and photograph the whole display on each machine. Record the ROM version, machine and display settings, and whether values fluctuate. Do not call a difference a failure until repeatability and the video state are established. The signal-capture workload is documented separately in [TimingBaseline.md](TimingBaseline.md).

One MiSTer run in 480i displayed `BB CD CE CD`. The current cartridge SHA-256 is `903e083987dc9621b5721ff2f2af5ecbb6ff91cebc9183e3529a5fccf8a4ce85`. Repeatability and original-hardware results remain unverified.

Rebuild both diagnostics on Linux or WSL with `bash build_timing_baseline.sh`.
