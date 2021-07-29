%include "io.mac"

section .text
    global bin_to_hex
    extern printf

section .data
    count DD 0
    length DD 0
    suma DD 0

bin_to_hex:
    ;; DO NOT MODIFY
    push    ebp
    mov     ebp, esp
    pusha

    mov     edx, [ebp + 8]      ; hexa_value
    mov     esi, [ebp + 12]     ; bin_sequence
    mov     ecx, [ebp + 16]     ; length
    ;; DO NOT MODIFY

    ;;Count este un contor in care numar cati biti am, iar cand acesta
    ;;este 4 inseamna ca am format un nibble.
    ;;Suma este o variabila care calculeaza suma bitilor dintr-un nibble.
    mov dword[count], 0
    mov dword[suma], 0
    mov dword[length], ecx
    mov ebx, 0

    ;; TODO: Implement bin to hex

    ;;Calculam prin scaderi repetate in cati nibble intra
    ;;secventa de biti si retinem rezultatul in length.
    lungime_hexa:
        cmp dword[length], 0
        jg scad
        jmp number_niddle

    scad:
        sub dword[length], 4
        inc ebx
        jmp lungime_hexa

    number_niddle:
        mov dword[length], ebx

    ;;Punem pe ultima pozitie a sirului hexa_value codul ascii
    ;;al terminatorului de sir.
    mov byte[edx + ebx], 10
    dec ebx

    ;;Comparam countul cu 0, 1, 2, 3 si 4 pentru a vedea la al catelea bit
    ;;suntem in nibble.
    for1:
        mov al, byte[esi + ecx - 1]
        cmp dword[count], 0
        je byte_1
        cmp dword[count], 1
        je byte_2
        cmp dword[count], 2
        je byte_3
        cmp dword[count], 3
        je byte_4
        cmp dword[count], 4
        je nibble

    continuue:
        dec ecx
        jnz for1
        jmp end

    ;;In cazul in care este primul bit si valoarea acestuia este 1, incrementam
    ;;suma.
    byte_1:
        inc dword[count]
        cmp al, '1'
        je on1
        jmp continuue
    
    on1:
        add dword[suma], 1
        jmp continuue

    ;;In cazul in care este al doilea bit si valoarea acestuia este 1, adunam la
    ;;suma 2.
    byte_2:
        inc dword[count]
        cmp al, '1'
        je on2
        jmp continuue

    on2:
        add dword[suma], 2
        jmp continuue

    ;;In cazul in care este al treilea bit si valoarea acestuia este 1, adunam la
    ;;suma 4.
    byte_3:
        inc dword[count]
        cmp al, '1'
        je on3
        jmp continuue

    on3:
        add dword[suma], 4
        jmp continuue

    ;;In cazul in care este al patrulea bit si valoarea acestuia este 1, adunam la
    ;;suma 8.
    byte_4:
        inc dword[count]
        cmp al, '1'
        je on4
        jmp continuue

    on4:
        add dword[suma], 8
        jmp continuue

    ;;In cazul in care countul este 4, inseamna ca am obtinut un nibble si verificam
    ;;daca valoarea acestuia este mai mica ca 10 (caz in care avem o cifra in hexa)
    ;;sau intre 10 si 15 (caz in care avem litera) si facem apoi conversia la caracter.
    nibble:
        mov dword[count], 0
        cmp dword[suma], 10
        jl cifra
        jmp litera

    gata:
        mov dword[suma], 0
        jmp for1
    
    cifra:
        mov al, byte[suma]
        add al, '0'
        mov byte[edx + ebx], al
        dec ebx
        jmp gata

    litera:
        mov al, byte[suma]
        add al, 'A'
        sub al, 10
        mov byte[edx + ebx], al
        dec ebx
        jmp gata

    end:

    ;;Aici verificam daca cei mai semnificativi biti au reusit sa formeze
    ;;si ei un nibble. In cazul in care au mai ramas biti, transformam suma
    ;;lor in caracter din hexa si copiem rezultatul in hexa_value[0].
    cmp dword[count], 0
    je numaiamcar

    cmp dword[suma], 10
    jl cifra_f
    jmp litera_f

    cifra_f:
        mov al, byte[suma]
        add al, '0'
        mov byte[edx], al
        jmp numaiamcar

    litera_f:
        mov al, byte[suma]
        add al, 'A'
        sub al, 10
        mov byte[edx], al

    numaiamcar:
        
    ;; DO NOT MODIFY
    popa
    leave
    ret
    ;; DO NOT MODIFY