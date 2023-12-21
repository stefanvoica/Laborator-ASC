.data
n: .long 4
fs: .asciz "%ld! = %ld\n"

.text
factorial:
push %ebp
mov %esp, %ebp
push %ebx

mov 8(%ebp), %eax #%eax = n
cmp $1, %eax
jle stop

dec %eax
push %eax
call factorial
add $4, %esp

#eax = factorial(n-1)
mov 8(%ebp), %ebx

mul %ebx #eax = eax * ebx = factorial(n-1) * n
jmp final

stop:
mov $1, %eax

final:
pop %ebx
pop %ebp
ret

.global main
main:

pushl n
call factorial
add $4, %esp

push %eax
pushl n
pushl $fs
call printf
add $12, %esp

mov $1, %eax
xor %ebx, %ebx
int $0x80

