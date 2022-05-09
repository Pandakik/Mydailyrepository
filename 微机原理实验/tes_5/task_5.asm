org 0000h
ljmp main

org 0030h
main:
	mov sp, #5fh
	mov dptr, #tab
	mov r0,#0feh
	MOV R3,#07H
	mov R4,#00h

loop:	
	MOV A,P1
      	LCALL delay
	JNB ACC.0,KB2
	lJMP KB0	
	
KB0: 	
	lcall WORK0
GB0:
	
	MOV A,P1
	LCALL delay
	JNB ACC.0,KB2
	SJMP KB0

KB2: 
	INC R3
	LCALL WORK2

GB2:
	MOV A,P1
	LCALL delay
	JNB ACC.0,GB2
	INC R4
	LJMP KB0

WORK0:
	mov a,R4
	mov r1,a
	mov r2,#08h
	lcall show01
	ret

WORK2:
	
	lcall show02
	ret
	
show01:
	push acc
	clr p2.6
	clr p2.7
	mov a,#0feh

	
show1:
	mov p0,a
	setb p2.7
	nop
	clr p2.7
	

	nop
	nop
	push acc

	mov a, r1		
	movc a, @a+dptr
	
	MOV P0,A
	
	setb p2.6
	nop
	clr p2.6
	
	nop
	nop
	pop acc

	inc r1
	rl a 

	lcall delay
	djnz r2, show1
	pop acc
	ret	
show02:
	push acc
	clr p2.7
	clr p2.6
	mov a, #7fh
show2:
	mov p0, a	
	setb p2.7
	nop
	clr p2.7

	nop
	nop
	push acc
	mov a, r3		
	movc a, @a+dptr
	mov p0, a
        setb p2.6
	nop
	clr p2.6
	nop
	nop
	pop acc

	lcall delay
	pop acc
	ret	
delay:
	push 06h
	push 07h
	mov r6, #01h
delay1:
	mov r7, #00h
	djnz r7, $
	djnz r6, delay1
	pop 07h
	pop 06h
	ret

org 0200h
tab: db 06h,7fh,3fh,7dh,06h,4fh,4fh,66h,06H,5BH,4FH,66H,6DH,7DH,07H,7FH,6FH
	
end