        processor F8
        org $1000

        db $aa,$55,$00
        db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00

START:
        jmp MAIN

MAIN:
        pi $40d0                 ; Initialize the F8 stack.
        pi $41d5                 ; Clear the BIOS text screen.

        di
        lis $0
        outs 1                    ; Disable and re-arm EJOY.
        dci $0fea
        lm
        oi $02
        dci $08f7
        st                        ; Preserve display mode and enable freeze.

SWEEP:
        dci $0c00
        lis $0
        st                        ; Channel index.
        dci $0c01
        lis $1
        st                        ; One-hot pot select.

CHANNEL:
        lis $0
        outs 1                    ; Hold EJOY disabled during selection.
        dci $0c01
        lm
        outs 0                    ; Select one pot channel.
        li $20
        lr $9,a
WAIT_REARM:
        ds $9
        bf $4,WAIT_REARM           ; Cross HBLANK with the selected pot stable.
        li $80
        outs 1                    ; Enable EJOY.

        li $ff
        lr $9,a
WAIT_SCAN_1:
        ds $9
        bf $4,WAIT_SCAN_1
        li $ff
        lr $9,a
WAIT_SCAN_2:
        ds $9
        bf $4,WAIT_SCAN_2

        lis $0
        outs 1                    ; Disable and re-arm EJOY.

        dci $08f8
        lm
        dci $0c02
        st
        dci $08f9
        lm
        dci $0c03
        st
        dci $08fa
        lm
        dci $0c04
        st                        ; Snapshot before BIOS drawing.

        dci $0c00
        lm
        sl 1
        sl 1
        sl 1
        dci $0fdf
        st                        ; Place this channel on its own row.

        dci $0c00
        lm
        lisu 2
        lisl 4
        lr (is),a                 ; PI overwrites A; save the byte first.
        pi $421e
        dci $0c02
        lm
        lisu 2
        lisl 4
        lr (is),a                 ; PI overwrites A; save the byte first.
        pi $421e
        dci $0c03
        lm
        lisu 2
        lisl 4
        lr (is),a                 ; PI overwrites A; save the byte first.
        pi $421e
        dci $0c04
        lm
        lisu 2
        lisl 4
        lr (is),a                 ; PI overwrites A; save the byte first.
        pi $421e

        dci $0c01
        lm
        sl 1
        dci $0c01
        st

        dci $0c00
        lm
        inc
        dci $0c00
        st
        ci $8
        bf $4,CHANNEL

        jmp SWEEP
