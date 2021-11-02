
# NAME:       CheckConstraints(State state)
# PARAMETERS: r0 = the address of a state
# RETURNS:    r0 = 0 if any constraint fails. r0 = 1 otherwise

CheckConstraints:
    push {r4 - r10}
    ldmdb r0, {r2 - r9}

    # r2 - r9 contain variables A - H in that order.
    # r10     will be a scratch register

    # so, we need to check if a register is null, and if so, break
    .macro _SKIP_IF_NULL reg, label_to_skip_to
        ands \reg, \reg
        beq \label_to_skip_to
    .endm

    # A >= G
    CheckConstraints_1:
        _SKIP_IF_NULL r8, CheckConstraints_2 
        _SKIP_IF_NULL r2, CheckConstraints_2
        cmp r2, r8
        blt CheckConstraints_Fail

    # A < H
    CheckConstraints_2:
        _SKIP_IF_NULL r9, CheckConstraints_3
        _SKIP_IF_NULL r2, CheckConstraints_3
        cmp r2, r9
        bge CheckConstraints_Fail

    # |F - B| = 1
    CheckConstraints_3:
        _SKIP_IF_NULL r7, CheckConstraints_4
        _SKIP_IF_NULL r3, CheckConstraints_4
        subs r10, r7, r3

        neglt r10, r10

        cmp r10, #1
        bne CheckConstraints_Fail

    # G < H
    CheckConstraints_4:
        _SKIP_IF_NULL r9, CheckConstraints_5
        _SKIP_IF_NULL r8, CheckConstraints_5
        cmp r8, r9
        bge CheckConstraints_Fail

    # |G - C| = 1
    CheckConstraints_5:
        _SKIP_IF_NULL r4, CheckConstraints_6
        _SKIP_IF_NULL r8, CheckConstraints_6
        subs r10, r8, r4
        neglt r10, r10
        cmp r10, #1
        bne CheckConstraints_Fail

    # |H - C| is even
    CheckConstraints_6:
        _SKIP_IF_NULL r4, CheckConstraints_7
        _SKIP_IF_NULL r9, CheckConstraints_7
        sub r10, r9, r4
        tst r10, #1
        bne CheckConstraints_Fail

    # H != D
    CheckConstraints_7:
        _SKIP_IF_NULL r5, CheckConstraints_8
        _SKIP_IF_NULL r9, CheckConstraints_8
        cmp r9, r5
        beq CheckConstraints_Fail

    # D >= G
    CheckConstraints_8:
        _SKIP_IF_NULL r5, CheckConstraints_9
        _SKIP_IF_NULL r8, CheckConstraints_9
        cmp r5, r8
        blt CheckConstraints_Fail

    # D != C
    CheckConstraints_9:
        _SKIP_IF_NULL r5, CheckConstraints_10
        _SKIP_IF_NULL r4, CheckConstraints_10
        cmp r5, r4
        beq CheckConstraints_Fail

    # E != C
    CheckConstraints_10:
        _SKIP_IF_NULL r6, CheckConstraints_11
        _SKIP_IF_NULL r4, CheckConstraints_11
        cmp r6, r4
        beq CheckConstraints_Fail

    # E < D - 1
    CheckConstraints_11:
        _SKIP_IF_NULL r6, CheckConstraints_12
        _SKIP_IF_NULL r5, CheckConstraints_12
        sub r10, r5, #1
        cmp r6, r10
        bge CheckConstraints_Fail

    # E != H - 2
    CheckConstraints_12:
        _SKIP_IF_NULL r9, CheckConstraints_13
        _SKIP_IF_NULL r6, CheckConstraints_13
        sub r10, r9, #2
        cmp r9, r6
        beq CheckConstraints_Fail
    
    # G != F
    CheckConstraints_13:
        _SKIP_IF_NULL r8, CheckConstraints_14
        _SKIP_IF_NULL r7, CheckConstraints_14
        cmp r8, r7
        beq CheckConstraints_Fail
    
    # H != F
    CheckConstraints_14:
        _SKIP_IF_NULL r9, CheckConstraints_15
        _SKIP_IF_NULL r7, CheckConstraints_15
        cmp r9, r7
        beq CheckConstraints_Fail

    # C != F
    CheckConstraints_15:
        _SKIP_IF_NULL r7, CheckConstraints_16
        _SKIP_IF_NULL r4, CheckConstraints_16
        cmp r4, r7
        beq CheckConstraints_Fail

    # D != F
    CheckConstraints_16:
        _SKIP_IF_NULL r7, CheckConstraints_17
        _SKIP_IF_NULL r5, CheckConstraints_17
        cmp r5, r7
        beq CheckConstraints_Fail

    # |E - F| is odd
    CheckConstraints_17:
        _SKIP_IF_NULL r6, CheckConstraints_Pass
        _SKIP_IF_NULL r7, CheckConstraints_Pass
        sub r10, r6, r7
        tst r10, #1
        beq CheckConstraints_Fail

    ands r9, r9
    beq CheckConstraints_Pass
    b CheckConstraints_Pass

CheckConstraints_Pass:
    mov r0, #1
    b CheckConstraints_Return

CheckConstraints_Fail:
    mov r0, #0
    b CheckConstraints_Return

CheckConstraints_Return:
    pop {r4 - r10}
    bx lr