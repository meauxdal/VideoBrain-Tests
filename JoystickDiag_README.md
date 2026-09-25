# VideoBrain joystick diagnostic

Set `Joystick` to `On` and cartridge type to `Standard`, then load `JoystickDiag.bin` through `F1 -> BIN -> Load Cartridge`. It scans pot channels 0 through 7 continuously. Channel 00 is P1 X, 01 P1 Y, 02 P2 X, 03 P2 Y, through 06 P4 X and 07 P4 Y. Each screen row shows two channels side by side; each channel record is eight hex digits.

Each row is four hexadecimal bytes, left to right:

1. Selected channel number
2. UV201 X-freeze (`08F8`)
3. UV201 Y-freeze low (`08F9`)
4. UV201 Y-freeze high/status (`08FA`): bit 7 is field, bit 1 is live Y bit 8, bit 0 is frozen Y bit 8

The screen refreshes continuously. Let it run with the stick untouched, then record a short video while slowly sweeping the stick through its range. The rows show the raw captures; game movement and directional thresholds are not involved.

`JoystickDiag.asm` is the source. The binary is assembled for a VideoBrain cartridge starting at `$1000`, with the program entry at `$1012`.
