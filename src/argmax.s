.globl argmax

.text
# =================================================================
# FUNCTION: Given a int array, return the index of the largest
#   element. If there are multiple, return the one
#   with the smallest index.
# Arguments:
#   a0 (int*) is the pointer to the start of the array
#   a1 (int)  is the # of elements in the array
# Returns:
#   a0 (int)  is the first index of the largest element
# Exceptions:
#   - If the length of the array is less than 1,
#     this function terminates the program with error code 36
# =================================================================
argmax:
    # Prologue
    
#initialize the index to be 0
add t2 x0 x0    

#initialize the largest index to be 0
add t3 x0 x0

#initialize the current smallest value to be the first value 
lw t1 0(a0)



blt x0 a1 loop_start
li a0 36
j exit

loop_start:

    lw t0 0(a0)
    bge t1 t0 loop_continue
    
    #t1 holds the largest value so far
    mv t1 t0
    
    #t2 holds the largest index so far
    mv t3 t2


loop_continue:
    addi a1 a1 -1
    addi t2 t2 1
    addi a0 a0 4
    blt x0 a1 loop_start

loop_end:
    # Epilogue

    mv a0 t3
    jr ra
