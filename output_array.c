// ***************************************************************************************************************************
// Program name: "Sort By Pointers".  This program demonstrates how to insert user input into an array through pointers       *
// allowing for agile sorting no matter how much is actually stored into each cell.                                           *
// The X86 functions control the flow of the program, inserts user input into the array by pointers, and sorts elements by    *
// comparing the value of each pointer in the array, the C++ function calls the directing asm function as well as receives    *
// the array after the program has completed, and the C function is used as an output function for printing the elements in   *
// the array.   Copyright (C) 2023  Jacob Berry                                                                               *                                                                              *
// This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License  *
// version 3 as published by the Free Software Foundation.                                                                    *
// This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied         *
// warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.     *
// A copy of the GNU General Public License v3 is available here:  <https://www.gnu.org/licenses/>.                           *
// ****************************************************************************************************************************


//========================================================================
// Author: Jacob Berry
// Email: jacobberry777@gmail.com
// Class: CPSC 240-03
// Assignment 3: Sort By Pointers
//========================================================================
// Program information
//   Program name: Sort By Pointers
//   Programming languages: Main function in C++; director, array input,
//                          array sorting functions in ASM; 
//                          output function in C.
//   Date program began: 2023-Sep-29
//   Date of last update: 2023-Oct-04
//   Comments reorganized: 2023-Oct-04
//   Files in the program: main.cpp, director.asm, input_array.asm, 
//                         output_array.c, sort_pointers.asm, run.sh
//========================================================================
// Content: Output function written in C - Takes the array location and size
// from director.asm and outputs the data by dereferencing each element of 
// the array 
// Environment: Tested using VirtualBox VM running Tuffix 2020
//========================================================================
#include <stdio.h>

extern void output_array(double * mydata[], long size);

void output_array(double * mydata[], long size)
{

    for (int i = 0; i < size; ++i)
    {
        printf("%1.8lf \n", *(mydata[i]));
    }

    return;
}
