
; You may customize this and other start-up templates; 
; The location of this template is c:\emu8086\inc\0_com_template.txt

org 100h


jmp Start         


MaxStud     equ 20
StudID      equ 40
NoStud      db  ?
StudIDs:    dw  StudID  dup(?)
Grades:     db  MaxStud  dup(?)            

; input buffers
bufCount:
              db 3      ; max chars for count (e.g. 20)
              db ?      ; DOS fills with actual count
              db 3 dup(?) ; storage

bufID:    
              db 5     ; max 4 digits for ID
              db ?      ; actual count
              db 5 dup(?) ; storage    
bufGrade:
              db 2
              db ?
              db 2 dup(?)
      

msgCount:     db 0dh,0ah,"Enter Number of students (1-20): $"
msgID:        db 0dh,0ah,"Enter 4-digit ID: $"
msgGrade:     db 0dh,0ah,"Enter grade (A/B/C/D/F): $"   



Start:  
            mov dx,offset msgCount
            call PrintMsg  
     
            lea dx,bufCount
            mov ah,0Ah
            int 21h   
              
            call FormNo 
            mov [NoStud], al  ; store your 8-bit count
            xor ch, ch        ; clear the high byte of CX
            mov cl,al
            xor si,si 
            xor di,di  
            call ID_loop   
            call SortStudents
              
            call Output_Grades
            mov ah,4Ch              ; Terminate the program
            int 21h 
                
ID_Loop:
        
            mov dx,offset msgID
            call PrintMsg   
            lea dx,bufID
            lea bx,bufID
            mov ah,0Ah
            int 21h  
            mov ax,[bx+2]
            mov [StudIDs+si],ax
            add si,2   
                     
            mov ax,[bx+4]
            mov [StudIDs+si],ax
            add si,2   
Grade_Loop: 
         
        
            mov dx,offset msgGrade
            call PrintMsg   
           
            lea dx,bufGrade
            lea bx,bufGrade
            mov ah,0Ah
            int 21h    
            mov ax,[bx+2] 
            mov [Grades+di],ax 
            inc di
            
            loop ID_Loop  
            ret
;=======Subroutines==========    
        
PrintMsg:
            mov ah,9
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

Output_Grades:
            mov cl, [NoStud]
            xor si, si      ; byte-index into StudIDs
            xor di, di      ; byte-index into Grades   
            mov dl,0Dh
            call PrintStr
            mov dl,0Ah
            call PrintStr   
            
Next_Out:
            mov bx,4
Id_Out:       
            mov dx,[StudIDs+si]
            call PrintStr
            inc si 
            
            dec bx
            jnz Id_out 
            
            mov dl,' '
            call PrintStr  
            
            mov dl,[Grades+di]
            call PrintStr
            
            mov dl,0Dh
            call PrintStr
            mov dl,0Ah
            call PrintStr
            
            
            inc di
            dec cl
            jnz Next_Out
            ret
    

ret




