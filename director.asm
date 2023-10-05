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
; Content: Director function written in ASM - Main controller of the 
; program, organizes output and controls the flow of calling input_array,
; output_array, and sort_pointers to achieve the desired result of the 
; program.
; Environment: Tested using VirtualBox VM running Tuffix 2020
;========================================================================

;===== Begin code area ======================================================================

extern printf                                   ;External function for output
extern input_array                              ;External function for input
extern output_array                             ;External function for outputting numbers in array
extern sort_pointers                            ;External function for sorting elements in array

global director                                 ;Allows manager to be called by other functions

max_size equ 8                                  ;Set max size of the array

segment .data

;===== Declare messages ======================================================================

initialmessage db "This program will sort all of your doubles", 10, 0

inputprompt db "Please enter floating point numbers separated by white space. After the last numeric input enter at least one more white space and press cntl+d.", 10, 0

afterinput db "Thank you.  You entered these numbers", 10, 0

afteroutput db "End of output of array.", 10, 0

beforesort db "The array is now being sorted without moving any numbers.", 10, 0

sortprompt db "The data in the array are now ordered as follows", 10, 0

endmessage db "The array will be sent back to the caller function.", 10, 0

stringformat db "%s", 0                                      ;general string format

newline db "", 10, 0

segment .bss
;===== Begin executable instructions ======================================================
align 64                                                    ;Insure that the inext data declaration starts on a 64-byte boundary.
backuparea resb 832                                         ;Create an array for backup storage having 832 bytes.

nicearray resq max_size
sendback resq 2

segment .text                                               ;Place executable instructions in this segment.

director:                                                   ;Entry point.  Execution begins here.

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

; Output initial message
push qword 0
mov     rax, 0
mov     rdi, stringformat
mov     rsi, initialmessage
call    printf
pop     rax

; Output prompt for user input
push qword 0
mov     rax, 0
mov     rdi, stringformat
mov     rsi, inputprompt
call    printf
pop     rax

; Call input_array for user input
mov     rax, 0
mov     rdi, nicearray                                ;Passes the starting point of the array
mov     rsi, max_size                                 ;Passes the max cell count of the array
call    input_array
mov     r13, rax                                      ;Count of elements in the array is returned

; Newline for clean display
push qword 0
mov     rax, 0
mov     rdi, newline
call    printf
pop     rax

; Output message prior to listing elements in the array
push qword 0
mov     rax, 0
mov     rdi, stringformat
mov     rsi, afterinput
call    printf
pop     rax

; Block to call output_array to print the numbers stored in the pointers in the array
mov    rax, 0
mov    rdi, nicearray
mov    rsi, r13
call   output_array

; Output message marking end of output array
push qword 0
mov     rax, 0
mov     rdi, stringformat
mov     rsi, afteroutput
call    printf
pop     rax

; Output message informing user of sorting occuring
push qword 0
mov     rax, 0
mov     rdi, stringformat
mov     rsi, beforesort
call    printf
pop     rax

; Output message marking the begining of sorting
push qword 0
mov     rax, 0
mov     rdi, stringformat
mov     rsi, sortprompt
call    printf
pop     rax

; Call external fuction to sort the pointers in the array by their value
mov     rax, 0
mov     rdi, nicearray
mov     rsi, r13
call    sort_pointers

; Block to call output_array to print the numbers stored in the pointers in the array
mov    rax, 0
mov    rdi, nicearray
mov    rsi, r13
call   output_array

; Output message marking end of output array
push qword 0
mov     rax, 0
mov     rdi, stringformat
mov     rsi, afteroutput
call    printf
pop     rax

; Output ending message to the user
push qword 0
mov     rax, 0
mov     rdi, stringformat
mov     rsi, endmessage
call    printf
pop     rax

; Send back array count/location
mov [sendback+0*8], r13
mov r14, nicearray
mov [sendback+1*8], r14

; Restore all 3 components
mov     rax, 7
mov     rdx, 0
xrstor [backuparea]

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

mov     rax, sendback

ret 

;============== End of Module =============
