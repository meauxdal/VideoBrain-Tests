        processor F8
        org $1000
        db $aa,$55,$00
        db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
        jmp MAIN

MAIN:
        pi $40d0
        pi $41d5
        di

AGAIN:
WAIT_CONTROL:
        dci $08fb
        lm
        ci $20
        bf 4,WAIT_CONTROL
        li $ff
        lr 9,a
CONTROL:
        dci $0c10
        lis 0
        ds 9
        bf 4,CONTROL
        dci $08fb
        lm
        dci $0c00
        st

WAIT_READ:
        dci $08fb
        lm
        ci $20
        bf 4,WAIT_READ
        li $ff
        lr 9,a
RAM_READ:
        dci $0c10
        lm
        ds 9
        bf 4,RAM_READ
        dci $08fb
        lm
        dci $0c01
        st

WAIT_WRITE:
        dci $08fb
        lm
        ci $20
        bf 4,WAIT_WRITE
        li $ff
        lr 9,a
RAM_WRITE:
        dci $0c10
        st
        ds 9
        bf 4,RAM_WRITE
        dci $08fb
        lm
        dci $0c02
        st

WAIT_CART:
        dci $08fb
        lm
        ci $20
        bf 4,WAIT_CART
        li $ff
        lr 9,a
CART_READ:
        dci $1000
        lm
        ds 9
        bf 4,CART_READ
        dci $08fb
        lm
        dci $0c03
        st

        lis 0
        dci $0fdf
        st
        dci $0c00
        lm
        sr 4
        dci HEX_FONT
        adc
        lm
        lr 8,a
        pi $40d9
        pi $412d
        dci $0c00
        lm
        ni $0f
        dci HEX_FONT
        adc
        lm
        lr 8,a
        pi $40d9
        pi $412d
        dci $0c01
        lm
        sr 4
        dci HEX_FONT
        adc
        lm
        lr 8,a
        pi $40d9
        pi $412d
        dci $0c01
        lm
        ni $0f
        dci HEX_FONT
        adc
        lm
        lr 8,a
        pi $40d9
        pi $412d
        dci $0c02
        lm
        sr 4
        dci HEX_FONT
        adc
        lm
        lr 8,a
        pi $40d9
        pi $412d
        dci $0c02
        lm
        ni $0f
        dci HEX_FONT
        adc
        lm
        lr 8,a
        pi $40d9
        pi $412d
        dci $0c03
        lm
        sr 4
        dci HEX_FONT
        adc
        lm
        lr 8,a
        pi $40d9
        pi $412d
        dci $0c03
        lm
        ni $0f
        dci HEX_FONT
        adc
        lm
        lr 8,a
        pi $40d9
        pi $412d
STOP:
        br STOP

HEX_FONT:
        db 54,36,52,50,34,32,30,14,12,10,17,45,49,31,11,29

        org $17ff,0
        db 0
