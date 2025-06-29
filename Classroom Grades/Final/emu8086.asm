org 00h


jmp Start    
     
;=========Constants============= 

MaxStud     equ 20
StudID      equ 40
NoStud      db  ?
StudIDs:    dw  StudID  dup(?)
Grades:     db  MaxStud  dup(?)            

;=========Input Buffers=========                           ;This Code uses DOS Buffered Input Method so we provide needed Buffers:

bufCount:
              db 3      ; max digits to be input + 1 (Enter)
              db ?      ; DOS fills with actual digit count
              db 3 dup(?) ; storage for the Inputs

bufID:    
              db 5     ; max 4 digits for ID (+1 Enter)
              db ?      ; actual count
              db 5 dup(?) ; storage    
bufGrade:
              db 2        ;1+1
              db ?
              db 2 dup(?)   
              
;=========Input Messages=========     

InCount:     db 0dh,0ah,"Enter Number of students (1-20): $"
InID:        db 0dh,0ah,"Enter 4-digit ID: $"
InGrade:     db 0dh,0ah,"Enter grade (A/B/C/D/F): $"

InvalidMsg:  db 0dh,0ah,"Invalid,Try again$" 

;=========Table Messages=========

tableL1:      db 0dh,0ah,"--------------------------"
              db 0dh,0ah,"|ID:           |Grade:   |" 
              db 0dh,0ah,"--------------------------$"   
              
tableL2:      db               "          |$"        
tableL3:      db               "        |$"     
tableL4:      db "--------------------------$"


;=========Main Program==========   

Start:  
            mov dx,offset InCount   ;Print Input Msg
            call PrintMsg  
     
Input_No:                           
            lea dx,bufCount         ;point to buffer
            mov ah,0Ah              ;DOS Buffered Input Interrupt ,input is stored in the buffer not in al so we must store from buffer to storage
            int 21h   
              
            call FormNo             ;convert from ascii to decimal and form number (keyboard inputs ascii e.g 1=31h)
            mov [NoStud], al        ;store Std.No.
            cmp [NoStud],1          ;Check for invalid input
            jbe  Invalid_No
            cmp [NoStud],20
            ja  Invalid_No 
            xor ch, ch              ;clear the high byte of CX
            mov cl,al               ;set counter to Std.No.
            xor si,si 
            xor di,di  
            call ID_loop            ;ID Input Loop
            call SortStudents       ;bubble Sort
              
            call Output_Grades      ;Output Result
            mov ah,4Ch              ;Terminate the program
            int 21h 
;=========Input Loop============                 
ID_Loop:
        
            mov dx,offset InID
            call PrintMsg            ;print ID Input Msg
            lea dx,bufID             ;Both point to ID Buffer
            lea bx,bufID
            mov ah,0Ah               ;Input ,ID is stored as ascii in double word (e.g i/p =1234 , buffer stores (05h,05h,31h,32h,33h,34h,0Dh(enter))
            int 21h  
            mov ax,[bx+2]            ;point to Storage area of buffer,skip first 2 bytes
            mov [StudIDs+si],ax      ;store in our array
            add si,2                 ;move to next
                     
            mov ax,[bx+4]            ;again with lower word
            mov [StudIDs+si],ax
            add si,2   
Grade_Loop: 
         
        
            mov dx,offset InGrade
            call PrintMsg   
           
            lea dx,bufGrade           ;Both point to Grade Buffer
            lea bx,bufGrade
            mov ah,0Ah
            int 21h 
            mov ax,[bx+2] 
            cmp al,'A'                ;Check for Invalid i/p
            jb  Invalid_Id
            cmp al,'F'
            ja  Invalid_Id
              
            
            mov [Grades+di],ax 
            inc di
            
            loop ID_Loop  
            ret
;=======Subroutines============= 
        
PrintMsg:
            mov ah,9           ;subroutines for printing msgs and symbols
            int 21h
            ret
PrintStr: 
            mov ah,02h
            int 21h
            ret
             
FormNo:
            push dx            ; save original DX (the buffer pointer)
            mov  si, dx        ; SI ? buffer
            mov  cl, [si+1]    ; CL = count of chars
            xor  dx, dx        ; DX = 0 (we’ll accumulate digit here)
            lea  di, [si+2]    ; DI ? first digit character  
            xor  ax, ax        ; AX = 0 (running total)
            mov  bx, 10

FN_Loop:
            mov  dl, [di]      ; DL = ascii digit
            sub  dl, '0'       ; DL = numeric digit
            mov  dh, 0         ; clear high byte of DX
            push dx            ; save digit in DX
            mul  bx            ; AX = AX * 10, DX = high word (discard)
            pop  dx            ; restore digit into DX
            add  ax, dx        ; AX += digit
        
            inc  di
            dec  cl
            jnz  FN_Loop
        
            pop  dx            ; restore original DX
            ret
;=========bubble Sort==========             
SortStudents:
            mov cl,[NoStud]      
            dec cl
Outer:
            xor si,si
            mov ch,cl
Inner:
            mov al,[Grades+si]
            mov ah,[Grades+si+1]      
            cmp al,ah
            jbe NoSwap
            
            mov [Grades+si],ah
            mov [Grades+si+1],al     
            
            
            mov bx ,si
            shl bx,2
            mov dx, [StudIDs + bx]              
            mov ax, [StudIDs + bx + 4]
            mov [StudIDs + bx], ax
            mov [StudIDs + bx + 4], dx  
            mov dx, [StudIDs + bx+2]
            mov ax, [StudIDs + bx + 6]  
            mov [StudIDs + bx+2], ax
            mov [StudIDs + bx + 6], dx

NoSwap:
            inc si
            dec ch
            jnz Inner                
            
            dec cl
            jnz Outer
            ret      
Invalid_No:    
            mov dx,offset InvalidMsg
            call PrintMsg
            jmp  Input_No
Invalid_id:    
            mov dx,offset InvalidMsg
            call PrintMsg
            jmp  Grade_Loop 


Output_Grades: 
            mov dx,offset tableL1
            call PrintMsg           
            mov cl, [NoStud]
            xor si, si      ; byte-index into StudIDs
            xor di, di      ; byte-index into Grades   
            xor dh,dh
            mov dl,0Dh
            call PrintStr
            mov dl,0Ah
            call PrintStr   
            
Next_Out:
            mov bx,4
            mov dl,'|'
            call PrintStr
Id_Out:      

 
            mov dx,[StudIDs+si]
            call PrintStr
            inc si 
            
            dec bx
            jnz Id_out    
            
            mov dx,offset tableL2
            call PrintMsg   
            
            mov dl,[Grades+di]
            call PrintStr 
            
            mov dx,offset tableL3
            call PrintMsg
            
            mov dl,0Dh
            call PrintStr
            mov dl,0Ah
            call PrintStr
            
            
            inc di
            dec cl
            jnz Next_Out

            mov dx,offset tableL4
            call PrintMsg  
                        
            ret
    

ret




