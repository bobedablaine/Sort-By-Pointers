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
; Content: Sorting function written in ASM - Receives the location of an
; array and size of said array and uses this information to sort the
; elements of the array of pointers by comparing each element after
; dereferencing them. Sorts the array by changing where the array is
; pointing to, never by value of the pointers.
; Environment: Tested using VirtualBox VM running Tuffix 2020
;========================================================================

;===== Begin code area ===========================================================================

global sort_pointers


segment .data


segment .bss

align 64                                          ;Insure that the inext data declaration starts on a 64-byte boundary.
backuparea resb 832                               ;Create an array for backup storage having 832 bytes.

segment .text

sort_pointers:

;Back up the general purpose registers for the sole purpose of protecting the data of the caller.
push rbp                                          ;Backup rbp
mov  rbp,rsp                                      ;The base pointer now points to top of stack
push rdi                                          ;Backup rdi
push rsi                                          ;Backup rsi
push rdx                                          ;Backup rdx
push rcx                                          ;Backup rcx
push r8                                           ;Backup r8
push r9                                           ;Backup r9
push r10                                          ;Backup r10
push r11                                          ;Backup r11
push r12                                          ;Backup r12
push r13                                          ;Backup r13
push r14                                          ;Backup r14
push r15                                          ;Backup r15
push rbx                                          ;Backup rbx
pushf                                             ;Backup rflags

; Backup all 3 components
mov     rax, 7
mov     rdx, 0
xsave   [backuparea]

; Save the start of the array and count into r14 and r15
mov     r14, rdi
mov     r15, rsi

; For bubble sort i need to loop n-1 times
dec     r15

; Sort the array using the Bubble Sort method
xor     r13, r13
beginbubble:
cmp     r13, r15
je done
cmp     r13, r15
xor     rbx, rbx
mov     rbp, r15
sub     rbp, r13

; Inner bubble is for passing the length of the array for each element
innerbubble:
cmp     rbx, rbp
je incrementouter
mov     r11, [r14+8*rbx]
mov     r8, [r11]
inc     rbx
mov     r12, [r14+8*rbx]
mov     r9, [r12]
xor     rcx, rcx
cmp     r8, rcx
jl checknegatives
notnegatives:
cmp     r8, r9
jg swapelements
jmp innerbubble

; Swap elements is for swapping the pointers when the value of the first cell 
; checked is greater than the second
swapelements:
dec     rbx
mov     r10, [r14+8*rbx]
mov     [r14+8*rbx], r12
inc     rbx
mov     [r14+8*rbx], r10
jmp innerbubble

incrementouter:
inc     r13
jmp beginbubble

; NASM doesn't read negative numbers in the way i need it to so
; i must flip the way it reads the comparison if both inputs are
; negative
checknegatives:
cmp     r9, rcx
jl bothnegatives
jmp notnegatives

bothnegatives:
cmp     r8, r9
jl swapelements
jmp innerbubble

done:

;Restore all 3 components
mov     rax, 7
mov     rdx, 0
xrstor [backuparea]

;Restore all the previously pushed registers.
popf                                    ;Restore rflags
pop rbx                                 ;Restore rbx
pop r15                                 ;Restore r15
pop r14                                 ;Restore r14
pop r13                                 ;Restore r13
pop r12                                 ;Restore r12
pop r11                                 ;Restore r11
pop r10                                 ;Restore r10
pop r9                                  ;Restore r9
pop r8                                  ;Restore r8
pop rcx                                 ;Restore rcx
pop rdx                                 ;Restore rdx
pop rsi                                 ;Restore rsi
pop rdi                                 ;Restore rdi
pop rbp                                 ;Restore rbp

ret                                     ;Pop the integer stack and jump to the address equal to the popped value.

;============== End of Module =============
