
#include "font.inc"

# NAME:       SetupVideo()
# PARAMETERS: none
# RETURNS:    none. sets video to mode 4 and sets up palette ram

SetupVideo:
    # set DISPCNT to mode 4, and enable BG2
    ldr r0, =#0x04000000
	ldr r1, =#0x0404
	str r1, [r0]

    # store white/black into palette ram
    ldr r0, =#0x05000000
    ldr r1, =#0x00007FFF
    str r1, [r0]

    bx lr





# NAME:       DrawHex()
# PARAMETERS: r0 - hex number to display
#             r1 - x position to start at
#             r2 - y position to start at
#             r3 - the color to use (byte)
# RETURNS:    none. draws the hex number to screen

DrawHex:
    push {r0-r12, lr}
    ldr r5, =HEX_FONT

    ldr r9, =#0x06000000
    ldr r4, =#240
    mla r1, r4, r2, r1
    add r9, r1
    
    mov r2, #0x8
    DrawHex_Number:
        and r4, r0, #0xF0000000
        lsr r4, #28

        mov r10, #0x8
        lsl r6, r4, #0x3
        add r6, r5

        DrawHex_NibbleLoop:
            ldrb r7, [r6], #0x1

            mov r11, #0x8
            DrawHex_Row:
                eor r12, r12

                ands r8, r7, #0x1
                lsr r7, #0x1

                orrne r12, r3, lsl #0x8

                ands r8, r7, #0x1
                lsr r7, #0x1

                orrne r12, r3

                strh r12, [r9, r11]

                subs r11, #0x2
                bne DrawHex_Row
            
            add r9, #240
            subs r10, #0x1
            bne DrawHex_NibbleLoop
        
        ldr r10, =#1912
        sub r9, r10
        lsl r0, #0x4
        subs r2, #0x1
        bne DrawHex_Number
    
    pop {r0-r12, pc}






# NAME:       DrawText()
# PARAMETERS: r0 - address of the text to display
#             r1 - x position to start at
#             r2 - y position to start at
#             r3 - the color to use (byte)
#             r4 - the length of the text
# RETURNS:    none. draws the text to screen

DrawText:
    push {r0-r12, lr}
    ldr r5, =TEXT_FONT

    ldr r9, =#0x06000000
    ldr r8, =#240
    mla r1, r8, r2, r1
    add r9, r1
    
    mov r2, r4
    DrawText_Character:
        ldrb r4, [r0], #1

        mov r10, #0x8
        lsl r6, r4, #0x3
        add r6, r5

        DrawText_NibbleLoop:
            ldrb r7, [r6], #0x1

            mov r11, #0x8
            DrawText_Row:
                eor r12, r12

                ands r8, r7, #0x1
                lsr r7, #0x1

                orrne r12, r3, lsl #0x8

                ands r8, r7, #0x1
                lsr r7, #0x1

                orrne r12, r3

                strh r12, [r9, r11]

                subs r11, #0x2
                bne DrawText_Row
            
            add r9, #240
            subs r10, #0x1
            bne DrawText_NibbleLoop
        
        ldr r10, =#1912
        sub r9, r10
        subs r2, #0x1
        bne DrawText_Character
    
    pop {r0-r12, pc}
