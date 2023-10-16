.globl classify

.text
# =====================================
# COMMAND LINE ARGUMENTS
# =====================================
# Args:
#   a0 (int)        argc
#   a1 (char**)     argv
#   a1[1] (char*)   pointer to the filepath string of m0
#   a1[2] (char*)   pointer to the filepath string of m1
#   a1[3] (char*)   pointer to the filepath string of input matrix
#   a1[4] (char*)   pointer to the filepath string of output file
#   a2 (int)        silent mode, if this is 1, you should not print
#                   anything. Otherwise, you should print the
#                   classification and a newline.
# Returns:
#   a0 (int)        Classification
# Exceptions:
#   - If there are an incorrect number of command line args,
#     this function terminates the program with exit code 31
#   - If malloc fails, this function terminates the program with exit code 26
#
# Usage:
#   main.s <M0_PATH> <M1_PATH> <INPUT_PATH> <OUTPUT_PATH>



classify:



j no_error
malloc_error:
li a0 26
j exit


arg_error:
li a0 31
j exit

no_error:
    li t5 5
    bne a0 t5 arg_error

    addi sp sp -52
    sw s0 0(sp)
    sw s2 4(sp)
    sw s3 8(sp)
    sw s4 12(sp)
    sw s5 16(sp)
    sw s6 20(sp)
    sw s7 24(sp)
    sw s8 28(sp)
    sw s9 32(sp)
    sw s10 36(sp)
    sw s11 40(sp)
    sw s1 44(sp)
    sw ra 48(sp)
   

    addi sp sp -12
    sw a0 0(sp)
    sw a1 4(sp)
    sw a2 8(sp)


    # Read pretrained m0
    lw a0 4(a1)
    addi sp sp -8
    addi a1 sp 0
    addi a2 sp 4
    jal ra read_matrix
    
    mv s0 a0
    lw s1 0(sp)
    lw s2 4(sp)
    
    addi sp sp 8
    

    
    
    
    
    


    # Read pretrained m1
    
    lw a1 4(sp)
    
    lw a0 8(a1)
    addi sp sp -8
    addi a1 sp 0
    addi a2 sp 4
    jal ra read_matrix
    
    mv s3 a0
    lw s4 0(sp)
    lw s5 4(sp)
    
    addi sp sp 8


    # Read input matrix
    
    lw a1 4(sp)
    
    lw a0 12(a1)
    addi sp sp -8
    addi a1 sp 0
    addi a2 sp 4
    jal ra read_matrix
    
    mv s6 a0
    lw s7 0(sp)
    lw s8 4(sp)
    
    addi sp sp 8


    # Compute h = matmul(m0, input)

    # h has s1 rows and s8 cols
    mul s10 s1 s8
    slli t0 s10 2
    

    mv a0 t0
    jal ra malloc
    beq a0 x0 malloc_error
    mv a6 a0
    
    #save output into h or s9
    mv s9 a0

    mv a0 s0
    mv a1 s1
    mv a2 s2
    mv a3 s6
    mv a4 s7
    mv a5 s8
    

    
    jal ra matmul
    



    #free m0 since i don't need it anymore  
    mv a0 s0
    jal ra free
    
    
    #free input matrix since i dont need it anymore
    mv a0 s6
    jal ra free

    # Compute h = relu(h)
    
    mv a0 s9
    mv a1 s10
    jal ra relu
    


    # Compute o = matmul(m1, h)
    
    # o has s4 rows and s8 cols
    mul s11 s4 s8
    slli t0 s11 2
    

    mv a0 t0
    jal ra malloc
    beq a0 x0 malloc_error
    mv a6 a0
    
    #store o in s0
    mv s0 a0
    
    mv a0 s3
    mv a1 s4
    mv a2 s5
    mv a3 s9
    mv a4 s1
    mv a5 s8
    
    jal ra matmul
    

    # free m1 since i don't need it anymore
    mv a0 s3
    jal ra free
    
    # free h1 since i don't need it anymore
    mv a0 s9
    jal ra free


    # Write output matrix o


    #restore original a1
    lw a1 4(sp)
    
    lw a0 16(a1)
    mv a1 s0  
    mv a2 s4
    mv a3 s8
    
    jal ra write_matrix
    

    # Compute and return argmax(o)
    
    mv a0 s0
    mv a1 s11
    jal ra argmax
    
    # s2 holds the largers int in o
    mv s2 a0
    
    
    # free o since i dont need it anymore
    mv a0 s0
    jal ra free

    # If enabled, print argmax(o) and newline



    
    #t0 holds a2
    lw t0 8(sp)
    
    bne t0 x0 rest
    mv a0 s2
    jal ra print_int
    
    li a0 '\n'
    jal ra print_char
    rest:
    
    mv a0 s2
    # to offset the a0, a1, a2
    addi sp sp 12
    
    
        

    
  
    
    lw s0 0(sp)
    lw s2 4(sp)
    lw s3 8(sp)
    lw s4 12(sp)
    lw s5 16(sp)
    lw s6 20(sp)
    lw s7 24(sp)
    lw s8 28(sp)
    lw s9 32(sp)
    lw s10 36(sp)
    lw s11 40(sp)
    lw s1 44(sp)
    lw ra 48(sp)
    addi sp sp 52
    
    jr ra
