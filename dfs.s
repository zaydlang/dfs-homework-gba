
#include "state.s"
#include "constraints.s"

# NAME:       DFSWithPruning()
# PARAMETERS: none
# RETURNS:    r0 = number of failures, r1 = number of successes

DFSWithPruning:
    push {r4 - r10, lr}

    # r4  : the address of the beginning of our frontier.
    # r5  : the address of the next element of the frontier (empty ascending)
    # r6  : the size of the frontier.
    # r7  : scratch
    # r8  : number of successes
    # r9  : number of failures
    # r10 : scratch

    # we'll just put this at the beginning of ram.
    ldr r4, =#0x03000000
    mov r5, r4
    
    # zero out the first state in the frontier
    mov r7,  #0
    str r7, [r5], #4
    str r7, [r5], #4
    str r7, [r5], #4
    str r7, [r5], #4
    str r7, [r5], #4
    str r7, [r5], #4
    str r7, [r5], #4
    str r7, [r5], #4

    # our frontier size is 1 now
    mov r6, #1
    mov r8, #0
    mov r9, #0

    DFSWithPruning_Loop:
        ands r6, r6
        beq DFSWithPruning_LoopEnd

        # pop an element off the frontier
        mov r1, r5
        sub r6, #1
        mov r0, r5
        sub r5, #32

        @ do we violate any constraints
        bl CheckConstraints
        tst r0, #1
        addeq r9, #1
        beq DFSWithPruning_Loop

        @ are we a goal node
        mov r0, r5
        bl IsGoal
        tst r0, #1
        addne r8, #1
        bne DFSWithPruning_Loop

        # we need to push 4 more states to the stack now. lets copy the popped element in the frontier
        # three more times first.
        mov r10, #24
        add r5, #32
        
        mov r2, r5
        mov r3, r5
        subs r3, #32
        DFSWithPruning_FillStackLoop:
            ldr r7, [r3], #4
            str r7, [r2], #4
            subs r10, #1
            bne DFSWithPruning_FillStackLoop
        mov r4, r2

        # let's start by getting the variable id that we want to edit
        mov r0, r5
        bl GetFirstNullVariable

        subs r5, #32

        mov r10, #1
        str r10, [r5, r0, lsl #2]
        add r5, #32

        mov r10, #2
        str r10, [r5, r0, lsl #2]
        add r5, #32

        mov r10, #3
        str r10, [r5, r0, lsl #2]
        add r5, #32

        mov r10, #4
        str r10, [r5, r0, lsl #2]
        add r5, #32

        add r6, #4

        b DFSWithPruning_Loop 
    
DFSWithPruning_LoopEnd:
    mov r0, r9
    mov r1, r8
    pop {r4 - r10, pc}