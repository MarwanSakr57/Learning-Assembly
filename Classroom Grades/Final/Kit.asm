CODE		SEGMENT
		ASSUME	CS:CODE, DS:CODE				 

		ORG	0
START:
        MOV AX, CS                   ; Initialize data segment
        MOV DS, AX
        JMP MAIN

;============Main Program============

MAIN PROC
    

        LEA DX, StudNO_msg           ; Display prompt for number of students
        MOV AH, 9
        INT 21H 
        
    	MOV	AH,1	                 ;Clear LCD
		CALL	IRWR

		MOV	AH,80H                   ;Set Cursor to (1,0)
		CALL	IRWR

		MOV	AH,'E'                   ;Print Std. No. Input Msg to LCD
		CALL	OUTL
		MOV	AH,'n'
		CALL	OUTL
		MOV	AH,'t'
		CALL	OUTL
		MOV	AH,'e'
		CALL	OUTL
		MOV	AH,'r'
		CALL	OUTL	
		MOV	AH,' '
		CALL	OUTL
		MOV	AH,'N'
		CALL	OUTL
		MOV	AH,'O'
		CALL	OUTL 
		MOV	AH,'.'
		CALL	OUTL
		MOV	AH,'O'
		CALL	OUTL
		MOV	AH,'f'
		CALL	OUTL
		MOV	AH,0C0H
		CALL	IRWR		
		MOV	AH,'S'
		CALL	OUTL
		MOV	AH,'t'
		CALL	OUTL	
		MOV	AH,'u'
		CALL	OUTL
		MOV	AH,'d'
		CALL	OUTL
		MOV	AH,'e'
		CALL	OUTL		
		MOV	AH,'n'
		CALL	OUTL
		MOV	AH,'t'
		CALL	OUTL
		MOV	AH,'s'
		CALL	OUTL
		MOV	AH,':'
		CALL	OUTL	
        
        CALL READ_NUMBER              ; Read number of students (returns AX)
        MOV StudNo, AX                ; Store number of students
        
                                    
        LEA DX, StudID_msg            ; Display prompt for student IDs
        MOV AH, 9
        INT 21H
        
        MOV	AH,1	                  ;Clear LCD
		CALL	IRWR

		MOV	AH,80H                    ;Set Cursor to (1,0)
		CALL	IRWR

		MOV	AH,'E'                    ;Print ID Input Msg to LCD
		CALL	OUTL
		MOV	AH,'n'
		CALL	OUTL
		MOV	AH,'t'
		CALL	OUTL
		MOV	AH,'e'
		CALL	OUTL
		MOV	AH,'r'
		CALL	OUTL	
		MOV	AH,' '
		CALL	OUTL
		MOV	AH,'S'
		CALL	OUTL
		MOV	AH,'t'
		CALL	OUTL 
		MOV	AH,'u'
		CALL	OUTL
		MOV	AH,'d'
		CALL	OUTL
		MOV	AH,'e'
		CALL	OUTL		
		MOV	AH,'n'
		CALL	OUTL
		MOV	AH,'t'
		CALL	OUTL	
		MOV	AH,0C0H
		CALL	IRWR
		MOV	AH,'I'
		CALL	OUTL
		MOV	AH,'D'
		CALL	OUTL		
		MOV	AH,':'
		CALL	OUTL    
    
    ; Read student IDs
        MOV CX, StudNo                  ;Set Counter for loop = Std. No.
        LEA SI, STUDENT_IDS             ;Point to student IDs array
        
;============Input loops============          

ID_INPUT_LOOP:
        LEA DX, NEWLINE                 ;Point to NewLine Msg
        MOV AH, 9
        INT 21H                         ;Print NewLine
        
        CALL READ_NUMBER                ;Read Std. ID input (returns AX)
        MOV [SI], AX                    ;Store AX in Std. ID array
        ADD SI, 2                       ;Move to next element in array (ID stored in word = 2 bytes0
	    CALL ERASE                      ;Erase ID on LCD
        LOOP ID_INPUT_LOOP              ;Keep Looping until CX=0
        
        
        LEA DX, StudGrade_msg           ;Display prompt for grades
        MOV AH, 9
        INT 21H 
        
        MOV	AH,1	                    ;Clear LCD
		CALL	IRWR

		MOV	AH,80H                      ;Set Cursor to (1,0)
		CALL	IRWR

		MOV	AH,'E'                      ;Print Grades Input Msg on LCD
		CALL	OUTL
		MOV	AH,'n'
		CALL	OUTL
		MOV	AH,'t'
		CALL	OUTL
		MOV	AH,'e'
		CALL	OUTL
		MOV	AH,'r'
		CALL	OUTL	
		MOV	AH,' '
		CALL	OUTL
		MOV	AH,'S'
		CALL	OUTL
		MOV	AH,'t'
		CALL	OUTL 
		MOV	AH,'u'
		CALL	OUTL
		MOV	AH,'d'
		CALL	OUTL
		MOV	AH,'e'
		CALL	OUTL		
		MOV	AH,'n'
		CALL	OUTL
		MOV	AH,'t'
		CALL	OUTL	
		MOV	AH,0C0H
		CALL	IRWR
		MOV	AH,'G'
		CALL	OUTL
		MOV	AH,'r'
		CALL	OUTL		
		MOV	AH,'a'
		CALL	OUTL
		MOV	AH,'d'
		CALL	OUTL
		MOV	AH,'e'
		CALL	OUTL		
		MOV	AH,'s'
		CALL	OUTL
		MOV	AH,':'
		CALL	OUTL		
    
        MOV CX, StudNo                  ;Set Counter for loop =Std.No.
        LEA SI, GRADES                  ; Point to grades array

READ_GRADE: 
                                        ;Call Input Loop
        CALL GRADE_INPUT_LOOP 
        
        CALL SORT_BY_GRADES             ;Call Bubble Sort Subroutine

        JMP OUTPUT
    

GRADE_INPUT_LOOP:
        LEA DX, NEWLINE                 ;Print New line
        MOV AH, 9
        INT 21H 
        call KEYPAD                     ;Read Input from Keypad
        add AL,7h                       ;e.g: (input =0AH ,Keypad Subroutine adds 30H =3AH, ascii 'A'= 41H, so add 3AH+07H=41H)
        PUSH AX                         ;Save AX
        mov AH,AL                       ;Move Grade to AH
        call OUTL                       ;Print Grade on LCD
        POP AX                          ;Restore AX
        mov [si],AL                     ;Store Grade in Grade array
        inc si                          ;Move to next element
        loop GRADE_INPUT_LOOP
        ret  
;============Output Loops============
OUTPUT:	
                                        ;Print Result Msg
        LEA DX, RESULT_MSG
        MOV AH, 9
        INT 21H
        
        MOV CX, StudNo                  ;Set Counter = Std. No.    
        LEA SI, STUDENT_IDS             ;Point to sorted student IDs
        LEA DI, GRADES	                ;Point to sorted student Grades
        
		MOV	AH,1	                    ;Clear LCD
		CALL	IRWR

		MOV	AH,80H                      ;Set Cursor to (1,0)
		CALL	IRWR

		MOV	AH,'I'                      ;Print Result Msg on LCD
		CALL	OUTL
		MOV	AH,'D'
		CALL	OUTL
		MOV	AH,':'
		CALL	OUTL
		MOV	AH,' '
		CALL	OUTL
		MOV	AH,' '
		CALL	OUTL
		MOV	AH,' '
		CALL	OUTL
		MOV	AH,' '
		CALL	OUTL
		MOV	AH,' '
		CALL	OUTL
		MOV	AH,'G'
		CALL	OUTL
		MOV	AH,'R'
		CALL	OUTL
		MOV	AH,'A'
		CALL	OUTL
		MOV	AH,'D'
		CALL	OUTL
		MOV	AH,'E'
		CALL	OUTL
		MOV	AH,':'
		CALL	OUTL 
		
		LEA DI,GRADES                   ;Point to sorted student Grade
        LEA SI,STUDENT_IDS              ;Point to sorted student IDs

PRINT_RESULTS_LOOP:
        call KEYPAD                     ;Read Input from Keypad
        CMP AL,3FH                      ;Enter
        JNE PRINT_RESULTS_LOOP          ;If not ,keep looping until Enter is pressed
       
        LEA DX, ID_MSG                  ;print std. ID Msg
        MOV AH, 9
        INT 21H 
                                        ;Move Cursor to (2,0)
        MOV	AH,0C0H
        CALL IRWR
        XOR AX,AX                       ;AX=0
        MOV AX,[SI]                     ;Get student ID from array
        CALL PRINT_NUMBER               ;Print ID (prints on screen and LCD)
        
        
                                        ; Print grade Msg
        LEA DX, GRADE_MSG
        MOV AH, 9
        INT 21H
    
        
        
        MOV DL,[DI]                    ; Get grade from array
        MOV AH,02H                     ;Print Grade on screen (prints one symbol)
        INT 21H
    
        MOV	AH,0C7H                    ;Move cursor to (2,7)
        CALL	IRWR
    
        MOV	AH,' '                     ;Print space on LCD
        CALL OUTL
        MOV	AH,[DI]                    ;Print Grade on LCD
        CALL OUTL
        
        ADD SI, 2                      ;Move to next student ID
        ADD DI, 1                      ;Move to next student Grade
        dec StudNo       
        cmp StudNo,0                   ;if Done
        je  EXIT                       ;Exit Program
        LOOP PRINT_RESULTS_LOOP
ERASE:
    	MOV AH,0C3H                    ;Move Cursor to (2,3)
    	CALL IRWR
    	MOV AH,' '                     ;Print 4 Spaces
    	CALL OUTL 
    	MOV AH,' '
    	CALL OUTL 
    	MOV AH,' '
    	CALL OUTL 
    	MOV AH,' '
    	CALL OUTL 
    	MOV AH,0C3H                    ;Move Back Cursor to (2,3)
    	CALL IRWR
        RET

EXIT:    MOV AX, 4C00H                 ;Exits Program and returns control to DOS
          INT 21H
MAIN ENDP

;============Bubble Sort============

SORT_BY_GRADES PROC
        MOV CX, StudNo                  ;Set Counter to STD. NO.
        DEC CX                          ;(N-1) passes needed for Bubble Sort
OUTER_LOOP:
        PUSH CX                         ;Save CX
        
        LEA SI, GRADES                  ;Point to Grades array
        LEA DI, STUDENT_IDS             ;Point to IDs array
        MOV BX, CX                      ;Set Inner loop counter

INNER_LOOP:
        MOV Al, [SI]                    ;Prepare first grade
        MOV Dl, [SI+1]                  ;Prepare Second Grade
        CMP Al, Dl                      ;Compare Grades , if Al below or equal DL(Sorted Alrdy):
        JBE CONTINUE                    ;Skip swap
                                        ;If not:
        
        mov ah,[si]                     ; Swap grades
        mov al,[si+1]
        mov [si],al
        mov [si+1],ah
        
        mov ah,[di]                     ; Swap corresponding student IDs
        mov al,[di+2]
        mov [di],al                     ;Swap High Byte 
        mov [di+2],ah
        mov ah,[di+1]
        mov al,[di+3]                   ;Swap Low Byte
        mov [di+1],al
        mov [di+3],ah

CONTINUE:
        ADD SI, 1                       ;Move to next
        ADD DI, 2
        LOOP INNER_LOOP
        
        POP CX                          ;Restore outer loop counter
        LOOP OUTER_LOOP
        RET
SORT_BY_GRADES ENDP  

;============Subroutines============  


READ_NUMBER PROC
        XOR BX, BX                      ;BX= 0
READ_DIGIT:
        call keypad                     ;Read from Keypad
        CMP AL, 3FH                     ;If Enter
        JE READ_DONE                    ;ID done , move to next
        push ax                         ;Save Ax
        mov ah, al                      ;Print ID to LCD
        call outl
        pop ax                          ;Restore AX
        SUB AL, '0'                     ;Subtract 30h
        XOR AH, AH                      ;Ah=0
        PUSH AX                         ;Save AX
        MOV AX, 10                      ;AX=10
        MUL BX                          ;AX=AX*BX
        MOV BX, AX                      ;BX=AX
        POP AX                          ;Restore AX
        ADD BX, AX                      ;BX=Bx+AX
        JMP READ_DIGIT                  ;loop
READ_DONE:
        MOV AX, BX
        RET
READ_NUMBER ENDP

PRINT_NUMBER PROC                       ;BX=10
        MOV BX, 10                      ;CX=0
        XOR CX, CX
    
        TEST AX, AX                     ; AX AND AX (only changes flags)
        JNZ DIVIDE_LOOP
    
        MOV DL, '0'                     ;30h
        MOV AH, 2                       ;Print to screen
        INT 21H
        JMP PRINT_DONE

DIVIDE_LOOP:
        XOR DX, DX                      ;DX=0
        DIV BX                          ;AX=AX/BX
        PUSH DX                         ;Save DX
        INC CX
        TEST AX, AX
        JNZ DIVIDE_LOOP
    
PRINT_DIGITS:
        CMP CX, 0                        ;If done,
        JZ PRINT_DONE                    ;Return
        POP DX                           ;Restore DX
        ADD DL, '0'

        PUSH DX
        PUSH AX
        MOV AH,DL                        ;Print to LCD
        CALL OUTL
        POP AX
        POP DX
        MOV AH, 2
        INT 21H
        DEC CX
        JMP PRINT_DIGITS

PRINT_DONE:
        RET
PRINT_NUMBER ENDP

		

;============Keypad Subroutines============
keypad:
        PUSH CX                  ;save registers
        PUSH AX
        PUSH DX
    
        MOV DX, CNTR79           ;move control address to DX
        MOV AL, 0                ;Check if Keypad ready
        OUT DX, AL
        MOV AL, 39H
        OUT DX, AL

   
    
LOOP_MAIN:  
        MOV DX, CNTR79
LOOP1:
              
        IN  AL, DX
        TEST AL, 7                ;Al AND 00000111 ,check if any key pressed
        JZ  LOOP1                 ;if not, keep looping until key press
        MOV DX, DATA79            
        IN  AL, DX                ;Input Keypad
        ADD AL, 30H               ;Add '0'
        MOV CX,0FH                ;Delay to prevent multiple input on single key press
        LOOP $
        POP DX
        MOV AH, 0                 ; CLEAR AH
        POP DX
        POP CX                    
        RET
;============LCD Subroutines============

IRWR:		
        CALL	BUSY              ;check if LCD is ready
		MOV	DX,IR_WR
		MOV	AL,AH
		OUT	DX,AL
		RET

OUTL:		
        CALL	BUSY              ;Print on LCD
		MOV	AL,AH
		MOV	DX,DR_WR
		OUT	DX,AL
		RET

BUSY:	MOV	DX,IR_RD
BUSY1:	IN	AL,DX
		AND	AL,80H
		JNZ	BUSY1
		RET 
;============Messages============
		   
    StudNo          DW  ?          ; Number of students
    StudNO_msg      DB  'Enter number of students: $'
    StudID_msg      DB  0dh, 0ah, 'Enter student IDs:$'
    StudGrade_msg   DB  0dh, 0ah,'Enter student grades:$'
    RESULT_MSG      DB  0dh, 0ah,'Students sorted by grades (descending):$'
    ID_MSG          DB  0dh, 0ah,'Student ID: $'
    GRADE_MSG       DB  ', Grade: $'
    NEWLINE         DB  0dh, 0ah, '$'
;============Constants============
    
    IR_WR		EQU	0FFC1H
    IR_RD		EQU	0FFC3H
    DR_WR		EQU	0FFC5H
    DATA79		EQU	0FFE8H
    CNTR79		EQU	0FFEAH
    

    STUDENT_IDS DW  100 DUP(?)      ; Array for student IDs (max 100)
    GRADES      DB  100 DUP(?)      ; Array for grades (max 100)
    		
CODE ENDS		
END START
