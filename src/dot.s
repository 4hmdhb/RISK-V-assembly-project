.globl dot

.text
# =======================================================
# FUNCTION: Dot product of 2 int arrays
# Arguments:
#   a0 (int*) is the pointer to the start of arr0
#   a1 (int*) is the pointer to the start of arr1
#   a2 (int)  is the number of elements to use
#   a3 (int)  is the stride of arr0
#   a4 (int)  is the stride of arr1
# Returns:
#   a0 (int)  is the dot product of arr0 and arr1
# Exceptions:
#   - If the number of elements to use is less than 1,
#     this function terminates the program with error code 36
#   - If the stride of either array is less than 1,
#     this function terminates the program with error code 37
# =======================================================
dot:

    # Prologue

# t1 stride for first array in bytes

li t1 1

blt a3 t1 term

blt a4 t1 term

j else

term:
li a0 37
j exit

else:


mv t1 a3
slli t1 t1 2



# t2 stride for the second array in bytes
mv t2 a4
slli t2 t2 2

# t3 dot product so far

mv t3 x0


blt x0 a2 loop_start
li a0 36
j exit

loop_start:

    lw t4 0(a0)
    lw t5 0(a1)

    mul t6 t4 t5
    add t3 t3 t6
    


    add a0 a0 t1
    add a1 a1 t2

    addi a2 a2 -1


    blt x0 a2 loop_start



loop_end:

    


    # Epilogue
    mv a0 t3

    jr ra
