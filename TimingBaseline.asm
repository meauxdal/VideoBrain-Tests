        processor F8
        org $1000

        db $aa,$55,$00
        db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00

START:
        jmp MAIN

MAIN:
        di
        lis 0
        outs 1

REPEAT:
        li $02
        lr 7,a
SYNC_OUTER:
        li $ff
        lr 8,a
SYNC:
        ds 8
        bf 4,SYNC
        ds 7
        bf 4,SYNC_OUTER

        li $40
        lr 9,a
CONTROL:
        li $10
        outs 1
        dci $0c80
        lis 0
        outs 1
        ds 9
        bf 4,CONTROL

        li $ff
        lr 8,a
GAP1:
        ds 8
        bf 4,GAP1

        li $40
        lr 9,a
RAM_READ:
        li $10
        outs 1
        dci $0c80
        lm
        lis 0
        outs 1
        ds 9
        bf 4,RAM_READ

        li $ff
        lr 8,a
GAP2:
        ds 8
        bf 4,GAP2

        li $40
        lr 9,a
RAM_WRITE:
        li $10
        outs 1
        dci $0c80
        st
        lis 0
        outs 1
        ds 9
        bf 4,RAM_WRITE

        li $ff
        lr 8,a
GAP3:
        ds 8
        bf 4,GAP3

        li $40
        lr 9,a
CART_READ:
        li $10
        outs 1
        dci $1000
        lm
        lis 0
        outs 1
        ds 9
        bf 4,CART_READ
        jmp REPEAT

        org $17ff,0
        db 0
