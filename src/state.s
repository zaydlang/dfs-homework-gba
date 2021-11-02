
# NAME:       IsGoal(State state)
# PARAMETERS: r0 = the address of a state
# RETURNS:    r0 = 1 if the state is a goal node. r0 = 0 otherwise

IsGoal:
    push {lr}

    # save r0
    mov r2, r0

    # a state cannot have any null variables. they must all be assigned.
    mov r3, #0x8
    IsGoalLoop:
        ldr r1, [r2], #4
        ands r1, r1
        beq IsGoal_Fail

        subs r3, #1
        bne IsGoalLoop

    mov r0, #1
    pop {pc}
    
IsGoal_Fail:
    mov r0, #0
    pop {pc}





# NAME:       GetFirstNullVariable(State state)
# PARAMETERS: r0 = the address of a state
# RETURNS:    r0 = the id of the first null variable (assuming one exists).
#                  0 = A, 7 = H.

GetFirstNullVariable:
    mov r1, #0

    GetFirstNullVariable_Loop:
        ldr r2, [r0, r1, lsl #2]
        ands r2, r2
        beq GetFirstNullVariable_LoopEnd

        add r1, #1
        cmp r1, #8
        bne GetFirstNullVariable_Loop
    GetFirstNullVariable_LoopEnd:

    mov r0, r1
    bx lr