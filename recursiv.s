#f(x) = x + 4
#g(y) = f(y) + f(y+1)
#Sa se calculeze f(5) + 3g(1)

.data
fs: .asciz "f(5) + 3g(1) = %ld\n"

.text
f:
push %ebp
mov %esp, %ebp

mov 8(%ebp), %eax
add $4, %eax

pop %ebp
ret

g:
push %ebp
mov %esp, %ebp
push %ebx
mov 8(%ebp), %eax
#eax = y
push %eax #salvam reg
push %eax #argumentul functiei f
call f
#eax = f(y)
mov %eax, %ebx
add $4, %esp
pop %eax

#eax=y, ebx=f(y)
inc %eax
push %eax
call f
#eax = f(y+1)
add $4, %esp

#eax = f(y+1), ebx = f(y)

add %ebx, %eax
#eax = f(y) + f(y+1)

pop %ebx
pop %ebp
ret


.global main
main:
pushl $5
call f
mov %eax, %ebx
add $4, %esp

#%ebx = f(5)

pushl $1
call g
add $4, %esp
#eax = g(1)

mov $3, %ecx
mul %ecx 	#eax = ecx * eax = 3g(1)

add %ebx, %eax 	#eax = f(5) + 3g(1)

push %eax
push $fs
call printf
add $8, %esp

mov $1, %eax
xor %ebx, %ebx
int $0x80
