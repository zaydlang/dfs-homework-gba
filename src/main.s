.global main

.arm
.text

#include "video.s"
#include "dfs.s"
#include "text.inc"

.align 4
main:
    bl SetupVideo
    bl DrawHeader

    bl DFSWithPruning
    bl DrawResults

    b  Done





# NAME:       Done()
# PARAMETERS: none
# RETURNS:    none. (halts the cpu. will never return)
Done:
    @ disable interrupts
    ldr r0, =#0x04000208
    mov r1, #0
    str r1, [r0]

    @ halt the cpu till the next interrupt (which will never happen)
    swi 0x20000






# NAME:       DrawHeader()
# PARAMETERS: none
# RETURNS:    none. draws the basic header text to the screen

DrawHeader:
    push {lr}

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

    ldr r0, =text_ABCDEFGH
    mov r1, #0
    mov r2, #72
    mov r3, #1
    mov r4, #8
    bl DrawText

    pop {pc}






# NAME:       DrawResults()
# PARAMETERS: r0 = number of failures
#             r1 = number of successes
# RETURNS:    none. draws the dfs results to screen

DrawResults:
    push {r10, lr}

    mov r10, r1

    mov r1, #80
    mov r2, #0
    mov r3, #2
    bl DrawDec

    mov r0, r10
    mov r1, #80
    mov r2, #16
    mov r3, #3
    bl DrawDec

    pop {r10, pc}