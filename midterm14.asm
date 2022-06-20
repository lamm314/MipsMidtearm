#=================================
#Given two strings, find the number of common characters between them. 
#Example: For s1 = "aabcc" and s2 = "adcaa", the output should be 3. 
#Strings have 3 common characters - 2 "a"s and 1 "c". 
#1.	Phân tích cách th?c hi?n 
#o Phân tích de bài 
#? Input là 2 xâu kí tu. 
#? Output hien thi ra màn hình tong so so kí tu giong nhau cua 2 xâu. 
#o Chuong trình chính duoc chia thành các phan nhu sau:
# ? main: nguoi dùng nhap vào 2 xâu kí tu, xu lý các loi input. 
#? L1: x? lý string1 
#? L2: x? lý string2 
#? loop: So sánh có bao nhiêu kí tu giong nhau giua 2 xâu. 
#? output: in ra tong so so kí tu giong nhau 
#====================================

#int []freq1 = new int[62];
#    int []freq2 = new int[62];
#    Arrays.fill(freq1, 0);
#    Arrays.fill(freq2, 0);
#    for (i = 0; i < n1; i++)
#        freq1[s1.charAt(i) - 'a']++;
#    for (i = 0; i < n2; i++)
#        freq2[s2.charAt(i) - 'a']++;
#    for (i = 0; i < 62; i++)
#       count += (Math.min(freq1[i], freq2[i]));
.data
freq1: .word 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
freq2: .word 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0

string1: .space 100
string2: .space 100
Message: .asciiz "Result: "
message1: .asciiz "Input String 1: "
message2: .asciiz "Input String 2: "
message_error1: .asciiz "Error no data input! Please enter data!"
message_error2: .asciiz "Error Cancel! Please enter data!"  
.text
main:
	jal input
	nop
	jal count
	nop
	jal count2
	nop
	jal loop
	nop
	jal output
	nop

end_main:
	li $v0, 10
	syscall

input:
	#read string1:
	li $v0, 54 #InputDialogString
 	la $a0, message1 #show message1
 	la $a1, string1	
 	la $a2, 100 #maximum number of characters to read
	syscall
	bnez $a1, error_input  #so sanh a1 voi 0, neu bang thi hien error
	#read string2:
	li $v0, 54 #InputDialogString
 	la $a0, message2 #show message2
 	la $a1, string2
 	la $a2, 100 #maximum number of characters to read
	syscall
	bnez $a1, error_input #so sanh a2 voi 0, neu bang thi hien error
	nop
	j process #nhay toi process
	#================================== 
	#======error 
error_input: #hien loi
	li $v0, 55  #showMessageDialog
	li $a1, 2              # warning message  
	beq $s6, -2, error1  #neu la loi khong nhap gi thi in ra loi 1
	nop 
	beq $s6, -3, error2  #neu la loi cancel thi hien loi 2
	nop
error1:  
        la $a0, message_error1  #show ra loi 1
	syscall  
	j end_error  #nhay den end_error
	error2:  
	la $a0, message_error2  #show ra loi 2
	syscall  
	j end_error  #nhay den end_error
	end_error:    
	j input #nhay ve buoc input
	###############

process:
	la $a1, string1 #load adress of string1
	la $a2, string2 #load adress of string2
	la $k0, freq1 #load adress of freq1
	la $k1, freq2 #load adress of freq2
	li $t5,62
	add $s0,$zero,$zero # $s0 = i = 0
end_input:
jr $ra
count:
L1:
	add $t1,$s0,$a1 # $t1 = $v0 + $a1 = i + string1[0] # = adress	of string1[i]
	lb $t3,0,($t1) # $t3 = value at $t1 = string1[i]end_L1:


character:
	bge $t3,65,letter #neu t3 lon hon hoac bang 65 thi chuyen den nhan letter
 	nop
	#bge $t3,48,number #neu t3 lon hon hoac bang 48 thi chuyen den nhan number
 	#nop
letter:
	ble $t3,90,Bold #neu t3 nho hon bang 90 thi chuyen den nhan Bold
	nop
	bge $t3,97,Normal #neu t3 lon hon hoac bang 97 thi chuyen den Normal
	nop
Bold:
	subi $t6,$t3,65 #tru t6 = t3 - 65
	j  done #nhay den done
Normal:
	subi $t6,$t3,70	#tru t6= t3 - 70
	j done #nhay den done
#	number:
#	ble $t3,57,oke  #neu t3 nho hon hoac bang 57 thi nhay den oke
#	nop
#	oke:
#	addi $t6,$t3,5 #cong t6 = t3 + 5
#	j done #nhay den done
done:
	add $t6,$t6,$t6 #t6 = t6 x2
	add $t6,$t6,$t6 #t6 = t6x2
	add $t6,$t6,$k0 #$t6 store the address of freq1[i]
	#dich con tro ve dia chi tuong ung cua mang
	
	lw $t7,0($t6) # dua gia tri freg1 vao thanh ghi t7
	addi $t7,$t7,1 #t7 = t7+1
	sw $t7,0($t6) # luu gia tri mang vao t7
	beq $t3,$zero,end_of_string1 # if string1[i] == 0, exit
	nop
	addi $s0,$s0,1 #$s0 = $s0 + 1 <-> i = i + 1
	j L1 #next character
	nop
	
end_of_string1:
	add $s0,$zero,$zero # $s0 = i = 0
end_count:
jr $ra
count2:
L2:
	add $t2,$s0,$a2 # $t2 = $v0 + $a2 = i + string2[0] # = adress	of string2[i]
	lb $t3,0,($t2) # $t3 = value at $t2 = string2[i]


character2:
	bge $t3,65,letter2 #neu t3 lon hon hoac bang 65 thi nhay den letter2
 	nop
# 	bge $t3,48,number2 #neu t3 lon hon hoac bang 48 thi nhay den number2
# 	nop
letter2:
	ble $t3,90,Bold2 #neu t3 nho hon hoac bang 90 thi nhay den Bold2
	nop
	bge $t3,97,Normal2 #neu t3 lon hon hoac bang 97 thi nhay den Normal2
	nop
Bold2:
	subi $t6,$t3,65	#t6 = t3 - 65
	j  done2
Normal2:
	subi $t6,$t3,70 #t6 = t3 - 70
	j done2
#	number2:
#	ble $t3,57,oke2 # t3 <= 57 thi nhay den oke2
#	nop
#	oke2:
#	addi $t6,$t3,5 #t6 = t3 +5
#	j done2
done2:
	add $t6,$t6,$t6 #t6 = 2 x t6
	add $t6,$t6,$t6 #t6 = 4 x t6
	add $t6,$t6,$k1 #$t3 store the address of freq2[i]
	#dich con tro ve dia chi tuong ung cua mang
	lw $t7,0($t6) #luu gia tri cua freg2 vao thanh ghi t7
	addi $t7,$t7,1
	sw $t7,0($t6)# luu gia tri cua mang vao t7
	beq $t3,$zero,end_of_string2 # if string2[i] == 0, exit
	nop
	addi $s0,$s0,1 #$s0 = $s0 + 1 <-> i = i + 1
	j L2 #next character
	nop
end_of_string2:
	addi $t9,$t9,0
	add $s0,$zero,$zero # $s0 = i = 0
end_count2:
jr $ra

loop:
	beq $s0,$t5,end_loop # if i = n-1 then end_loop
	nop
	add $t3,$s0,$s0 # t3 = 2*s0
	add $t3,$t3,$t3 # t3 = 4*s0
	add $t4,$t3,$k0 # $t3 store the address of freq1[i]
	lw $t6,0($t4) # t6 = freq1[i]
	add $t4,$t3,$k1 # $t3 store the address of freq2[i]
	lw $t7,0($t4) # t7 = freq2[i]
	addi $s0,$s0,1 # i++
	bge $t6,$t7,plus1 #if t6 >= t7 jump to plus1
	nop
	bge $t7,$t6,plus2 #if t7 >= t6 jump to plus2
	nop
plus1:
	add $t9,$t9,$t7 #t9 = t9 + t7
	j loop
	nop
plus2:
	add $t9,$t9,$t6 #t9 = t9 + t6
	j loop
	nop
end_loop:
jr $ra

output:
	li $v0, 56 #showMessageDialogInt
	la $a0, Message
	add $a1,$t9,$zero
	syscall
end_output:
jr $ra



	
	
