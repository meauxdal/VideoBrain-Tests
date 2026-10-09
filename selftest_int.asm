        processor F8
        org $0000

        li $01
        outs $c
        li $00
        outs $d
        li $01
        outs $e                 ; External interrupt vector is $0180.
        dci $08f0
        li $64
        st
        dci $08f5
        li $00
        st
        dci $08f2
        li $00
        st
        dci $08f7
        li $4c
        st
        lis 0
        lr 0,a
        ei
WAIT:
        br WAIT

        org $0180,0
ISR:
        lr a,0
        inc
        lr 0,a
        dci $08f5
        st                      ; Advance background color at the Y compare.
        ei
        pop
        org $07ff,0
        db 0
