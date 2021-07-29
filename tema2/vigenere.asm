%include "io.mac"

section .text
    global vigenere
    extern printf

section .data
    count DD 0
    length DD 0

vigenere:
    ;; DO NOT MODIFY
    push    ebp
    mov     ebp, esp
    pusha

    mov     edx, [ebp + 8]      ; ciphertext
    mov     esi, [ebp + 12]     ; plaintext
    mov     ecx, [ebp + 16]     ; plaintext_len
    mov     edi, [ebp + 20]     ; key
    mov     ebx, [ebp + 24]     ; key_len
    ;; DO NOT MODIFY

    ;; TODO: Implement the Vigenere cipher

    ;;Count este un contor pentru lungimea lui key. In cazul in care 
    ;;count ajunge cat key_len o sa pointam din nou catre inceputul lui key.
    mov dword[count], 0
    mov dword[length], ebx
  
    ;;Facem din nou verificare ca la taskul 2 daca plaintext[i]
    ;;este litera sau nu.
    for:
        mov al, byte[esi]
        cmp al, 'A'
        jl final
        cmp al, 'Z'
        jle bigLetter
        cmp al, 'a'
        jl final
        cmp al, 'z'
        jg final
        jmp smallLetter

    ;;Daca este litera mare adunam key[i] (dupa ce scadem din aceasta
    ;;codul ascii al lui 'A') si in cazul in care aceasta depaseste codul
    ;;ascii al lui 'Z' scadem 26.
    bigLetter:
        mov bl, byte[edi]
        sub bl, 'A'
        add al, bl

        ;;incrementam countul si trecem la urmatorul caracter din key[i]
        add dword[count], 1
        add edi, 1

        cmp al, 'Z'
        jg scad
        jmp final
    
    ;;Daca este litera mica adunam key[i] (dupa ce scadem din aceasta
    ;;codul ascii al lui 'A') si in cazul in care aceasta depaseste codul
    ;;ascii al lui 'z' scadem 26.
    smallLetter:
        mov bl, byte[edi]
        sub bl, 'A'
        add ax, bx

        ;;incrementam countul si trecem la urmatorul caracter din key[i]
        add dword[count], 1
        add edi, 1

        cmp ax, 'z'
        jg scad
        jmp final
    
    scad:
        sub al, 26

    final:
        mov byte[edx], al
        add edx, 1
        add esi, 1

        ;;Comparam countul cu length_key si in cazul in care acestea
        ;;sunt egale atribuim din nou countului valoare 0 si facem pe
        ;;key sa pointeze din nou la inceputul sirului.
        mov ebx, dword[length]
        cmp ebx, dword[count]
        je reverse
        jmp endfor
    
    reverse:
        mov dword[count], 0
        mov edi, [ebp + 20]     

    endfor:
         sub ecx, 1
    jnz for

    ;; DO NOT MODIFY
    popa
    leave
    ret
    ;; DO NOT MODIFY