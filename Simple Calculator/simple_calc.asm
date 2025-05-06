org 100h              ; COM file must start at offset 100h

jmp start             ; Jump to the start label (skip over data)

; ===== Messages =====
msg1: db "Wlecome to Simple Calculator !",0dh,0ah,"1)ADD (+)",0dh,0ah,"2)SUBTRACT(-)",0dh,0ah,"3)MULTIPLY (x)",0dh,0ah,"4)DIVIDE(/)",0dh,0ah,"$"
msg2: db 0dh,0ah,"Enter First Number : $"
msg3: db 0dh,0ah,"Enter Second Number : $" 
msg4: db 0dh,0ah,"Enter First Number : $"  
msg5: db 0dh,0ah,"RESULT = $"
msg6: db 0dh,0ah,"Exiting..... $" 
msg7: db 0dh,0ah,"Done!",0dh,0ah,"(1)Return to main menu",0dh,0ah,"(2)Exit",0dh,0ah,"$" 
msgWarn: db 0dh,0ah,"Invalid input,try again! $"

; ===== Main Menu =====
start:
            mov ah,9                ; Function to print string
            mov dx, offset msg1     ; Load welcome menu text
            int 21h                 ; DOS interrupt to show string

; ===== Get User Choice =====
Input:
            mov ah,0                ; Wait for key press
            int 16h
            cmp al,31h              ; '1'
            je Addition
            cmp al,32h              ; '2'
            je Subtract
            cmp al,33h              ; '3'
            je Multiply
            cmp al,34h              ; '4'
            je Divide
        
            ; If input is invalid
            mov ah,9
            mov dx, offset msgWarn
            int 21h
            mov ah,0
            int 16h                 ; Wait for another key
            jmp Input               ; Try again

; ===== Addition =====
Addition:
            mov ah,9
            mov dx, offset msg2     ; Ask for first number
            int 21h
            mov cx,0
            call InputNo            ; Get first number
            push dx                 ; Save it
        
            mov ah,9
            mov dx, offset msg3     ; Ask for second number
            int 21h
            mov cx,0
            call InputNo            ; Get second number
        
            pop bx                  ; Load first number into BX
            add dx,bx               ; Add both numbers
            push dx                 ; Save result
        
            mov ah,9
            mov dx, offset msg5     ; Print "RESULT ="
            int 21h
            pop dx
            mov cx,10000            ; Used in View for printing digits
            call View
            jmp Retry
; ===== Retry =====            
Retry:      
            mov ah,9
            mov dx, offset msg7     
            int 21h
            mov ah,0
            int 16h
            cmp al,31h
            je start
            cmp al,32h
            je Exit
            mov ah,9
            mov dx, offset msgWarn 
            int 21h
            jmp Retry
                       

; ===== Exit Message =====
Exit:
            mov ah,9
            mov dx, offset msg6     ; Show exit prompt
            int 21h
            mov ah,4Ch
            int 21h


; ===== View: Print number stored in DX =====
View:
            mov ax,dx
            mov dx,0
            div cx                  ; Divide to get highest digit
            call ViewNo             ; Print digit
            mov bx,dx               ; Store remainder
            mov dx,0
            mov ax,cx
            mov cx,10
            div cx                  ; Get next lower place (divide by 10)
            mov dx,bx               ; Restore remainder for next round
            mov cx,ax               ; Update CX with next place
            cmp ax,0
            jne View                ; Repeat if more digits left
            ret

; ===== InputNo: Read number input from user =====
InputNo:
            mov ah,0
            int 16h                 ; Wait for key
            mov dx,0
            mov bx,1                ; Initial multiplier (1s place)
            cmp al,0dh              ; Enter key?
            je FormNo               ; If yes, go build full number
            sub ax,30h              ; Convert ASCII to number
            call ViewNo             ; Show the digit
            mov ah,0
            push ax                 ; Store digit on stack
            inc cx                  ; Increase digit count
            jmp InputNo

; ===== ViewNo: Print single digit in AX =====
ViewNo:
            push ax
            push dx
            mov dx,ax
            add dl,30h             ; Convert to ASCII
            mov ah,2
            int 21h                ; Print single character
            pop dx
            pop ax
            ret

            



; ===== Subtraction =====
Subtract:
            mov ah,9
            mov dx, offset msg2
            int 21h
            mov cx,0
            call InputNo
            push dx
        
            mov ah,9
            mov dx, offset msg3
            int 21h
            mov cx,0
            call InputNo
        
            pop bx
            sub bx,dx              ; First - Second
            mov dx,bx
            push dx
        
            mov ah,9
            mov dx, offset msg5
            int 21h
            pop dx
            mov cx,10000
            call View
            jmp Retry

; ===== Multiplication =====
Multiply:
            mov ah,9
            mov dx, offset msg2
            int 21h
            mov cx,0
            call InputNo
            push dx
        
            mov ah,9
            mov dx, offset msg3
            int 21h
            mov cx,0
            call InputNo
        
            pop bx
            mov ax,dx
            mul bx
            mov dx,ax
            push dx
        
            mov ah,9
            mov dx, offset msg5
            int 21h
            pop dx
            mov cx,10000
            call View
            jmp Retry

; ===== Division =====
Divide:
            mov ah,9
            mov dx, offset msg2
            int 21h
            mov cx,0
            call InputNo
            push dx
        
            mov ah,9
            mov dx, offset msg3
            int 21h
            mov cx,0
            call InputNo
        
            pop bx
            mov ax,bx
            mov cx,dx
            mov dx,0
            div cx                ; Only prints quotient (no remainder)
            mov dx,ax
            push dx
        
            mov ah,9
            mov dx, offset msg5
            int 21h
            pop dx
            mov cx,10000
            call View
            jmp Retry   
            ; ===== FormNo: Build full number from digits =====
FormNo:
            pop ax
            push dx
            mul bx                 ; Multiply digit by its place value
            pop dx
            add dx,ax              ; Add to final result
            mov ax,bx
            mov bx,10              ; Increase place value (1 -> 10 -> 100...)
            push dx
            mul bx
            pop dx
            mov bx,ax              ; Store updated place value
            dec cx
            cmp cx,0
            jne FormNo             ; Repeat if more digits

ret
