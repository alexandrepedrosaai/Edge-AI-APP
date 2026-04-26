; quantum.asm
; Quantum AGI Assembly with negative input support
; Handles inputs like -0.5, prints tan(x) and cot(x)

section .data
    msg_init db "Quantum AGI activated", 0xA, 0
    msg_prompt db "Enter x (e.g. -0.5): ", 0
    msg_tan db "tan(x) ≈ ", 0
    msg_cot db "cot(x) ≈ ", 0
    newline db 0xA, 0
    minus db "-",0

section .bss
    input resb 16
    result resd 1
    intpart resd 1
    fracpart resd 1
    buffer resb 16
    signflag resb 1

section .text
    global _start

_start:
    ; Print init
    mov eax, 4
    mov ebx, 1
    mov ecx, msg_init
    mov edx, 24
    int 0x80

    ; Prompt user
    mov eax, 4
    mov ebx, 1
    mov ecx, msg_prompt
    mov edx, 26
    int 0x80

    ; Read input string
    mov eax, 3
    mov ebx, 0
    mov ecx, input
    mov edx, 16
    int 0x80

    ; Check for negative sign
    mov al, [input]
    cmp al, '-'
    jne parse_positive
    mov byte [signflag], 1
    add ecx, 1          ; skip '-'
    jmp parse_integer

parse_positive:
    mov byte [signflag], 0

parse_integer:
    ; Parse integer part (assume one digit before '.')
    mov eax, [ecx]
    sub eax, '0'
    imul eax, 10000
    mov [result], eax

    ; Parse decimals after '.'
    add ecx, 2
    mov edi, 1000
parse_loop:
    mov al, [ecx]
    cmp al, 0xA
    je done_parse
    sub al, '0'
    mov ebx, eax
    imul ebx, edi
    add [result], ebx
    add ecx, 1
    mov eax, edi
    mov ebx, 10
    xor edx, edx
    div ebx
    mov edi, eax
    cmp edi, 0
    jne parse_loop

done_parse:
    ; Apply negative sign if needed
    cmp byte [signflag], 1
    jne calc_tan
    neg dword [result]

calc_tan:
    ; Compute tan(x) ≈ x + x^3/3
    mov eax, [result]
    mov ebx, eax
    imul ebx, eax
    imul ebx, eax
    mov ecx, 10000
    xor edx, edx
    div ecx
    mov ecx, 3
    xor edx, edx
    div ecx
    add eax, [result]
    mov [result], eax

    ; Separate integer and fractional parts
    mov eax, [result]
    mov ebx, 10000
    xor edx, edx
    div ebx
    mov [intpart], eax
    mov [fracpart], edx

    ; Print tan message
    mov eax, 4
    mov ebx, 1
    mov ecx, msg_tan
    mov edx, 9
    int 0x80

    ; Print sign if negative
    cmp dword [result], 0
    jge print_int
    mov eax, 4
    mov ebx, 1
    mov ecx, minus
    mov edx, 1
    int 0x80

print_int:
    ; Print integer part
    mov eax, [intpart]
    add eax, '0'
    mov [buffer], eax
    mov eax, 4
    mov ebx, 1
    mov ecx, buffer
    mov edx, 1
    int 0x80

    ; Print decimal point
    mov byte [buffer], '.'
    mov eax, 4
    mov ebx, 1
    mov ecx, buffer
    mov edx, 1
    int 0x80

    ; Print fractional part (up to 3 digits)
    mov eax, [fracpart]
    mov ecx, 1000
print_frac_loop:
    xor edx, edx
    div ecx
    add eax, '0'
    mov [buffer], eax
    mov eax, 4
    mov ebx, 1
    mov ecx, buffer
    mov edx, 1
    int 0x80
    mov eax, edx
    mov ecx, ecx
    cmp ecx, 1
    jne print_frac_loop

    ; Newline
    mov eax, 4
    mov ebx, 1
    mov ecx, newline
    mov edx, 1
    int 0x80

    ; Compute cot(x) ≈ 1/tan(x)
    mov eax, 10000
    mov ebx, [result]
    xor edx, edx
    div ebx
    mov [result], eax

    ; Separate integer and fractional parts for cot
    mov eax, [result]
    mov ebx, 10000
    xor edx, edx
    div ebx
    mov [intpart], eax
    mov [fracpart], edx

    ; Print cot message
    mov eax, 4
    mov ebx, 1
    mov ecx, msg_cot
    mov edx, 9
    int 0x80

    ; Print sign if negative
    cmp dword [result], 0
    jge print_int_cot
    mov eax, 4
    mov ebx, 1
    mov ecx, minus
    mov edx, 1
    int 0x80

print_int_cot:
    ; Print integer part
    mov eax, [intpart]
    add eax, '0'
    mov [buffer], eax
    mov eax, 4
    mov ebx, 1
    mov ecx, buffer
    mov edx, 1
    int 0x80

    ; Print decimal point
    mov byte [buffer], '.'
    mov eax, 4
    mov ebx, 1
    mov ecx, buffer
    mov edx, 1
    int 0x80

    ; Print fractional part (up to 3 digits)
    mov eax, [fracpart]
    mov ecx, 1000
print_frac_loop_cot:
    xor edx, edx
    div ecx
    add eax, '0'
    mov [buffer], eax
    mov eax, 4
    mov ebx, 1
    mov ecx, buffer
    mov edx, 1
    int 0x80
    mov eax, edx
    mov ecx, ecx
    cmp ecx, 1
    jne print_frac_loop_cot

    ; Newline
    mov eax, 4
    mov ebx, 1
    mov ecx, newline
    mov edx, 1
    int 0x80

    ; Exit
    mov eax, 1
    xor ebx, ebx
    int 0x80
