.data
	scanLinie: .asciz "%300[^\n]"
	delim: .asciz " "
	formatPrintf: .asciz "%d "
	frecv: .long 0
	str: .space 300
	endl: .asciz "\n"
	n: .space 4
	m: .space 4
	nr_el: .space 4
	pattern: .space 400
	stiva: .space 400

.text


.global main

btrack:
    pushl %ebp
    movl %esp, %ebp
    
    pushl %edi
    pushl %esi
    pushl %edx
    pushl %ecx
    pushl %ebx
    
    movl $stiva, %esi
    
    movl 8(%ebp), %edx    #k
    movl $1, %ecx
    
loop:
    cmp n, %ecx
    jg end_loop
    
    movl %ecx, (%esi,%edx,4)
    
    pushl %edx
    call validare
    popl %ebx

    cmp $1, %eax
    jne cont_loop
    
    cmp nr_el, %edx
    je tipar
    
    movl %edx, %ebx
    incl %ebx
    
    pushl %ebx
    call btrack
    popl %ebx
    
cont_loop:
    incl %ecx
    jmp loop
    
end_loop:
    popl %ebx
    popl %ecx
    popl %edx
    popl %esi
    popl %edi
    popl %ebp
    
    ret







validare:
    pushl %ebp
    movl %esp, %ebp
    
    pushl %edi
    pushl %esi
    pushl %edx
    pushl %ecx
    pushl %ebx
    
    movl 8(%ebp), %edx
    movl $stiva, %esi
    movl $pattern, %edi
    
    movl (%edi, %edx,4),%ebx
    cmp $0, %ebx
    je test_1
    
    movl (%esi, %edx,4), %eax
    cmp %ebx, %eax
    je test_1
    
    jmp invalid
    
test_1:
    movl %edx, %eax      #i = k-m
    subl m, %eax
    
    cmp $0, %eax
    jge loop_test1
		xorl %eax, %eax
loop_test1:
    cmp %eax, %edx
    je test_2
    
    movl (%esi, %eax, 4), %ecx       # st[i]
    movl (%esi, %edx,4), %ebx        # st[k]
    cmp %ebx, %ecx
    je invalid
    
    incl %eax                      
    jmp loop_test1
    
test_2:
    movl $1, frecv
    movl $0, %ecx
    
loop_test2:
    cmp %ecx, %edx
    je test_3
    
    movl (%esi, %ecx, 4), %eax       # st[i]
    movl (%esi, %edx,4), %ebx
    cmp %eax, %ebx
    jne cont_loop_test2
    
    incl frecv
    
cont_loop_test2:
    	incl %ecx
    	jmp loop_test2
    
test_3:
	movl %edx, %ecx
	incl %ecx
	movl (%esi, %edx,4), %ebx

loop_test3:
	cmp nr_el, %ecx
	jg test_4

	movl (%edi, %ecx, 4), %eax
	cmp %ebx, %eax
	jne cont_loop_test3
	incl frecv

cont_loop_test3:
	incl %ecx
	jmp loop_test3


test_4:
    	movl frecv, %eax
    	cmp $3, %eax
    	jg invalid    
    
    
valid:
    	movl $1, %eax
    	jmp final_verif


invalid:
    	movl $0, %eax
    	jmp final_verif
    
    
final_verif:
	popl %ebx
    	popl %ecx
    	popl %edx
    	popl %esi
    	popl %edi
    	popl %ebp
        
    	ret
  

main:
	movl $pattern, %edi
	
	pushl $str
	pushl $scanLinie
	call scanf
	popl %ebx
	popl %ebx

	pushl $delim
	pushl $str
	call strtok
	popl %ebx
	popl %ebx

	pushl %eax
	call atoi
	popl %ebx
	
	movl %eax, n
	movl $3, %ebx
	imul %ebx
	decl %eax
	movl %eax, nr_el
	
	pushl $delim
	pushl $0
	call strtok
	popl %ebx
	popl %ebx
	
	pushl %eax
	call atoi
	popl %ebx
	
	movl %eax, m
	
	xorl %ecx, %ecx
for:
	cmp nr_el, %ecx
	jg stop_for
	
	pushl %ecx
	
	pushl $delim
	pushl $0
	call strtok
	popl %ebx
	popl %ebx
	
	pushl %eax
	call atoi
	popl %ebx
	
	popl %ecx
	
	movl %eax, (%edi, %ecx,4)
	incl %ecx
	
	jmp for
	
stop_for:	
	pushl $0
	call btrack
	popl %ebx
	
// afisare -1
	xorl %eax, %eax
	subl $1, %eax
	pushl %eax
	pushl $formatPrintf
	call printf
	popl %ebx
	popl %ebx
	jmp et_exit

tipar:
	xorl %ecx, %ecx
tipar_cont:

	cmp nr_el, %ecx
	jg et_exit
	
	movl (%esi, %ecx,4), %eax
	
	pushl %ecx
	
	pushl %eax
	pushl $formatPrintf
	call printf
	popl %ebx
	popl %ebx
	
	popl %ecx
	incl %ecx
	
	jmp tipar_cont
	
et_exit:
	pushl $endl
	call printf
	popl %ebx


	movl $1, %eax
	xorl %ebx, %ebx
	int $0x80

