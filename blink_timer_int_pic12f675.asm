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
    T0I_CNT
ENDC

    RADIX dec

    org 0x00
    goto init

    org 0x04

    btfss INTCON, T0IF
    goto int_end

    bcf INTCON, T0IF

    decfsz T0I_CNT, F
    goto int_end

    ; reset T0I_INT, flip output
    movlw 16
    movwf T0I_CNT

    movlw b'00000001'
    xorwf GPIO, F

int_end:
    retfie

init:
    ; set out: GPIO0, GPIO1
    clrf GPIO
    movlw 7
    movwf CMCON
    bsf STATUS, RP0
    clrf ANSEL
    movlw B'11111100'
    movwf TRISIO
    bcf STATUS, RP0

    ; set tmr0
    clrwdt
    bsf STATUS, RP0 ; bank 1
    movf OPTION_REG, W
    andlw b'00111111'
    movlw b'00000111' ; use interclock, prescalar on TMR0, 1:256
    movwf OPTION_REG
    bcf STATUS, RP0 ; bank 0
    bsf INTCON, T0IE
    clrf TMR0

    movlw 16
    movwf T0I_CNT

    ; set GIE
    bsf INTCON, GIE

main:
    goto main

    END
