.globl matmul

.text
# =======================================================
# FUNCTION: Matrix Multiplication of 2 integer matrices
#   d = matmul(m0, m1)
# Arguments:
#   a0 (int*)  is the pointer to the start of m0
#   a1 (int)   is the # of rows (height) of m0
#   a2 (int)   is the # of columns (width) of m0
#   a3 (int*)  is the pointer to the start of m1
#   a4 (int)   is the # of rows (height) of m1
#   a5 (int)   is the # of columns (width) of m1
#   a6 (int*)  is the pointer to the the start of d
# Returns:
#   None (void), sets d = matmul(m0, m1)
# Exceptions:
#   Make sure to check in top to bottom order!
#   - If the dimensions of m0 do not make sense,
#     this function terminates the program with exit code 38
#   - If the dimensions of m1 do not make sense,
#     this function terminates the program with exit code 38
#   - If the dimensions of m0 and m1 don't match,
#     this function terminates the program with exit code 38
# =======================================================
matmul:

    # Error checks
    li t3 1
    blt a1 t3 send_error
    blt a2 t3 send_error
    blt a4 t3 send_error
    blt a5 t3 send_error
    bne a2 a4 send_error
    j skip_error
send_error:
    li a0 38
    j exit

    # Prologue
skip_error:    
#holds the height and the number of times to do the outer loop
add t1 x0 a1

addi sp sp -4
sw ra 0(sp)

#columns
outer_loop_start:


#t0 hold the number of times I need to iterate the inner loop, or the width of m0

    mv t0 a5
    
    #t3 hold the pointer to the second matrix
    mv t3 a3

#rows
inner_loop_start:
    #   a0 (int*) is the pointer to the start of arr0
    #   a1 (int*) is the pointer to the start of arr1
    #   a2 (int)  is the number of elements to use
    #   a3 (int)  is the stride of arr0
    #   a4 (int)  is the stride of arr1
    
    
    #save the values of a registers
    addi sp sp -40
    sw a0 0(sp)
    sw a1 4(sp)
    sw a2 8(sp)
    sw a3 12(sp)
    sw a4 16(sp)
    sw t0 20(sp)
    sw t1 24(sp)
    sw a5 28(sp)
    sw a6 32(sp)
    sw t3 36(sp)
    
    add a1 x0 t3
    add a2 x0 a2
    addi a3 x0 1
    add a4 x0 a5
    jal ra dot
    #a0 has the value i need
    
    lw a6 32(sp)
    sw a0 0(a6)
    addi a6 a6 4
    
    #load back the a registers
    lw a0 0(sp)
    lw a1 4(sp)
    lw a2 8(sp)
    lw a3 12(sp)
    lw a4 16(sp)
    lw t0 20(sp)
    lw t1 24(sp)
    lw a5 28(sp)
    lw t3 36(sp)
    addi sp sp 40
    

    
    #move to the next col
    addi t3 t3 4
    
    





    addi t0 t0 -1
    beq t0 x0 inner_loop_end
    j inner_loop_start



inner_loop_end:


#move to the next row

mv t4 a2
slli t4 t4 2

add a0 a0 t4
addi t1 t1 -1
beq t1 x0 outer_loop_end

j outer_loop_start

outer_loop_end:


    # Epilogue

    lw ra 0(sp)
    addi sp sp 4
    jr ra
