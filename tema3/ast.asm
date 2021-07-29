section .data
    delim db " ", 0
    count dd 0
    semnNumber dd 0
    length dd 0
    suma dd 0

section .bss
    root resd 1

section .text

extern check_atoi
extern print_tree_inorder
extern print_tree_preorder
extern evaluate_tree
extern strlen
extern strtok
extern strdup
extern calloc

global create_tree
global iocla_atoi

iocla_atoi: 
    ;Copiem in edi sirul de caractere pe care va trebui sa il
    ;convertim intr-un integer.
    ;In semnNumber retinem daca numarul este pozitiv sau negativ,
    ;iar suma reprezinta numarul nou format.
    mov edi, [esp + 4]
    mov dword[semnNumber], 1
    mov dword[suma], 0
    mov ebx, 0

    ;Apelam strlen pentru a obtine lungimea sirului si o punem 
    ;in length.
    push edi
    call strlen
    add esp, 4
    mov dword[length], eax
  
    ;Verificam daca primul caracter din edi este minus(caz in care 
    ;facem semnNumber = -1 si trecem la urmatorul caracter).
    cmp byte[edi + 0], '-'
    je numar_negativ
    jmp parcurgere_sir

numar_negativ:
    mov dword[semnNumber], -1
    inc ebx

    ;Parcurgem sirul caracter cu caracter pana la final si construim
    ;numarul.
parcurgere_sir:
    mov eax, dword[suma]
    imul eax, 10
    mov dword[suma], eax

    mov cl, byte[edi + ebx]
    sub cl, '0'
    add dword[suma], ecx

    inc ebx
    cmp ebx, dword[length]
    je out_parcurgere
    jmp parcurgere_sir

    ;In final inmultim numarul format(suma) cu semnNumber(1 daca numarul era
    ;pozitiv si -1 daca numarul era negativ). Copiem rezultatul in eax si il
    ;returnam.
out_parcurgere:
    mov edx, dword[semnNumber]
    mov eax, dword[suma]
    mul edx
    ret

    ;Functie care apeleaza callocul din c.
create_node:
    push dword 12
    push dword 1
    call calloc
    add esp, 8
    ret

create_tree:
    ; TODO
    enter 0, 0
    xor eax, eax
    push ebx
    push ecx

    ;Copiem sirul in esi.
    mov esi, [ebp + 8]

    ;Apelam functia strtok din c pentru a separa stringurile.
    push delim
    push esi
    call strtok
    add esp, 8
    mov ecx, eax

    ;Alocam memorie sirului obtinut cu strtok.
    push ecx
    call strdup
    pop ecx
    mov ebx, eax

    ;Apelam functia create_node(aloca 12 bytes - 4 pentru *data, 4 pentru
    ;*left si 4 pentru *right) si tinem rezultatul in nodul in ecx. Punem in
    ;primi 4 bytes ai lui ecx rezultatul strdupului(adica *data).
    ;Punem nodul pe stiva (deoarece acesta este semn).
    ;In count retinem cate noduri se afla pe stiva.
    push ebx
    push ecx
    call create_node
    pop ecx
    pop ebx
    mov ecx, eax
    mov [ecx], ebx
    push ecx
    inc dword[count]

    ;Continuam functia strtok si luam pe rand stringurile pana
    ;la terminatorul de sir.
continue_strtok:
    push delim
    push dword 0
    call strtok
    add esp, 8
    cmp eax, 0
    je out_strtok

    ;Verificam daca stringul este semn sau numar.
ce_este:
    cmp byte[eax], '+'
    je semn
    cmp byte[eax], '/'
    je semn
    cmp byte[eax], '*'
    je semn
    cmp byte[eax], '-'
    je verificare
    jmp numar

verificare:
    cmp byte[eax + 1], 0
    je semn
    jmp numar

semn:
    ;Copiem stringul in edx.
    xor edx, edx
    mov edx, eax

    ;Apelam functia strdup si retinem rezultatul in ebx.
    push edx
    call strdup
    pop edx
    mov ebx, eax 

    ;Apelam functia create_node (aloca 12 bytes - 4 pentru *data, 4 pentru
    ;*left si 4 pentru *right) si tinem rezultatul in nodul in edx. Punem in 
    ;primi 4 bytes ai lui edx rezultatul strdupului(adica *data)
    push ebx
    push ecx
    call create_node
    pop ecx
    pop ebx
    mov edx, eax
    mov [edx], ebx

againSemn:
    ;Scoatem nodul de pe stiva si verificam daca acesta are fiu drept sau fiu
    ;stang.
    dec dword[count]
    pop ecx
    xor ebx, ebx
    mov ebx, [ecx + 4]
    cmp ebx, 0
    je stangSemn

    xor ebx, ebx
    mov ebx, [ecx + 8]
    cmp ebx, 0
    je dreptSemn

    ;Daca nodul curent(nodul scos de pe stiva) are atat copil stang, cat si copil
    ;drept insemna ca mai avem noduri pe stiva si mergem la parintele acestuia.
    jmp againSemn

    ;Daca nodul nu are fiu stang, facem legatura dintre copil si parinte, si punem
    ;pe stiva intai parintele, apoi copilul.
stangSemn:
    mov [ecx + 4], edx
    inc dword[count]
    push ecx
    mov ecx, edx
    push ecx
    inc dword[count]
    jmp continue_strtok

    ;Daca nodul nu are fiu drept, facem legatura dintre copil si parinte, si punem
    ;pe stiva intai parintele, apoi copilul.
dreptSemn:
    mov [ecx + 8], edx
    push ecx
    inc dword[count]
    mov ecx, edx
    push ecx
    inc dword[count]
    jmp continue_strtok

numar:
    ;Accelasi ratinamnet ca si la semn, doar ca numerele sunt noduri frunza(deci ele 
    ;nu o sa mai fie puse in stiva; in stiva sunt puse doar semnele).
    xor edx, edx
    mov edx, eax

    push edx
    call strdup
    pop edx
    mov ebx, eax 

    push ebx
    push ecx
    call create_node
    pop ecx
    pop ebx
    mov edx, eax
    mov [edx], ebx

againNumar:
    dec dword[count]
    pop ecx
    xor ebx, ebx
    mov ebx, [ecx + 4]
    cmp ebx, 0
    je stangNumar

    xor ebx, ebx
    mov ebx, [ecx + 8]
    cmp ebx, 0
    je dreptNumar

    jmp againNumar

stangNumar:
    mov [ecx + 4], edx
    push ecx
    inc dword[count]
    jmp continue_strtok

dreptNumar:
    mov [ecx + 8], edx
    push ecx
    inc dword[count]
    jmp continue_strtok

    ;Copiem in ebx numarul nodurilor care se afla in acest moment pe stiva.
out_strtok:
    xor ebx, ebx
    mov ebx, dword[count]

    ;Cat timp au mai ramas noduri pe stiva dam pop.
while:
    cmp ebx, 0
    je out_while
    pop ecx
    dec ebx
    jmp while

out_while:
    mov eax, ecx

    pop ecx
    pop ebx
    
    leave
    ret
    