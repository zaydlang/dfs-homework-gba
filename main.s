.global main

.data
text_failures:
    .byte 5
    .byte 0
    .byte 8
    .byte 11
    .byte 20
    .byte 17
    .byte 4
    .byte 18

text_passes:
    .byte 15
    .byte 0
    .byte 18
    .byte 18
    .byte 4
    .byte 18

goals:

.arm
.text

#include "video.s"
#include "dfs.s"

main:
    bl SetupVideo

    ldr r0, =text_failures
    mov r1, #0
    mov r2, #0
    mov r3, #1
    mov r4, #8
    bl DrawText

    ldr r0, =text_passes
    mov r1, #0
    mov r2, #16
    mov r3, #1
    mov r4, #6
    bl DrawText

    bl DFSWithPruning
    mov r10, r1

    mov r1, #80
    mov r2, #0
    mov r3, #1
    bl DrawHex

    mov r0, r10
    mov r1, #80
    mov r2, #16
    mov r3, #1
    bl DrawHex

    b Infin

.ltorg

Infin:
    b Infin