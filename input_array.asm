; ***************************************************************************************************************************
; Program name: "Sort By Pointers".  This program demonstrates how to insert user input into an array through pointers       *
; allowing for agile sorting no matter how much is actually stored into each cell.                                           *
; The X86 functions control the flow of the program, inserts user input into the array by pointers, and sorts elements by    *
; comparing the value of each pointer in the array, the C++ function calls the directing asm function as well as receives    *
; the array after the program has completed, and the C function is used as an output function for printing the elements in   *
; the array.   Copyright (C) 2023  Jacob Berry                                                                               *                                                                              *
; This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License  *
; version 3 as published by the Free Software Foundation.                                                                    *
; This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied         *
; warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.     *
; A copy of the GNU General Public License v3 is available here:  <https://www.gnu.org/licenses/>.                           *
; ****************************************************************************************************************************


;========================================================================
; Author: Jacob Berry
; Email: jacobberry777@gmail.com
; Class: CPSC 240-03
; Assignment 3: Sort By Pointers
;========================================================================
; Program information
;   Program name: Sort By Pointers
;   Programming languages: Main function in C++; director, array input,
;                          array sorting functions in ASM; 
;                          output function in C.
;   Date program began: 2023-Sep-29
;   Date of last update: 2023-Oct-04
;   Comments reorganized: 2023-Oct-04
;   Files in the program: main.cpp, director.asm, input_array.asm, 
;                         output_array.c, sort_pointers.asm, run.sh
;========================================================================
; Content: Input function written in ASM - Receives user input and by 
; allocating a space on the heap, using malloc, inputs the address of a 
; float number into the array. Returns the number of elements in the array.
; Environment: Tested using VirtualBox VM running Tuffix 2020
;========================================================================

;===== Begin code area ======================================================================

extern scanf                                    ;External function for input
extern malloc

global input_array

segment .data

;====== Declare format ====================================================================
floatform db "%lf", 10, 0

segment .bss

align 64                                        ;Insure that the inext data declaration starts on a 64-byte boundary.
backuparea resb 832                             ;Create an array for backup storage having 832 bytes.

segment .text

input_array:                                    ;Entry point. Execution begins

;=========== Backup the Registers =========================================================

push       rbp                                              ;Save a copy of the stack base pointer
mov        rbp, rsp                                         ;We do this in order to be 100% compatible with C and C++.
push       rbx                                              ;Back up rbx
push       rcx                                              ;Back up rcx
push       rdx                                              ;Back up rdx
push       rsi                                              ;Back up rsi
push       rdi                                              ;Back up rdi
push       r8                                               ;Back up r8
push       r9                                               ;Back up r9
push       r10                                              ;Back up r10
push       r11                                              ;Back up r11
push       r12                                              ;Back up r12
push       r13                                              ;Back up r13
push       r14                                              ;Back up r14
push       r15                                              ;Back up r15
pushf                                                       ;Back up rflags

; Backup all 3 components
mov     rax, 7
mov     rdx, 0
xsave   [backuparea]

;Store parameters into registers
mov     r14, rdi                      ;r14 holds starting location of array
mov     r15, rsi                      ;r15 holds the number of cells in the array

;Loop for the user input into array
xor     r13, r13                      ;r13 is for keeping count of the loop/array index
begin:
cmp     r13, r15
je done
mov     rax, 0
mov     rdi, 8
call    malloc
mov     r12, rax
mov     rdi, floatform
mov     rsi, r12
call    scanf
cdqe
cmp     rax, -1                       ;Check for CTRL-D
je done
mov     [r14+8*r13], r12
inc     r13                           ;Keep count of index
jmp begin

done:

; Restore all 3 components
mov     rax, 7
mov     rdx, 0
xrstor [backuparea]

mov     rax, r13                      ;Return count of cells in array

;Restore the original values to the GPRs
popf                                                        ;Restore rflags
pop        r15                                              ;Restore r15
pop        r14                                              ;Restore r14
pop        r13                                              ;Restore r13
pop        r12                                              ;Restore r12
pop        r11                                              ;Restore r11
pop        r10                                              ;Restore r10
pop        r9                                               ;Restore r9
pop        r8                                               ;Restore r8
pop        rdi                                              ;Restore rdi
pop        rsi                                              ;Restore rsi
pop        rdx                                              ;Restore rdx
pop        rcx                                              ;Restore rcx
pop        rbx                                              ;Restore rbx
pop        rbp                                              ;Restore rbp

ret 

;============== End of Module =============
