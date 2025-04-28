org 100h              ; COM file must start at offset 100h

jmp start             ; Jump to the start label (skip over data)

; ===== Messages =====
msg1: db 0dh,0ah,"Welcome to simple even or odd checker! $"
msg2: db 0dh,0ah,"Enter Number: $"
msg3: db 0dh,0ah,"Number is Even! $"
msg4: db 0dh,0ah,"Number is Odd! $"
msgWarn: db 0dh,0ah,"Invalid input, try again! $"
msg5: db 0dh,0ah,"Done!",0dh,0ah,"(1) Try Again",0dh,0ah,"(2) Exit",0dh,0ah,"$"
msg6: db 0dh,0ah,"Exiting.... $"

; ===== Start of Program =====
start:
    mov ah,9               
    mov dx, offset msg1     ; Load welcome message
    int 21h                 
    jmp Input               ; Jump to input routine

; ===== Input =====
Input:
    mov ah,9                
    mov dx,offset msg2      ; Load prompt message to enter number
    int 21h                 
    mov cx,0                
    call InputNo            ; Get the number input from the user

; ===== InputNo =====
InputNo:
    mov ah,0                
    int 16h                 ; Read a character from the keyboard
    mov dx,0                
    mov bx,1                ; Set multiplier to 1 for the first digit place (ones)

    cmp al,0dh              ; Check if Enter key (carriage return) is pressed
    je FormNo               ; Jump to FormNo if Enter is pressed (end of input)
    
    cmp al, '0'             ; Check if the input is a valid digit (between '0' and '9')
    jb InvalidInput         ; Jump to InvalidInput if it's less than '0'
    cmp al, '9'
    ja InvalidInput         ; Jump to InvalidInput if it's greater than '9'

    sub ax,30h              ; Convert ASCII value to numerical value (0-9)
    call ViewNo             ; Display the number
    push ax                 ; Push the digit onto the stack
    inc cx                  ; Increment the digit count
    jmp InputNo             ; Repeat for the next digit

; ===== InvalidInput =====
InvalidInput:
    mov ah,9                
    mov dx,offset msgWarn   
    int 21h                 ; Print  warning  message
    jmp InputNo             ; Go back to input

; ===== FormNo =====
FormNo:
    pop ax                  ; Pop the last entered digit
    push dx                 
    mul bx                  ; Multiply digit by place value
    pop dx                  
    add dx,ax               ; Add the result to the final number
    mov ax,bx               
    mov bx,10               ; Prepare for next place value (ones -> tens -> hundreds)
    push dx                 
    mul bx                  ; Multiply by 10 for the next place
    pop dx                  
    mov bx,ax               ; Update BX with the new place value
    dec cx                  ; Decrease digit counter
    cmp cx,0                ; Check if all digits have been processed
    jne FormNo              ; If not, repeat the process    
 


; ===== EvenOrOdd =====
EvenOrOdd:
    and dx,1                ; Check the least significant bit (LSB)
    jne ODD                 ; If result is not zero, jump to ODD
    jmp EVEN                ; Jump to EVEN if number is even

; ===== EVEN =====
EVEN:
    mov ah,9                
    mov dx,offset msg3      ; Print the "Even" message
    int 21h                 
    jmp Retry               ; Jump to retry routine

; ===== ODD =====
ODD:
    mov ah,9                
    mov dx,offset msg4      ; Print the "Odd" message
    int 21h                 
    jmp Retry               ; Jump to retry routine

; ===== Retry =====
Retry:
    mov ah,9                
    mov dx,offset msg5      ; Print the retry message
    int 21h                 
    mov ah,0                
    int 16h                 ; Read user input (key press)
    cmp al,31h              ; Check if '1' is pressed (try again)
    je start                ; Jump to start if '1' is pressed
    cmp al,32h              ; Check if '2' is pressed (exit)
    je EXIT                 ; Jump to exit if '2' is pressed
    mov ah,9                ; Invalid input handling
    mov dx,offset msgWarn   ; Print the warning message
    int 21h               
    jmp Retry               ; Repeat the retry process

; ===== EXIT =====
EXIT:
    mov ah,9                
    mov dx,offset msg6      ; Print the exit message
    int 21h                 
    mov ah,4Ch              ; Terminate the program
    int 21h


; ===== ViewNo =====
ViewNo:
    push ax
    push dx
    mov dx,ax               
    add dl,30h              ; Convert number to ASCII (e.g., 0 -> '0')
    mov ah,2                
    int 21h                 ; Print the digit
    pop dx
    pop ax
    ret                     ; Return to the caller