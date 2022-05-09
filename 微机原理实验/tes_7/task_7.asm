ORG 0000H
LJMP MAIN
ORG 0030H
LJMP INTRP0
ORG 0100H

MAIN: 
SETB EA
SETB EX0
SETB IT0 

loop:
MOV A,#00H 
JNB P1.0 ,F
JNB P1.1 ,J
JNB P1.2 ,S
JNB P1.3 ,Z
SJMP LOOP

F:
	CLR P1.4  ;����
L1:  
	CLR p2.0
	MOV P0,#0FFH
	SETB p2.0
     	LCALL DELAY
	CLR p2.0
     	MOV P0,#00H
     	SETB p2.0
     	LCALL DELAY
     	SETB P1.4
SJMP loop

J:
	CLR P1.5
LOOP2: 		;��ݲ�
	INC A
	CLR p2.0
	MOV P0,A
	SETB p2.0
	lcall delay
	CJNE A,#0FFH,LOOP2
	SETB P1.5
	sjmp loop

S:
LOOP3:
	CLR P1.6;���ǲ�
	INC A
	CLR p2.0
	MOV P0,A
	SETB p2.0
	lcall delay
	CJNE A,#0FFH,LOOP3
LOOP4:
	DEC A
	CLR p2.0
	MOV P0,A
	SETB p2.0
	lcall delay
	CJNE A,#00H,LOOP4
	SETB P1.6
sjmp loop


Z:	CLR P1.7   ;���Ҳ�
	MOV R2,#0
	MOV DPTR,#TABLE1
LOOP5:  MOV A,R2
	MOVC A,@A+DPTR
	CLR p2.0
	MOV P0,A
	SETB p2.0
	LCALL DELAY
	INC R2
	CJNE R2,#29,LOOP5
	SETB P1.7

SJMP LOOP

DELAY:
MOV	R3,P2
LOOP1:	NOP
	DJNZ	R3,LOOP1
	RET

ORG 1000H
INTRP0:
mov R0,#0FFH
RETI

TABLE1:
DB 1,3,5,10,20,35,55,75,90,100,105,107,109,110,109,107,105,100,90,75,55,35,20,10,5,3,1,0  

END
