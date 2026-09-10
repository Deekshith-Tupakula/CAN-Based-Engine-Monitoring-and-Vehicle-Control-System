;/*
; * Standard ARM7TDMI Startup File for NXP LPC2129 Microcontroller
; * Window Glass Control Node
; */

Mode_USR        EQU     0x10
Mode_FIQ        EQU     0x11
Mode_IRQ        EQU     0x12
Mode_SVC        EQU     0x13
Mode_ABT        EQU     0x17
Mode_UND        EQU     0x1B
Mode_SYS        EQU     0x1F

I_Bit           EQU     0x80
F_Bit           EQU     0x40

UND_Stack_Size  EQU     0x00000004
SVC_Stack_Size  EQU     0x00000004
ABT_Stack_Size  EQU     0x00000004
FIQ_Stack_Size  EQU     0x00000004
IRQ_Stack_Size  EQU     0x00000080
USR_Stack_Size  EQU     0x00000400

Stack_Size      EQU     (UND_Stack_Size + SVC_Stack_Size + ABT_Stack_Size + \
                         FIQ_Stack_Size + IRQ_Stack_Size + USR_Stack_Size)

                AREA    STACK, NOINIT, READWRITE, ALIGN=3
Stack_Mem       SPACE   Stack_Size
__initial_sp

                AREA    RESET, CODE, READONLY
                ARM

Vectors         LDR     PC, Reset_Addr         
                LDR     PC, Undef_Addr
                LDR     PC, SWI_Addr
                LDR     PC, PAbt_Addr
                LDR     PC, DAbt_Addr
                NOP                            
                LDR     PC, IRQ_Addr
                LDR     PC, FIQ_Addr

Reset_Addr      DCD     Reset_Handler
Undef_Addr      DCD     Undef_Handler
SWI_Addr        DCD     SWI_Handler
PAbt_Addr       DCD     PAbt_Handler
DAbt_Addr       DCD     DAbt_Handler
                DCD     0                      
IRQ_Addr        DCD     IRQ_Handler
FIQ_Addr        DCD     FIQ_Handler

Undef_Handler   B       Undef_Handler
SWI_Handler     B       SWI_Handler
PAbt_Handler    B       PAbt_Handler
DAbt_Handler    B       DAbt_Handler
IRQ_Handler     B       IRQ_Handler
FIQ_Handler     B       FIQ_Handler

Reset_Handler   
                LDR     R0, =Stack_Mem
                MSR     CPSR_c, #Mode_IRQ:OR:I_Bit:OR:F_Bit
                MOV     SP, R0
                SUB     R0, R0, #IRQ_Stack_Size

                MSR     CPSR_c, #Mode_SYS
                MOV     SP, R0

                IMPORT  __main
                LDR     R0, =__main
                BX      R0

                END
