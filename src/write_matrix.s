.globl write_matrix

.text
# ==============================================================================
# FUNCTION: Writes a matrix of integers into a binary file
# FILE FORMAT:
#   The first 8 bytes of the file will be two 4 byte ints representing the
#   numbers of rows and columns respectively. Every 4 bytes thereafter is an
#   element of the matrix in row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is the pointer to the start of the matrix in memory
#   a2 (int)   is the number of rows in the matrix
#   a3 (int)   is the number of columns in the matrix
# Returns:
#   None
# Exceptions:
#   - If you receive an fopen error or eof,
#     this function terminates the program with error code 27
#   - If you receive an fclose error or eof,
#     this function terminates the program with error code 28
#   - If you receive an fwrite error or eof,
#     this function terminates the program with error code 30
# ==============================================================================
write_matrix:

j no_error

fopen_error:
li a0 27
j exit


fclose_error:
li a0 28
j exit


fwrite_error:
li a0 30
j exit

no_error:


    # Prologue
    addi sp sp -12
    sw ra 0(sp)
    sw s0 4(sp)
    sw s3 8(sp)

    addi sp sp -12
    sw a1 0(sp)
    sw a2 4(sp)
    sw a3 8(sp)
    
    # write only flag for fopen
    li a1 1
    
    #will open a filename stored in a0, returns a file descriptior or -1 in a0
    jal ra fopen
    
    # if a0 is -1 return error
    addi t0 x0 -1
    beq a0 t0 fopen_error
    
    
    #store the file descriptor in s0
    mv s0 a0
    


    mv a0 s0
    addi a1 sp 4
    li a2 2
    li a3 4
    jal ra fwrite
    
    li t4 2
    bne a0 t4 fwrite_error
    


    lw a1 0(sp)
    lw a2 4(sp)
    lw a3 8(sp)
    addi sp sp 12


    

    
    
    #write the buffer to a file
    

    

    mv a0 s0
    mul s3 a2 a3
    mv a2 s3
    li a3 4
    jal ra fwrite
    
    
    bne a0 s3 fwrite_error



    
    
    mv a0 s0
    jal ra fclose
    
    li t0 -1
    beq a0 t0 fclose_error
    
    # Epilogue


    lw ra 0(sp)
    lw s0 4(sp)
    lw s3 8(sp)
    addi sp sp 12
    jr ra
