; 01 - Blink Built-in LED using SBI and CBI
;
; Board: Arduino Nano
; MCU:   ATmega328P
; LED:   D13 / PB5
;
; Goal:
; Configure PB5 as an output, then repeatedly turn it on and off.

.global main

.equ DDRB,  0x04        ; Port B data direction register
.equ PORTB, 0x05        ; Port B output register
.equ PB5,   5           ; Arduino Nano built-in LED / D13

main:
    sbi DDRB, PB5       ; Set PB5 as output

loop:
    sbi PORTB, PB5      ; Turn LED on
    rcall delay

    cbi PORTB, PB5      ; Turn LED off
    rcall delay

    rjmp loop           ; Repeat forever


delay:
    ldi r18, 255        ; Big loop counter

big_loop:
    ldi r19, 255        ; Middle loop counter

middle_loop:
    ldi r20, 50         ; Small loop counter

small_loop:
    dec r20             ; r20--
    brne small_loop     ; Repeat until r20 becomes zero

    dec r19             ; r19--
    brne middle_loop    ; Repeat middle loop until r19 becomes zero

    dec r18             ; r18--
    brne big_loop       ; Repeat big loop until r18 becomes zero

    ret