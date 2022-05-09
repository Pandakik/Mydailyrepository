org 0000h
sjmp main

ORG 0023H
LJMP SERIALISR
main:
	mov sp,#5fh
	mov scon,#0C0h
	mov tmod,#20h
	mov th1,#0fdh
	mov tl1, #0fdh
	setb tr1
SETB ES
SETB EA

	mov a,#2fh
       	
loop:
	inc a
	mov c,p
	mov TB8,c
	mov sbuf,a
	JNB TI,$
	lcall DELAY
	CJNE a,#39h,loop
        MOV A,2FH
	SJMP loop

SERIALISR:
	JNB TI,S1
	CLR TI
	SJMP S2
S1:

CLR RI

S2:RETI
	CLR TI

	RETI

DELAY:
MOV	R3,P2
LOOP1:	NOP
	DJNZ	R3,LOOP1
	RET
	
END	
