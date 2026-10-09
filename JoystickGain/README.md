# BIOS joystick gain diagnostic

`cart.bin` runs 19 controlled span/delta cases through the BIOS routine at
`$225E`. `plan.json` lists inputs and expected gain, product and result.
`expected_state.txt` preserves a passing simulator RAM dump.

Results start at `$0C00`, with three bytes per case: clamped result, product
high, product low. `$0C80 = $A5` marks completion. The result is
`min(199, (delta * gain) >> 4)`. Gain thresholds are 1333, 1599, 1867 and 2399,
with gains 8, 6, 4, 3 and 2. Cases cover both sides of every threshold,
byte carry, zero and the output clamp. This tests BIOS arithmetic, not pots.

`joystick_gain_check.py` is the ROM source and checker. It requires Python 3
and the 2048-byte `uvres-1n-2129-7802` RES1 BIOS. It patches the reset jump
to `$1012`, retaining the stack helpers used by the cartridge. Supply your
own BIOS; the patched image is generated locally.

From this directory:

```sh
python joystick_gain_check.py --bios /path/to/uvres-1n-2129-7802.bin
python joystick_gain_check.py --bios /path/to/uvres-1n-2129-7802.bin --sim /path/to/verilator/obj_dir_headless/Vtop
```

The first command writes `out/cart.bin`, `out/res1.bin` and `out/plan.json`.
The second also runs the simulator and checks gain selection and RAM results.
The screen stays blank. This test requires the named BIOS revision and has
not been validated on physical hardware.
