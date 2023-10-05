#!/bin/bash


# Author: Jacob Berry
# Email: jberry19@csu.fullerton.edu
# Class: CPSC 240-03
# Assignment 3: Sort By Pointers

rm *.o
rm *.out

echo "Bash script for <Array Management System>"

echo "Assemble the modules written in ASM"
nasm -f elf64 -l director.lis -o director.o director.asm
nasm -f elf64 -l input_array.lis -o input_array.o input_array.asm
nasm -f elf64 -l sort_pointers.lis -o sort_pointers.o sort_pointers.asm

echo "Compile the C/C++ module main.cpp"
g++ -c -Wall -o main.o -m64 -no-pie -fno-pie main.cpp 
gcc -c -Wall -o output_array.o -m64 -no-pie -fno-pie output_array.c

echo "Link the object files"
g++ -m64 main.o director.o input_array.o output_array.o sort_pointers.o -fno-pie -no-pie -o main.out

echo "Run the program Array Management System"
./main.out

echo "The bash script file is now closing."