org 0000h
ljmp main

org 0030h
main:
	mov sp, #5fh
	mov dptr, #tab
	mov r0,#0feh
	MOV r3,#05H
	mov r1,#01h

loop:	
	ORL P1,01H
	MOV A,P1
      	LCALL delay
	JB ACC.0,KB0
	LJMP KB2

KB0: 	
	lcall WORK0
GB0:	
	ORL P1,01H
	MOV A,P1
      	LCALL delay
	JB ACC.0,GB0
	inc r1
	LJMP KB2

KB2: 
	
	LCALL WORK2
	inc r3

GB2:
	ORL P1,01H
	MOV A,P1
      	LCALL delay
	JB ACC.0,KB0
	LJMP GB2
	
	

WORK0:
	mov r2, #08h
	lcall show02
	ret

WORK2:
	mov r2, #08h
	lcall show01
	ret
	
show01:
	push acc
	mov a, #0feh
show1:
	mov p2, a
	nop
	nop
	push acc
	mov a, r1		
	movc a, @a+dptr
	mov p0, a 
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
	mov a, #7fh
show2:
	SETB P2.7
	SETB P2.6
	CLR P2.7
	CLR P2.6
	mov p2, a
	nop
	nop
	push acc
	mov a, r3		
	movc a, @a+dptr
	mov p0, a 
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
tab: db  40h,76h,79h,38h,38h,3fh,40h,40h,3FH,06H,5BH,4FH,66H,6DH,7DH,07H,7FH,6FH
	db 40h
	db 3FH,06H,5BH,4FH,66H,6DH,7DH,07H,7FH,6FH
end

