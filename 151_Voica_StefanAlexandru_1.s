.data
n: .space 4
m: .space 4
k: .space 4
p: .space 4
x: .space 4
y: .space 4
lineIndex: .space 4
columnIndex: .space 4
nrelem: .space 4
len: .space 4
tip: .space 4
contor: .long 0
a: .space 1600
b: .space 1600
sir: .space 400 
dx: .long 0, -1, -1, -1, 0, 0, 1, 1, 1
dy: .long 0, -1, 0, 1, -1, 1, -1, 0, 1
fcit: .asciz "%d"
fstring: .asciz "%s"
afis0x: .asciz "0x"
fhexa: .asciz "%X"
fprint: .asciz "%d "
fdecript: .asciz "\n0x%s"
fchar: .asciz "%c"
newline: .asciz "\n"

.text
proc:
	pushl %ebp
	movl %esp, %ebp
	movl $8, %ecx
	movl $0, contor
	et_for: 
		lea dx, %edi
		movl (%edi, %ecx, 4), %eax
		lea dy, %edi
		movl (%edi, %ecx, 4), %ebx
		addl 12(%ebp), %eax
		addl 8(%ebp), %ebx
		
		xorl %edx, %edx
		mull m
		addl %ebx, %eax
		
		lea a, %edi
		movl contor, %edx
		addl (%edi, %eax, 4), %edx
		movl %edx, contor
		
		loop et_for	
	mat_b:
		movl 12(%ebp), %eax
		xorl %edx, %edx
		mull m
		addl 8(%ebp), %eax
		lea a, %edi
		movl (%edi, %eax, 4), %ebx  
		
		movl contor, %edx
		cmp $0, %ebx
		je cazmort
		
		cmp $1, %ebx
		je cazviu
				
		cazviu:
			cmp $2, %edx
			jl caz0
			cmp $3, %edx
			jg caz0
			jmp caz1
			
		cazmort:
			cmp $3, %edx
			je caz1
			jmp caz0
			
		caz1:
			lea b, %edi
			movl $1, (%edi, %eax, 4)
			jmp exit
		
		caz0:
			lea b, %edi
			movl $0, (%edi, %eax, 4)
			jmp exit
	exit:
		popl %ebp
	ret

.global main

main:
pushl $n
pushl $fcit
call scanf
popl %ebx
popl %ebx
addl $1, n

pushl $m
pushl $fcit
call scanf
popl %ebx
popl %ebx
addl $2, m

pushl $p
pushl $fcit
call scanf
popl %ebx
popl %ebx

movl p, %ecx
et_citire:
	pushl %ecx
	pushl $x
	pushl $fcit
	call scanf
	popl %ebx
	popl %ebx

	pushl $y
	pushl $fcit
	call scanf
	popl %ebx
	popl %ebx
	
	addl $1, x
	addl $1, y

	movl x, %eax
	movl $0, %edx
	mull m
	addl y, %eax
	
	lea a, %edi
	movl $1, (%edi, %eax, 4)
	
	popl %ecx
	loop et_citire

pushl $k
pushl $fcit
call scanf
popl %ebx
popl %ebx
	
movl $0, %ebx	
et_parcurgere:
	cmp %ebx, k
	je incepe_b
	movl $1, lineIndex
	for_lines:
		movl lineIndex, %ecx
		cmp %ecx, n
		je copiaza
		
		movl $1, columnIndex
		for_columns:
			movl columnIndex, %ecx
			incl %ecx
			cmp %ecx, m
			je cont
			
			pushl %ebx
			pushl lineIndex
			pushl columnIndex
			call proc
			popl %ecx
			popl %ecx
			popl %ebx
			
			incl columnIndex
			jmp for_columns
		
	cont:
		incl lineIndex
		jmp for_lines
		
	copiaza:
		movl $1, lineIndex
		forlines:
		movl lineIndex, %ecx
		cmp %ecx, n
		je iesi
		
		movl $1, columnIndex
		forcolumns:
			movl columnIndex, %ecx
			incl %ecx
			cmp %ecx, m
			je continu
			
			movl m, %eax
			mull lineIndex
			addl columnIndex, %eax
			lea a, %edi
			lea b, %esi
			movl (%esi, %eax, 4), %edx
			movl %edx, (%edi, %eax, 4)
			
			incl columnIndex
			jmp forcolumns
		
		continu:
			incl lineIndex
			jmp forlines
	iesi:
	inc %ebx
	jmp et_parcurgere


			
incepe_b:
#calculez nr de elem ale matricei extinse
movl n, %eax
incl %eax
mull m
movl %eax, nrelem #(n+2)*(m+2)

#am nevoie de maxim 80 de biti in matricea extinsa
decl m #0...m
dublare:
movl $80, %eax
cmp %eax, nrelem #nrelem>=80
jge citeste_tip
movl $0, lineIndex
for_i:
	movl lineIndex, %ecx
	decl %ecx
	cmp %ecx, n
	je for_final
	
	movl $0, columnIndex
	for_j:
		movl columnIndex, %ecx
		decl %ecx
		cmp %ecx, m
		je for_cont
		
		movl m, %eax
		incl %eax
		mull lineIndex
		addl columnIndex, %eax
		movl %eax, %ecx #ecx = pozitia din mat initiala
		addl nrelem, %eax #eax = pozitia nou adaugata
		lea a, %edi
		movl (%edi, %ecx, 4), %edx
		movl %edx, (%edi, %eax, 4)
		
		incl columnIndex
		jmp for_j
	for_cont:
		incl lineIndex
		jmp for_i
	for_final:
		movl nrelem, %eax
		addl %eax, %eax
		movl %eax, nrelem #se dubleaza nr de elem
		movl n, %eax
		addl %eax, %eax
		incl %eax
		movl %eax, n #se dubleaza n
		jmp dublare
		
citeste_tip:
pushl $tip
pushl $fcit
call scanf
popl %ebx
popl %ebx

xorl %ebx, %ebx
cmp %ebx, tip #if tip!=0
jne decriptare

criptare:
#afisez 0x
mov $4, %eax
mov $1, %ebx
mov $afis0x, %ecx
mov $2, %edx
int $0x80

#citesc sirul
pushl $sir
pushl $fstring
call scanf
popl %ebx
popl %ebx

#ebx parcurge literele din sir
movl $0, %ebx
for:
lea sir, %edi
xorl %eax, %eax
movb (%edi, %ebx, 1), %al

xorl %ecx, %ecx
cmp %eax, %ecx
je et_exit

lea a, %edi
xorl %ecx, %ecx
movl %ebx, %edx
shl $3, %edx
movl %edx, lineIndex #lineIndex va contine acum indicele de start

#addl $7, %edx
#movl %edx, n #n va contine indicele de oprire

pushl %eax
pushl %ebx
movl $128, n #2^7
for_masca:
movl n, %edx
cmp $0, %edx
je cont_xorare
movl lineIndex, %edx
movl (%edi, %edx, 4), %eax
mull n
addl %eax, %ecx
#n=n/2
movl n, %edx
shr $1, %edx
movl %edx, n
incl lineIndex
jmp for_masca

cont_xorare:

popl %ebx
popl %eax

xorl %ecx, %eax #eax = rez final

movl $240, %ecx #masca de biti 0xF0
pushl %eax #valoarea initiala restaurata
and %ecx, %eax
shr $4, %eax

#afisare primii 4 biti
pushl %eax
pushl $fhexa
call printf
add $8, %esp
push $0
call fflush
add $4, %esp

#prelucrare ultimii 4 biti
movl $15, %ecx
popl %eax #restaurare valoare
and %ecx, %eax

#afisare ultimii 4 biti
pushl %eax
pushl $fhexa
call printf
add $8, %esp
push $0
call fflush
add $4, %esp

yes:
incl %ebx
jmp for

decriptare:
pushl $sir
pushl $fdecript
call scanf
add $8, %esp

movl $0, columnIndex #indice de parcurgere a sirului
for_s:
lea sir, %edi
movl columnIndex, %ebx
xorl %ecx, %ecx
movb (%edi, %ebx, 1), %al

cmp $0, %eax
je et_exit

incl %ebx
incl columnIndex
xorl %ecx, %ecx
movb (%edi, %ebx, 1), %cl

cmp $57, %eax #eax<='9'
jbe cifra_eax
#caz pentru litera
subl $'A', %eax
addl $10, %eax
jmp decript_ecx
cifra_eax:
subl $'0', %eax

decript_ecx:
cmp $57, %ecx #ecx<='9'
jbe cifra_ecx
#caz pentru litera
subl $'A', %ecx
addl $10, %ecx
jmp calcul
cifra_ecx:
subl $'0', %ecx

calcul:
shl $4, %eax
addl %ecx, %eax


#masca copiata de criptare


lea a, %edi
xorl %ecx, %ecx
movl columnIndex, %edx
shr $1, %edx #am impartit la 2
shl $3, %edx
movl %edx, lineIndex #lineIndex va contine acum indicele de start

#addl $7, %edx
#movl %edx, n #n va contine indicele de oprire

pushl %eax
movl $128, n #2^7
for_mascaa:
movl n, %edx
cmp $0, %edx
je cont_xoraree
movl lineIndex, %edx
movl (%edi, %edx, 4), %eax
mull n
addl %eax, %ecx
#n=n/2
movl n, %edx
shr $1, %edx
movl %edx, n
incl lineIndex
jmp for_mascaa

cont_xoraree:

popl %eax

xorl %ecx, %eax #eax = rez final
pushl %eax
pushl $fchar
call printf
add $8, %esp
push $0
call fflush
add $4, %esp


incl columnIndex
jmp for_s

et_exit:
#afisez linie noua
	pushl $newline
	call printf		
	add $4, %esp
	pushl $0
	call fflush
	add $4, %esp
	
	movl $1, %eax
	xorl %ebx,%ebx
	int $0x80
