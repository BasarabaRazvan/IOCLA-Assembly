%include "io.mac"

section .text
    global caesar
    extern printf

caesar:
    ;; DO NOT MODIFY
    push    ebp
    mov     ebp, esp
    pusha

    mov     edx, [ebp + 8]      ; ciphertext
    mov     esi, [ebp + 12]     ; plaintext
    mov     edi, [ebp + 16]     ; key
    mov     ecx, [ebp + 20]     ; length
    ;; DO NOT MODIFY

    ;; TODO: Implement the caesar cipher

    ;;Cu acest label scad repetat cheia cu 26 (26 litere alfabetice)
    ;;pana cand key devine un numar intre 0 si 26.
    while:
        cmp edi, 26
        jg cond
        jmp for

    cond:
        sub edi, 26
        jmp while
 
    ;;In registrul eax retinem caracter cu caracter pe plaintext
    ;;si verificam daca acesta este litera mica sau mare.
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

    ;;Daca este litera mare adunam cheia si in cazul in care
    ;;aceasta depaseste codul ascii al lui 'Z' scadem 26.
    bigLetter:
        add eax, edi
        cmp al, 'Z'
        jg scad
        jmp final

    ;;Daca este litera mica adunam cheia si in cazul in care
    ;;aceasta depaseste codul ascii al lui 'z' scadem 26.
    smallLetter:
        add eax, edi
        cmp eax, 'z'
        jg scad
        jmp final

    scad:
        sub eax, 26

    ;;Trecem la urmatorul caracter.
    final:
        mov byte[edx], al
        add edx, 1
        add esi, 1

    loop for

    ;; DO NOT MODIFY
    popa
    leave
    ret
    ;; DO NOT MODIFY