ORG	0000H
SJMP	MAIN
ORG	0030H

MAIN:
	MOV	SP,#5FH
	MOV	P2,#00H
	MOV	SCON,#0F0H
	MOV	TMOD,#20H
	MOV	TH1,#0FDH
	MOV	TL1,#0FDH
	SETB	TR1
	MOV	R1,#00H
;---------------------------------------------
START:
	JNB	RI,$
	MOV	A,SBUF
	CLR	RI
	CJNE	A,#00H,START
	LCALL	ADC
	MOV	A,R1
	SETB	TB8
	MOV	SBUF,A
	JNB	TI,$
	CLR	TI
	SJMP	START

ADC:	
	CPL	P1.0
	SETB	P2.3
	NOP
	CLR	P2.3
	JNB	P3.2,$
	SETB	P2.4
	NOP
	;MOV	P0,#0FFH
	MOV	R1,P0
;	CLR	P2.4
	RET
;----------------------------------------
DELAY:
	PUSH	00H
	PUSH	01H
	MOV	R0,#01H
DELAY1:
	MOV	R1,#00H
	DJNZ	R1,$
	DJNZ	R0,DELAY1
	POP	01H
	POP	00H
	RET
END