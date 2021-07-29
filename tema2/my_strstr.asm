%include "io.mac"

section .text
    global my_strstr
    extern printf

section .data
    length_H DD 0
    length_H_final DD 0
    length_N DD 0
    ok DD 0

my_strstr:
    ;; DO NOT MODIFY
    push    ebp
    mov     ebp, esp
    pusha

    mov     edi, [ebp + 8]      ; substr_index
    mov     esi, [ebp + 12]     ; haystack
    mov     ebx, [ebp + 16]     ; needle
    mov     ecx, [ebp + 20]     ; haystack_len
    mov     edx, [ebp + 24]     ; needle_len
    ;; DO NOT MODIFY

    ;; TO DO: Implement my_strstr

    ;;Pastram in length_H si length_H_final pe haystack_len.
    ;;Pastram in length_N pe needle_len.
    mov dword[length_H], ecx
    mov dword[length_H_final], ecx
    mov dword[length_N], edx
    mov edx, 0

    ;;Parcurgem sirul haystack carcter cu caracter si cand haystack[i]
    ;;este egal cu needle[0] verificam daca celelalte caractere sunt egale.
    ;;In ok retinem indicele din haystack la care sunt in momentul curent pentru
    ;;a ne putea intoarce in cazul in care urmatoarele caractere nu sunt la 
    ;;fel ca in needle si pentru a continua cautarea.
    for1:
        mov al, byte[esi + edx]
        mov ecx, 1
        mov dword[ok], edx
        cmp al, byte[ebx]
        je forinfor
        jmp increment_for

    ;;Daca nu am ajuns la finalul lui needle, facem din nou pe needle sa pointeze
    ;;la adresa de inceput a sirului si ne intoarcem in haystack la pozitia in
    ;;care se gasea primul caracter.
    notequal:
        mov edx, dword[ok]
        mov ebx, [ebp + 16]

    ;;Daca nu am gasit inca caracterul trec la caracterul urmator din haystack. In
    ;;cazul in care am ajuns la finalul sirului, inseamna ca sirul needle nu se 
    ;;gaseste in haystack.
    increment_for:   
        dec dword[length_H]
        inc edx
        cmp dword[length_H], 0
        jnz for1
        jmp notfind
    
    ;;Daca ajungem la finalul sirului needle (adica ecx este egal cu length_N)
    ;;inseamna ca sirul needle se afla in haystack si sarim la final pentru a 
    ;;afisa pozitia de inceput.
    forinfor:
        inc edx
        cmp ecx, dword[length_N]
        je find
        inc ebx
     
        mov al, byte[esi + edx]
        cmp al, byte[ebx]
        je conditie
        jmp notequal

    ;;Cat timp intalnim aceleasi caractere in haystack si needle mergem mai
    ;;departe.
    conditie:
        inc ecx
        cmp ecx, dword[length_N]
        jl forinfor
        jmp find

    ;;Copiem in edi pozitia de la care incepe needle in haystack.
    find:
        mov eax , dword[ok]
        mov [edi], eax
        jmp final
    
    ;;Nu am gasit sirul needle in haystack, deci punem in edi lungimea
    ;;lui haystack + 1.  
    notfind:
        mov eax, dword[length_H_final]
        add eax, 1
        mov [edi], eax

    final:
        
    ;; DO NOT MODIFY
    popa
    leave
    ret
    ;; DO NOT MODIFY
