%include "io.mac"

section .text
    global otp
    extern printf

otp:
    ;; DO NOT MODIFY
    push    ebp
    mov     ebp, esp
    pusha

    mov     edx, [ebp + 8]      ; ciphertext
    mov     esi, [ebp + 12]     ; plaintext
    mov     edi, [ebp + 16]     ; key
    mov     ecx, [ebp + 20]     ; length
    ;; DO NOT MODIFY

    ;; TODO: Implement the One Time Pad cipher

    ;;copiem in ultimul octet al registrului eax pe plaintext[i], 
    ;;apoi facem operatia xor intre ultimul octet al registrului eax
    ;;si key[i] si copiem rezultatul in ultimul octet a lui chipertext[i]
    
    mov ebx, 0
    for:
        mov al, byte[esi + ebx]
        xor al, byte[edi + ebx]
        mov byte[edx + ebx], al
        add ebx, 1
    loop for

    ;; DO NOT MODIFY
    popa
    leave
    ret
    ;; DO NOT MODIFY