        processor F8
        org $0000

        li $20
        lr 1,a
        dci $0c00
        li $ff
FILL:
        st
        ds 1
        bf 4,FILL

        dci $0800
        li $00
        st
        dci $0810
        li $ec
        st
        dci $0820
        li $42
        st
        dci $0830
        li $10
        st
        dci $0840
        li $28
        st
        dci $0850
        li $40
        st
        dci $0870
        li $00
        st
        dci $08f5
        li $00
        st
        dci $08f2
        li $00
        st
        dci $08f7
        li $44
        st
STOP:
        br STOP
        org $07ff,0
        db 0
