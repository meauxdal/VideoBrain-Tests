# Timing baseline, revision 1

`TimingBaseline.bin` is a 2 KiB standard cartridge. It repeats four workloads while the video system runs. This is a measurement workload, not a pass/fail test. It has not been validated on an original VideoBrain or against a MiSTer capture.

The cartridge disables CPU interrupts, leaves the existing video setup in place, and repeatedly writes RAM location `$0C80`. The screen is not a result display and may change. The workload drives CPU port 1 bit 4, the sound latch clock, as a timing marker. The marker also drives the audio circuit; audio output is not the measurement.

Each cycle has a long synchronization gap followed by four groups of 64 pulses. Shorter gaps separate the groups. The groups are, in order:

1. Control: `DCI $0C80`, followed by `LIS 0`.
2. RAM read: `DCI $0C80`, followed by `LM`.
3. RAM write: `DCI $0C80`, followed by `ST`.
4. Cartridge read: `DCI $1000`, followed by `LM`.

Each marked interval starts at the port 1 write with accumulator `$10` and ends at the port 1 write with accumulator `$00`. Both include `DCI`, instruction fetches, `LIS 0` and the output instructions; the control has an additional `LIS 0` in place of a memory operation. Compare distributions and individual bus events, not just average pulse widths. The CPU port outputs are inverted at the physical pins, so marker polarity differs from the written value. All four groups recur throughout the raster; video DMA and synchronization can affect individual intervals.

For a useful capture, record the marker at the physical sound-clock net (F3850 I/O-14), CPU PHI, CPU request 0 and 1, and UV201 DMA request 0. Add BRCLK, WACK, ROMC and WRITE where accessible. A video sync or raster reference helps associate wait times with display position. Record the probe points, sample rate, machine configuration, ROM checksum, capture duration and video state. Do not infer an access wait by subtracting raw pulse widths without accounting for instruction and bus cycles.

The raw cartridge SHA-256 is `f3236d9629838e1769d007cefb967e649036b853d2eb22553d96a78613e2f163`. Rebuild in WSL or Linux from this directory with `bash build_timing_baseline.sh`.

Further tests should separately cover UV201 register accesses, timer and interrupt latency, and DAC edge timing. They are not measured by this first workload.
