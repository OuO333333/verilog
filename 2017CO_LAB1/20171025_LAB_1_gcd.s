.data
msgb : .asciiz "The GCD is : "
inputa : .asciiz "The first number=  "
inputb : .asciiz "The second number=  "
.text
.globl main
main :  
		#Iinput first number
		li $v0, 4 			# load syscall code (4 : print string)
		la $a0, inputa		        # load address of string to be printed into $a0
		syscall				# print str
		li $v0, 5			# load syscall code (5 : read int)
		syscall				# read int
		add $t1, $zero, $v0
		
		#input second number
		li $v0, 4 			# load syscall code (4 : print string)
		la $a0, inputb		        # load address of string to be printed into $a0
		syscall				# print str
		li $v0, 5			# load syscall code (5 : read int)
		syscall				# read int
		add $t2, $zero, $v0
		
		#if(t1>t2)t1-t2; if(t2>t1)swap t1, t2;
comp :	slt $t0, $t1, $t2	
	    beq $t0, $zero, subb
        add $t3, $t1, $zero
        add $t1, $t2, $zero
        add $t2, $t3, $zero
subb :  sub $t1, $t1, $t2
        bne $t1, $zero, comp
		
		#if(t1=0)return t2;
		li $v0, 4 
		la $a0, msgb	
		syscall	
	    add $a0,$zero $t2	
		li $v0, 1 
		syscall		
		li $v0, 10
		syscall
