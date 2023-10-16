.globl relu

.text
# ==============================================================================
# FUNCTION: Performs an inplace element-wise ReLU on an array of ints
# Arguments:
#   a0 (int*) is the pointer to the array
#   a1 (int)  is the # of elements in the array
# Returns:
#   None
# Exceptions:
#   - If the length of the array is less than 1,
#     this function terminates the program with error code 36
# ==============================================================================
relu:
    # Prologue

blt x0 a1 loop_start

li a0 36
j exit

loop_start:


    lw t0 0(a0)
    bge t0 x0 loop_continue

    li t0 0



loop_continue:
    sw t0 0(a0)
    addi a1 a1 -1
    addi a0 a0 4
    blt x0 a1 loop_start

loop_end:

    
    # Epilogue


    jr ra
