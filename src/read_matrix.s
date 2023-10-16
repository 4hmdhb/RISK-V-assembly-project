.globl read_matrix

.text
# ==============================================================================
# FUNCTION: Allocates memory and reads in a binary file as a matrix of integers
#
# FILE FORMAT:
#   The first 8 bytes are two 4 byte ints representing the # of rows and columns
#   in the matrix. Every 4 bytes afterwards is an element of the matrix in
#   row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is a pointer to an integer, we will set it to the number of rows
#   a2 (int*)  is a pointer to an integer, we will set it to the number of columns
# Returns:
#   a0 (int*)  is the pointer to the matrix in memory
# Exceptions:
#   - If malloc returns an error,
#     this function terminates the program with error code 26
#   - If you receive an fopen error or eof,
#     this function terminates the program with error code 27
#   - If you receive an fclose error or eof,
#     this function terminates the program with error code 28
#   - If you receive an fread error or eof,
#     this function terminates the program with error code 29
# ==============================================================================
read_matrix:

    # Prologue
j no_error
malloc_error:
li a0 26
j exit


fopen_error:
li a0 27
j exit


fclose_error:
li a0 28
j exit


fread_error:
li a0 29
j exit

no_error:

    addi sp sp -12
    sw ra 0(sp)
    sw s0 4(sp)
    sw s3 8(sp)

    addi sp sp -8
    sw a1 0(sp)
    sw a2 4(sp)
    
    #read only flag for fopen
    li a1 0
    
    #will open a filename stored in a0, returns a file descriptior or -1 in a0
    jal ra fopen
    
    # if a0 is 1 return error
    addi t0 x0 -1
    beq a0 t0 fopen_error
    
    
    #store the file descriptor in s0
    mv s0 a0
    

    lw a1 0(sp)
    lw a2 4(sp)
    addi sp sp 8
    
   
    addi sp sp -8
    sw a1 0(sp)
    sw a2 4(sp)
    
    #read first 4 bytes and store in a1
    mv a0 s0
    mv a1 a1
    li a2 4
    
    
    #a1 should now store 1 integer in a1
    jal ra fread
    
    li t2 4
    
    bne a0 t2 fread_error
    
    
    
    lw a1 0(sp)
    lw a2 4(sp)
    addi sp sp 8
    
    addi sp sp -8
    sw a1 0(sp)
    sw a2 4(sp)
    
    mv a0 s0
    mv a1 a2
    li a2 4
    
    jal ra fread
    
    lw a1 0(sp)
    lw a2 4(sp)
    addi sp sp 8
    
    li t2 4
    
    bne a0 t2 fread_error
    
    lw t1 0(a1)
    lw t2 0(a2)
    
    mul t3 t1 t2
    slli s3 t3 2
    
    #allocate a memory for the matrix
    

    
    mv a0 s3
    jal ra malloc
    
    
    beq a0 x0 malloc_error

    
    #now a0 is the allocated matrix
    
    
    # s0 holds the file descriptor
    
    addi sp sp -4
    sw a0 0(sp)
    mv t0 a0
    
    mv a0 s0
    mv a1 t0
    mv a2 s3
    

    
    jal ra fread
    
    
    bne a0 s3 fread_error
    



    
    #close a file descriptor in a0
    

    
    mv a0 s0
    jal ra fclose
    
    li t0 -1
    beq a0 t0 fclose_error
    

    lw a0 0(sp)
    addi sp sp 4
    
    




    # Epilogue

    lw ra 0(sp)
    lw s0 4(sp)
    lw s3 8(sp)
    addi sp sp 12

    jr ra