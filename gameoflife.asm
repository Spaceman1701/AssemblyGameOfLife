%include "io64.inc"
section .data
filled: db "X", 1
empty: db "O", 1
space: db " ", 1
array_size: dq 8, 1

section .text
global CMAIN
CMAIN:
    mov rbp, rsp
    
    call calc_array_size ;returns size of array in bytes. 
    ;each location is a full qword
    ;initalize array
    push rax ;size of the array is stored before the beginning
    sub rsp, rax ;array head is rbp - 16, array[1] = rbp - 24 etc

    
    push rax
    mov rax, rbp
    sub rax, 16 ; array head
    push rax

    call read_input ;rbp +
    
    mov rsp, rbp
    xor rax, rax
    ret
    
    
calc_array_size:
    push rbp
    mov rbp, rsp
    
    mov rax, [array_size]
    mul rax
    mov rbx, 8
    mul rbx
            
    mov rsp, rbp
    pop rbp
    ret
    
    
read_input:
    push rbp
    mov rbp, rsp
    
    mov rbx, [rbp + 24] ;get the array size

    mov rcx, [rbp + 16] ;get the array head
loop_start:
    GET_CHAR rax ;get the next char
    cmp rax, 10
    je loop_start ;if the char is a newline, skip it
    mov qword [rcx], rax
    sub rcx, 8
    sub rbx, 8
    
    cmp rbx, 0
    jne loop_start
    
    mov rsp, rbp
    pop rbp
    ret


    
    