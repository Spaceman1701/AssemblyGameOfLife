%include "io64.inc"
section .data
alive: db "X", 1
dead: db "O", 1
space: db " ", 1
array_size: dq 8, 1

surround: db 0x0001, 0x0009, 0x0008, 0x0007

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
    add rsp, 16 ;undo last call
    
    mov rax, [rbp + 8]
    push rax
    lea rax, [rbp + 16]
    push rax
    push 9
    
    call Compute_cell_step
    
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
    
    
read_input: ;array, array size
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
    
Compute_cell_step: ;cell, array, array size
    push rbp
    mov rbp, rsp
    
    mov r15, [rbp + 16] ;cell
    mov rbx, [rbp + 24] ;array
    mov rcx, [rbp + 32] ;array size
    
    sub rsp, 8
    mov qword [rbp], 0 ;num alive
   
    mov r9, 8
    
    mov rax, r15
    mul r9
    mov r15, rax
    add r15, rbx ;cell array location
    
    mov r12, rcx
    add r12, rbx ;end of array
    
    lea r8, [surround]
    PRINT_DEC 1, [surround]
    NEWLINE
    mov rdi, 4
    
    PRINT_STRING "entering main loop"
    NEWLINE
main_loop:
    mov al, [r8]
    mul r9
    
    mov r10, rax

    add r10, rbx ;positive neighbor
    cmp r10, r12
     
    
    jge calc_neg ;larger than array
    
    mov r13, [r10] ;start handle positive
    cmp r13, [alive] ;inc num alive
    jne calc_neg
    inc qword [rbp]
calc_neg:
    mov rsi, rbx
    sub rsi, rax ;negative neighbor
    cmp rsi, r12
    jl main_loop_end ;negative neighbor
    
    mov r13, [rsi] 
    cmp r13, [alive]
    jne main_loop_end
    inc qword [rbp] ;inc num alive
    
main_loop_end:
    dec rdi
    add r8, 8 ;next surround pos
    cmp rdi, 0
    jne main_loop ;end main loop
    
    ;main loop exit
    mov r8, [rbp] ;mov num alive into r8
    
    mov r15, [rbx]
    cmp r15, [alive]
    jne is_dead
    cmp r8, 1
    jl kill_cell
    cmp r8, 2
    jg kill_cell
    jmp finish_func
kill_cell:
    mov r15, [dead]
    mov qword [rbx], r15
    jmp finish_func
is_dead:
    cmp r8, 3
    jne finish_func
    mov r15, [alive]
    mov qword [rbx], r15
finish_func:
    mov rsp, rbp
    pop rbp
    ret

    
    
    
    
    
    
    
    


    
    
    
    

    
    