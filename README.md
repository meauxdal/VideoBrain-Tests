# VideoBrain diagnostics

| ROM | Purpose | Expected result |
| --- | --- | --- |
| [JoystickDiag.bin](JoystickDiag_README.md) | Scan all eight joystick pot channels and display UV201 freeze registers. | Raw raster captures change as each stick moves. |
| `dac_test.bin` | Latch DAC codes 0, 1, 2, 3 through CPU ports 0/1, then hold code 3. | Audio trace reports transitions to 1, 2, 3; no picture or continuous tone. |
| `selftest.rom` | Exercise CPU, RAM, UV201 object registers, DMA, FIFO and rendering without BIOS. | One solid 16x16 object at programmed X=40, Y=64, on a black background. |
| `selftest_int.rom` | Exercise UV201 Y compare, F3853 vector fetch and F8 interrupt return. | Background color increments at Y=100, producing a raster split. |
| [JoystickGain/cart.bin](JoystickGain/README.md) | Check BIOS joystick gain thresholds, multiplication, carry and clamping. | 19 RAM result records and completion byte `$A5`; no picture. |

JoystickDiag is a standard cartridge. The DAC and two selftest images start
at `$0000` and replace RES1; they cannot be loaded as ordinary cartridges.
JoystickGain uses a patched RES1 and a cartridge; see its README.

From the VideoBrain_MiSTer `verilator` directory, with the headless simulator built:

```sh
./obj_dir_headless/Vtop --res1 ../../VideoBrain-Tests/selftest.rom --frames 8 --shot-last --ascii
./obj_dir_headless/Vtop --res1 ../../VideoBrain-Tests/selftest_int.rom --frames 8 --shot-last --probe
./obj_dir_headless/Vtop --res1 ../../VideoBrain-Tests/dac_test.bin --frames 1 --max-cycles 30000 --audio-log dac_test.csv
```

The matching `.asm` files use DASM's F8 processor. Rebuild from this directory:

```sh
dasm dac_test.asm -f3 -odac_test.bin
dasm selftest.asm -f3 -oselftest.rom
dasm selftest_int.asm -f3 -oselftest_int.rom
dasm JoystickDiag.asm -f3 -oJoystickDiag.bin
```

`dac_test.csv` preserves a simulator capture of the DAC transitions. These
three RES1 diagnostics have not been validated on physical hardware.
