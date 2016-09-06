PROCESSOR PIC12F675

include p12f675.inc

CONFIG FOSC=INTRCIO
CONFIG WDTE=OFF
CONFIG PWRTE=ON
CONFIG MCLRE=OFF
CONFIG BOREN=OFF
CONFIG CP=OFF
CONFIG CPD=OFF

    CBLOCK H'20'
        DELAY2, DELAY1, DELAY0
    ENDC

DELAY MACRO
    LOCAL loop
    movlw 8
    movwf DELAY2
    clrf DELAY1
    clrf DELAY0

loop:
    decfsz DELAY0, F
    goto loop
    decfsz DELAY1, F
    goto loop
    decfsz DELAY2, F
    goto loop

    ENDM

init:
    clrf GPIO
    movlw 7
    movwf CMCON
    bsf STATUS, RP0
    clrf ANSEL
    movlw B'11111100'
    movwf TRISIO
    bcf STATUS, RP0

main:
    bsf GPIO, 0
    bcf GPIO, 1

    DELAY

    bcf GPIO, 0
    bsf GPIO, 1

    DELAY

    goto main

    END
