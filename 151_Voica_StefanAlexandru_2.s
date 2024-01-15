.data
n: .space 4
m: .space 4
k: .space 4
p: .space 4
x: .space 4
y: .space 4
lineIndex: .space 4
columnIndex: .space 4
contor: .long 0
a: .space 1600
b: .space 1600
dx: .long 0, -1, -1, -1, 0, 0, 1, 1, 1
dy: .long 0, -1, 0, 1, -1, 1, -1, 0, 1
fcit: .asciz "%d"
fprint: .asciz "%d "
newline: .asciz "\n"
read: .asciz "r"
write: .asciz "w"
intrare: .asciz "in.txt"
iesire: .asciz "out.txt"

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
pushl stdin
pushl $read
pushl $intrare
call freopen
add $12, %esp

pushl stdout
pushl $write
pushl $iesire
call freopen
add $12, %esp

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
	je et_afis_matr
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

et_afis_matr:
	movl $1, lineIndex
	for_linii:
		movl lineIndex, %ecx
		cmp %ecx, n
		je et_exit
		
		movl $1, columnIndex
		for_col:
			movl columnIndex, %ecx
			incl %ecx
			cmp %ecx, m
			je continua
			
			movl lineIndex, %eax
			movl $0, %edx
			mull m
			addl columnIndex, %eax
			lea a, %edi
			movl (%edi, %eax, 4), %ebx
			
			pushl %ebx
			pushl $fprint 
			call printf
			popl %ebx
			popl %ebx
			
			pushl $0
			call fflush
			popl %ebx
			
			incl columnIndex
			jmp for_col
		
	continua:
		#printf ("\n")
		pushl $newline
		call printf
		add $4, %esp	
		pushl $0
		call fflush
		popl %ebx	
		incl lineIndex
		jmp for_linii
et_exit:
	movl $1, %eax
	xorl %ebx,%ebx
	int $0x80
