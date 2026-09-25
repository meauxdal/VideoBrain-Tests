        processor F8
        org $1000

        db $aa,$55,$00
        db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00

START:
        jmp MAIN

DRAW_BYTE:
        lisu 2
        lisl 4
        lr (is),a
        pi $421e                 ; BIOS draws one byte as two hex digits.
        pk

MAIN:
        pi $40d0                 ; Initialize the F8 stack.
        pi $41d5                 ; Clear the BIOS text screen.

        dci $08f7
        lis $2
        st                        ; Enable UV201 X/Y freeze.

SWEEP:
        dci $0c00
        lis $0
        st                        ; Channel index.
        dci $0c01
        lis $1
        st                        ; One-hot pot select.

CHANNEL:
        dci $0c01
        lm
        outs 0                    ; Select one pot channel.
        li $80
        outs 1                    ; Start one joystick scan.

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
        outs 1                    ; Re-arm for the next channel.

        dci $0c00
        lm
        sl 1
        sl 1
        sl 1
        dci $0fdf
        st                        ; Place this channel on its own row.

        dci $0c00
        lm
        pi DRAW_BYTE
        dci $08f8
        lm
        pi DRAW_BYTE
        dci $08f9
        lm
        pi DRAW_BYTE
        dci $08fa
        lm
        pi DRAW_BYTE

        dci $0c01
        lm
        sl 1
        st

        dci $0c00
        lm
        inc
        st
        ci $8
        bf $4,CHANNEL

        jmp SWEEP
