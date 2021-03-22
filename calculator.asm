.386
.model flat, stdcall
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;includem msvcrt.lib, si declaram ce functii vrem sa importam
includelib msvcrt.lib
extern exit: proc
extern printf: proc
extern scanf: proc
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;declaram simbolul start ca public - de acolo incepe executia
public start
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;sectiunile programului, date, respectiv cod
.data
;aici declaram date
format db "%x%c",0
scannn db "%*c",0
semn dd 0
semn2 dd 0
format2 db "%c",0
semne dd 100 dup(0)
numar dd 0
contor dd 0
numere dd 100 dup(0)
form db "%X",13,10,0
imp0 db "Impartire la 0.",13,10,0
rezultat dd 0
mesaj db "Introduceti o expresie (sau 'E' pentru exit):",13,10,0
msjexit db "Rezultatul final a fost %X."

.code

adunare proc
	push ebp
	mov ebp,esp
	mov eax,[ebp+8]
	mov ebx,[ebp+12]
	add eax,ebx
	mov esp,ebp
	pop ebp
	ret
adunare endp

scadere proc
	push ebp
	mov ebp,esp
	mov eax,[ebp+8]
	mov ebx,[ebp+12]
	sub eax,ebx
	mov esp,ebp
	pop ebp
	ret
scadere endp

inmultire proc
	push ebp
	mov ebp,esp
	mov eax,[ebp+8]
	mov ebx,[ebp+12]
	mov edx,0
	mul ebx
	mov esp,ebp
	pop ebp
	ret
inmultire endp

impartire proc
	push ebp
	mov ebp,esp
	mov eax,[ebp+8]
	mov ebx,[ebp+12]
	mov edx,0
	cmp eax,0
	jg aic
	mov edi,eax
	mov eax,0
	sub eax,edi
	idiv ebx
	mov edi,eax
	mov eax,0
	sub eax,edi
	jmp sss
	aic:
	idiv ebx
	sss:
	mov esp,ebp
	pop ebp
	ret
impartire endp


start:
	mov contor,0
s:
	push offset mesaj
	call printf
	add esp,4
	mov eax,0
	mov esi,-4
citire:
	cmp contor,0
	je sd
	push offset semn
	push offset scannn
	call scanf
	add esp,8
	
	push offset semn
	push offset format2
	call scanf
	add esp,8
	cmp semn,'E'
	je exi
	cmp semn,'e'
	je exi
	cmp semn,'='
	je afisare
	mov eax,rezultat
	mov numere[0],eax
	mov eax,semn
	mov semne[0],eax
	mov esi,0
sd:
	add esi,4
	push offset semn
	push offset numar
	push offset format
	call scanf
	add esp,12
	mov eax,semn
	mov semne[esi],eax
	mov eax,numar
	mov numere[esi],eax
	mov eax,0
ssc:
	cmp semne[esi],'='
jne sd
	mov ecx,esi

inm:
	mov esi,-4
	
eticheta:
	add esi,4
	cmp esi,ecx
	je imp
	cmp semne[esi],'/'
	je imp
	cmp semne[esi],'*'
	
jne eticheta
	sub ecx,4
	
	push numere[esi]
	push numere[esi+4]
	call inmultire
	add esp,8	
	mov numere[esi],eax

et1:
	mov eax,semne[esi+4]
	mov semne[esi],eax
	cmp semne[esi],'='
	je inm
	mov eax,numere[esi+8]
	mov numere[esi+4],eax
	add esi,4
	cmp esi,ecx
	jne et1
	
jmp inm

imp:
	mov esi,-4
	
eticheta2:
	add esi,4
	cmp esi,ecx
	je e
	cmp semne[esi],'*'
	je inm
	cmp semne[esi],'/'
	
jne eticheta2
	sub ecx,4
	cmp numere[esi+4],0
	je ex
	push numere [esi+4]
	push numere [esi]
	call impartire
	add esp,8	
	mov numere[esi],eax

et2:
	mov eax,semne[esi+4]
	mov semne[esi],eax
	cmp semne[esi],'='
	je imp
	mov eax,numere[esi+8]
	mov numere[esi+4],eax
	add esi,4
	cmp esi,ecx
	jne et2
	
jmp imp
	
e:
	mov esi,0

	cmp semne[0],'+'
	jne dif
	sub ecx,4
suma:
	push numere[0]
	push numere[4]
	call adunare
	add esp,8
	
	mov numere[0],eax

et3:
	mov eax,semne[esi+4]
	mov semne[esi],eax
	cmp semne[esi],'='
	je dif
	mov eax,numere[esi+8]
	mov numere[esi+4],eax
	add esi,4
	cmp esi,ecx
	jne et3
	
jmp e

dif:
	cmp semne[0],'-'
	jne afisare
	sub ecx,4
	push numere[4]
	push numere[0]
	call scadere
	add esp,8
	
	mov numere[0],eax

et4:
	mov eax,semne[esi+4]
	mov semne[esi],eax
	cmp semne[esi],'='
	je afisare
	mov eax,numere[esi+8]
	mov numere[esi+4],eax
	add esi,4
	cmp esi,ecx
	jne et4
	
jmp e


	
afisare: ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	
	push numere[0]
	push offset form
	call printf
	add esp,8
	
	mov eax,numere[0]
	mov rezultat,eax
	inc contor
	jmp s

	;apel functie exit
ex: 
	push offset imp0
	call printf
	add esp,4
exi:
	push rezultat
	push offset msjexit
	call printf
	add esp,8
	push 0
	call exit

end start