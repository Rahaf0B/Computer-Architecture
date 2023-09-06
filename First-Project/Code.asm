


.data
OptionMassage: .asciiz "**For Eencrypion press e\n**For Decryption press d\n"
massageToUserToInputFile1: .asciiz "**Please Input The Name Of The Plain Text File To Encrypet:\n"
massageToUserToInputFile2: .asciiz "**Enter the Cipher File That You Want To Save The Output on it:\n"
massageToUserToInputFile3: .asciiz "**Please Input The Name Of The Cipher Text File:\n"
massageToUserToInputFile4: .asciiz "**Enter the Encryption File That You Want To Save The Output on it:\n"
massageToUserToPrintTheShiftValue: .asciiz "**The Shift Value = "
errorMassage: .asciiz "**You Enter A Wrong Input The Program Will Exit**"
errorMassage2: .asciiz  "**The Name Of The File That You Enter Is Not Exits The Program Will Exit**"
wordFromFile: .space 1024
stringToEncrypt: .space 1024
stringToDecrypt: .space 1024
resultofenc: .space 1024
resultofdec: .space 1024
userFileInput: .space 100
newLine: .asciiz "\n"
outputfile: .space 100
FileName: .space 100
key: .byte 0
.text
.globl main
	
main:
	#display a massage for the user
	la $a0,OptionMassage
	li $v0,4
	syscall 
	
	#get input from the user
	li $v0, 12# Read integer
	syscall # $v0 = value read

	#check what the user enter then go to the correct branch
	beq $v0,'e',encryption_option
	beq $v0,'d',decryption_option
	j Wrong_input

#****ENCRYPTION****
encryption_option:
    	la $a0, newLine        #   print newLine
    	jal display_massage_for_user
    	#display a massage for the user
    	la $a0, massageToUserToInputFile1        
	jal display_massage_for_user
	#get the name of the file from the user and save the value on the variable (userFileInput)
	la $a0, userFileInput # $a0 = address of str
	jal get_file_name_from_user
    	addi $t1, $t1, 0 # length = 0
    	li $t3,0
    	li $t6,1
    	la $a1, userFileInput # $a1 = address of the file name the source of the copy
    	la $a0,FileName # $a0 = address of the file name the distenation of the copy
	#copy string to another
	jal copy_string


open_the_input_file:
	# open the file
	la $a0,FileName  # get the file name
	li $a1,0   # file flag = read (0)
	jal open_file
	bgt $t6,$zero,read_from_file
	j file_not_exist

read_from_file:
	#read the file
	la $a1,wordFromFile  	# The buffer that holds the string of the whole file
	la $a2,1024  # hardcoded buffer length
	#read the data from the file
	jal reading_file
	li $t0, 0
	jal close_the_file

printline:
    la $a0, newLine        #   print newLine
    jal display_massage_for_user
   		
   la $a1,wordFromFile # $a1 = address of data that have been read from the file
   la $a0,stringToEncrypt # $a0 = address of distination of the copy
   #remove the non alphabet characters and after  than the output copy it to (stringToEncrypt)
   jal remove_none_alphabet_characters
   li $t0,0
convert_to_lower_case:
	#make t1 be equal a char from the string that will be converted to lower case
    	lb $t1, stringToEncrypt($t0)
    	#if it arrive to the end of the string will break the loop
    	beq  $t1, 0, continue_next
    	#check if the char is less than the ascii value of A if it is then it will go to a branch
    	blt $t1, 'A', go_to_next_char
    	#check if the char is greater than the ascii value of Z if it is then it will go to a branch
    	bgt $t1, 'Z', go_to_next_char
    	addi $t1, $t1, 32 #converte the char to lower by add to its ascii value 32
    	sb $t1, stringToEncrypt($t0)
go_to_next_char: 
#go to the next char of the string
    	addi $t0, $t0, 1
    	j convert_to_lower_case
	
	
continue_next:
	li $t0, 0
	la $a0,stringToEncrypt #load the string thet will be encrypted to $a0
	li $t3,0
	li $v1,0
	la $t0, stringToEncrypt  #load the string thet will be encrypted to $t0
	#get the max length of the strings that has been read from the file
	jal start_to_count_the_number_of_char_in_each_word



jal print_the_shift_value_to_the_user 

get_the_name_of_the_output_file_from_the_user:

    la $a0, newLine        #   print newLine
    jal display_massage_for_user
    
    la $a0, massageToUserToInputFile2 #display a massage for the user
    jal display_massage_for_user
    la $a0, outputfile # $a0 = address of the output file name
   jal get_file_name_from_user #get the filr name from the user
    
    

encryotionprocess:
	lb $s0,key
	la $s2, resultofenc #$s2= address of the string that will saved theoutput of teh encryption on it 
	li $s3, 0
	la $t3, stringToEncrypt  #load stringToEncrypt to $t3
	encrypt:
		lb $t0, 0($t3)   #make $t2 point to the first char of (stringToEncrypt)
    		beq $t0,'\n',continue_to_next_char #check for new line
    		beq $t0,' ',continue_to_next_char #check for space
    		beqz $t0,save_the_encryption_value_into_file #if it arrive to the end of the string then exit the loop
    		blt $t0, 'a', skip_the_char #check if the char ascii less than the ascii of 'a' if it is then go to a branch
    	     	bgt $t0, 'z', skip_the_char #check if the char ascii grater than the ascii of 'z' if it is then go to a branch
    		addu $t1,$t0,$s0 #calculate the char value with the shift
    		bgt $t1,122,the_shifted_value_is_grater_than_z #check if the value of the ascii of the char that been shifted if it is grater than the ascci value of z or not
    		continue:
    		sb $t1, ($s2) #store char in s2 (resultofenc)
    		addi $t3, $t3, 1 #go to next char
		addi $s2, $s2, 1 #increment address
		addi $s3, $s3, 1 #count of chars
		j encrypt
	skip_the_char:
		addi $t3, $t3, 1 #go to next char
		j encrypt
	continue_to_next_char:
		sb $t0, ($s2) #store char in s2 (resultofenc)
		addi $s2, $s2, 1 #increment address
		addi $t3, $t3, 1   #go to next char
		addi $s3, $s3, 1 #count of chars
		j encrypt
	the_shifted_value_is_grater_than_z:
		sub $t4,$t1,122
		addi $t1,$t4,96
		j continue
		  	
  
    	save_the_encryption_value_into_file:
    
        sub $s2, $s2, $s3 #reset to first address to let $s2 point to the first char of the resultofenc
    	la $a1,outputfile
    	li $t6,2
    	la $a0,FileName
    	addi $t1, $t1, 0 # length = 0
    	li $t3,0
    	jal copy_string
    	
    
    	open_the_output_file:
    	
    		la $a0,FileName   # get the file name
    		li $a1,1   # file flag = write (1)
    		jal open_file  #open the output file 

    	jal print_into_file #print into the file
    	jal close_the_file #close the file
    	j exit
    	
    	
    		  	  	  	  	  	  	  	  	  	  	  	  	  	
    	
    	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	
    	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	
    	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	
#****DECRYPTION****
    	decryption_option:
		la $a0, newLine        #   print newLine
    		jal display_massage_for_user
    		la $a0, massageToUserToInputFile3        #   print newLine
		jal display_massage_for_user
	#get input (the file name) from the user 
		la $a0, userFileInput # $a0 = address of str
		jal get_file_name_from_user
    		addi $t1, $t1, 0 
    		li $t3,0
    		li $t6,1
    		la $a1, userFileInput # $a0 = address of str
    		la $a0,FileName
		jal copy_string
		
		
		open_the_input_file_for_decryption:
			# open the file
			la $a0,FileName     	# get the file name
			li $a1,0           	# file flag = read (0)
			jal open_file
			#check if the file is exists if it then go and open it if not hen dispaly a massage  for the user then exit the program
			bgt $t6,$zero,read_from_file_for_decryption 
			j file_not_exist
	
		read_from_file_for_decryption:
		#read the file
			la $a1,wordFromFile  	# The buffer that holds the string of the WHOLE file
			la $a2,1024		# hardcoded buffer length
			jal reading_file #read the file
			li $t0, 0
			jal close_the_file #close the file

    			la $a0, newLine        #print newLine
    			jal display_massage_for_user
    		
    	
    		la $a1,wordFromFile	
   		la $a0,stringToDecrypt
   		la $t4,stringToDecrypt
   		#remove non char from the string
    		jal remove_none_alphabet_characters
    		
    		#find the max lenght of string
    		claculate_key:
    			li $t0, 0
			la $a0,stringToDecrypt # The buffer that holds the string 
			li $t3,0
			li $v1,0
			la $t0, stringToDecrypt  #load mystring to $t0
			#count the number of char
	 		jal start_to_count_the_number_of_char_in_each_word
	 	#print the key for the user
   		jal print_the_shift_value_to_the_user 
   		
   		
   		
   		get_the_name_of_the_deryption_output_file_from_the_user:
		
    			la $a0, newLine        #   print newLine
    			jal display_massage_for_user
   	 		la $a0, massageToUserToInputFile4    #pritn a massage for the user
    			jal display_massage_for_user
    			la $a0, outputfile # $a0 = address of the string 
    			#get the name of the output filr from the user
   			jal get_file_name_from_user
    
   		
   		
   		decryption_process:
   			lb $s0,key
			la $s2, resultofdec #make s2 have the address of the output buffer
			li $s3, 0
			la $t3, stringToDecrypt  #load mystring to $t3
			decrypt:
   				lb $t0, 0($t3)  #make $t0 point to a character of "stringToDecrypt"
    				beq $t0,'\n',continue_to_next_char_decryption #check if the char is \n
    				beq $t0,' ',continue_to_next_char_decryption #check if the char is space
    				beqz $t0,save_the_decryption_value_into_file #check if the char is 0 then it will be the end of the file
    				blt $t0,'A',skip_the_char_decryption #check if the char is
    			 	bgt $t0,'Z',check_if_the_char_is_lower_case_to_decrypt #check if the char its ascii value grater than Z
    				subu $t1,$t0,$s0 #decrypt the char
				blt $t1,65,the_shifted_value_is_less_than_A
    			continue_decryption:
    				sb $t1, ($s2) #store char in s2
    				addi $t3, $t3, 1 #go to next char
				addi $s2, $s2, 1 #increment address
				addi $s3, $s3, 1 #count of chars
				j decrypt
			skip_the_char_decryption:
				addi $t3, $t3, 1 #go to next char
				j decrypt
			continue_to_next_char_decryption:
				sb $t0, ($s2) #store char in s2
				addi $s2, $s2, 1 #increment address
				addi $t3, $t3, 1   #go to next char
				addi $s3, $s3, 1 #count of chars
				j decrypt
			the_shifted_value_is_less_than_A:
				# if the ascii value of the char after decrypt is less than A then go back to A and continue decrypt 
				li $t5,65
				sub $t4,$t5,$t1
				li $t5,91
				sub $t1,$t5,$t4
				j continue_decryption
			the_shifted_value_is_less_than_a:
			# if the ascii value of the char after decrypt is less than a then go back to a and continue decrypt 
				li $t5,97
				sub $t4,$t5,$t1
				li $t5,123
				sub $t1,$t5,$t4
				j continue_decryption
		  	check_if_the_char_is_lower_case_to_decrypt:
		  		blt $t0, 'a', skip_the_char_decryption #check if the char it ascii value is less than a then go to the next char
   				bgt $t0, 'z', skip_the_char_decryption #check if the char it ascii value is greater than z then go to the next char
   				#decrypt the char
   				subu $t1,$t0,$s0
    				blt $t1,97,the_shifted_value_is_less_than_a
    				j continue_decryption		
   		
   			save_the_decryption_value_into_file:
        			sub $s2, $s2, $s3 #reset to first address
        			#get the ouput file name
    				la $a1,outputfile
    				li $t6,2
    				la $a0,FileName
    				addi $t1, $t1, 0 
    				li $t3,0
    				#copy the file name into another string and delete \n from the end of it
    				jal copy_string

    
    				open_the_output_file_for_decryption:
    					
    					la $a0,FileName  # get the file name
    					li $a1,1  # file flag = write (1)
    					 #open file 
    					jal open_file
					#write into the file
    					jal print_into_file
    					#close the file
    					jal close_the_file
    					j exit
    	
    	
    		  	  	  	  	  										
	
		

	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	
    	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	
    	  	  	  	  	  	
    	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	
    	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	
    	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	
    	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	
    	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	
    	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	
    	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	
    	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	
    	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	
    	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	
    	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	
    	
   delete_the_new_line_from_the_file_name:
 	   	lb $t2, ($a0) #$t2 = address of target[i]
  	   	beq $t2, '\n', finish  #check if the char is \n then go to the finish branch 
   	   	beq $t2, 10, finish #check if the char its ascii value = 10 then go to the finish branch 
   	   	addi $t1, $t1, 1 
   	   	addi $t3, $t3, 1 
   	   	addi $a0, $a0, 1 #go to the next char
           	b delete_the_new_line_from_the_file_name
	finish:
    		la $a0, FileName 
    		add $a0, $a0, $t1 #go to the address where \n is tored in the string 
    		sb $zero, ($a0) #overwrite '\n' with 0 		 	
    		jr $ra
	copy_string:
		lb $t0, 0($a1) # load byte: $t0 = source[i]
		sb $t0, 0($a0) # store byte: target[i]= $t0
		addiu $a0, $a0, 1 # go to the next char
		addiu $a1, $a1, 1 # go to the next address 
		bnez $t0, copy_string # loop until NULL char
		li $t3,0
		li $t1,0
		la $a0,FileName
		j delete_the_new_line_from_the_file_name
		

		
   
	remove_none_alphabet_characters:
		lb $t0, 0($a1) # load byte: $t0 = source[i]
		beq $t0,'\n',continue_to_next_char_of_string #check if the char is \n then go to the next char 
    		beq $t0,' ',continue_to_next_char_of_string #check if the char is space then go to the next char 
    		blt $t0, 'A', continue_to_next_char_to_remove #check if the ascii of the char is less than A
    		bgt $t0, 'Z', check_if_the_char_is_lower_case   #check if the scii value of the char is grater than Z	
    		continue_to_next_char_of_string:
		sb $t0, 0($a0) # store byte: target[i]= $t0
		addiu $a0, $a0, 1 # $a0 = &target[i]
		addiu $a1, $a1, 1 # $a1 = &source[i]
		j remove_none_alphabet_characters
		continue_removing:
		li $t3,0
		li $t1,0
		move $a0,$t4
		jr $ra
	continue_to_next_char_to_remove:
	        beq  $t0,0,continue_removing# loop until NULL char
		addiu $a1, $a1, 1 # $a1 = &source[i]
		j remove_none_alphabet_characters
		
	check_if_the_char_is_lower_case:
		blt $t0, 'a', continue_to_next_char_to_remove #check if the ascii of the char is less than a
		bgt $t0, 'z', continue_to_next_char_to_remove #check if the scii value of the char is grater than z
		j continue_to_next_char_of_string
		
	display_massage_for_user:
		li $v0, 4
    		syscall
    		jr $ra

	get_file_name_from_user:
		li $a1, 100 # $a1 = max string length
		li $v0, 8 # read string
		syscall
		jr $ra
	open_file:
		li $v0,13           	# open_file syscall code = 13	
    		syscall
    		move $s0,$v0        	# save the file descriptor. $s0 = file
    		move $t6,$s0
    		jr $ra
    		
    	reading_file:
    		li $v0, 14		# read_file syscall code = 14
		move $a0,$s0		# file descriptor
		syscall
		jr $ra
		
		
	print_into_file:
    	#Write the file
    		li $v0,15		# write_file syscall code = 15
    		move $a0,$s0		# file descriptor
    		move $a1,$s2		# the string that will be written
    		move $a2,$s3		# length of the toWrite string
    		syscall
    		jr $ra
	close_the_file:
		#Close the file
    		li $v0, 16         		# close_file syscall code
    		move $a0,$s0      		# file descriptor to close
    		syscall
		jr $ra
		
		
		
		
		
		
	start_to_count_the_number_of_char_in_each_word:

    		li $t1, 0  #make $t1 = 0, character counter
    		lb $t2, 0($t0) #make $t2 point to the first character of "my_string"
    		li $t4,0
    		j count_the_number_of_char_in_each_word
	count_the_number_of_char_in_each_word:
    		lb $a0, 0($t0)    # load the char into a0
    		beqz $a0, go_back  # if \0 is found then break the loop
    		beq $a0,'\n',go_to_next_char_of_string # if \n is found then go to the next char
    		beq $a0,'\t',go_to_next_char_of_string # if \t is found then go to the next char
    		beq $a0,' ',go_to_next_char_of_string # if space is found then go to the next char
    		addi $t1, $t1, 1  #increase the counter
    		addi $t0, $t0, 1  #go to next char
    		j count_the_number_of_char_in_each_word

	go_to_next_char_of_string:
 		addi $t0, $t0, 1  #go to next char
 		li $t5,0
 		#check if the value in reg t1 is grater than the value in t4
 		bgt $t1,$t4,cheack_for_the_max_word_lenght
 		li $t1,0
 		j count_the_number_of_char_in_each_word
  
	cheack_for_the_max_word_lenght:
    		move $t4,$t1
    		li $t1,0
    		beq $t5,0,count_the_number_of_char_in_each_word #if t5 is equal 0 countinue coutnting
    		beq $t5,1,continue_print #if t5 is equal 0 go to print the value
   	go_back:
   		jr $ra
				
	print_the_shift_value_to_the_user  :
		li $t5,1
		#check if the value in reg t1 is grater than the value in t4
		bgt $t1,$t4,cheack_for_the_max_word_lenght
		j continue_print
		jr $ra
		
	continue_print:
		#print massage to the user
     		la $a0, massageToUserToPrintTheShiftValue        
     		li $v0, 4
    		syscall
     		move $a0, $t4 #dispaly the shifted value for the user
     		li $v0, 1
     		syscall   
     		la $a0, newLine  #print newLine
    		li $v0, 4
    		syscall
    		#store the shifted value in the key variable
    		la $t0,key
    		sb $t4,($t0)
		jr $ra
		
		
	Wrong_input:
		la $a0, newLine        #print newLine
    		jal display_massage_for_user
    		#print massage to the user
		la $a0,errorMassage
		jal display_massage_for_user  		
		j exit
	
	file_not_exist:
		la $a0, newLine        #print newLine
    		jal display_massage_for_user
    		#print massage to the user
		la $a0,errorMassage2
		jal display_massage_for_user  		
		j exit
	
		
	
	
	
exit:	
	li $v0, 10 # Exit program
	syscall
	
	
	
