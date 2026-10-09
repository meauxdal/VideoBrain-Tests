        processor F8
        org $0000

        li $00
        outs 0
        li $10
        outs 1
        lis 0
        outs 1

        li $01
        outs 0
        li $10
        outs 1
        lis 0
        outs 1

        li $02
        outs 0
        li $10
        outs 1
        lis 0
        outs 1

        li $03
        outs 0
        li $10
        outs 1
        lis 0
        outs 0
        li $10
        outs 1
STOP:
        br STOP
