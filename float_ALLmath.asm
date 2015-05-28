;  ############## ALLmath floating point lib ################
;  ############## IEEE 754 single precision #################
;
;  The library is provided as-is, no guarantees or/and warrantees of any kind
;  are given, no liability of any kind is provided for any and all direct, 
;  indirect or consequent damages or losses caused by using this software
;  library.
;
;  This program is free software; you can redistribute it and/or
;  modify it under the terms of the GNU General Public License
;  as published by the Free Software Foundation; using version 3
;  of the License.
;  
;  IgorM (copyright) 2010-2015;
;  v 1.0. 16-9-2010
;  v 1.1. 10-10-2011
;  v 1.2. 12-6-2012
;  v 1.3. 15-5-2015
;
; Note:
; Please add following float stack into the template.asm , 50bytes required:
; 
; addresses of various data segments
; .set rstackstart = RAMEND      ; start address of return stack, grows downward
; .set FLIBSTACK = RAMEND - 80    ; FLOATLIB space
; .set stackstart  = RAMEND - 130 ; start address of data stack, grows downward
;
; How to install the library:
; 1. put this file into amforth's ..\core\words library
; 2. do .include "words/float_ALLmath" into your dict_appl.inc
; 3. do compile amforth
; 4. do flash it
; 5. do load the Leon's float.lib
;			!! DO NOT forget to remove or comment-out the 
;			f/ f* f+ f- words from the Leon's lib !!
; 6. enjoy the speed!
;
; &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&

; &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
VE_FDIV:
    .dw $ff02 
    .db "f/"
    .dw VE_HEAD
    .set VE_HEAD = VE_FDIV
XT_FDIV:
    .dw PFA_FDIV
PFA_FDIV:
; save registers
	push R0
	push R1
	push R22
	push R23
	push R26
	push R27
	; R28 do not use, = Y
	; R29 do not use, = Y
;######################################################	
;main body
; Floating point B = A / B	
; IEEE 754
;     High        Low
; A = R25 R24 R27 R26  IN
; B = R23 R22 R31 R30  IN / OUT

	; fetch B 
	mov R22, tosl
	mov R23, tosh	
	ld R30, Y+
	ld R31, Y+
	; fetch A	
	ld R24, Y+
	ld R25, Y+
	ld R26, Y+
	ld R27, Y+
	
	; ############
	; ### BLD R14, 7
	push R28
	push R29
	
	CALL __DIVF21
	
	pop R29
	pop R28
	; ### BST R14, 7
	; ############
	
	; store B
	st -Y , R31
	st -Y , R30
	mov tosh, R23
	mov tosl, R22

	pop R27	
	pop R26
	pop R23
	pop R22
	pop R1
	pop R0
   jmp_ DO_NEXT		; this is the end of the word
; &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&


; &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
VE_FMUL:
    .dw $ff02 
    .db "f*"
    .dw VE_HEAD
    .set VE_HEAD = VE_FMUL
XT_FMUL:
    .dw PFA_FMUL
PFA_FMUL:
; save registers
	push R0
	push R1
	push R22
	push R23
	push R26
	push R27
	; R28 do not use, = Y
	; R29 do not use, = Y
;######################################################	
;main body
; Floating point B = A * B	
; IEEE 754
;     High        Low
; A = R25 R24 R27 R26  IN
; B = R23 R22 R31 R30  IN / OUT

	; fetch B 
	mov R22, tosl
	mov R23, tosh	
	ld R30, Y+
	ld R31, Y+
	; fetch A	
	ld R24, Y+
	ld R25, Y+
	ld R26, Y+
	ld R27, Y+
	
	; ############
	; ### BLD R14, 7
	push R28
	push R29

	CALL __MULF12
	
	pop R29
	pop R28
	; ### BST R14, 7
	; ############
	
	; store B
	st -Y , R31
	st -Y , R30
	mov tosh, R23
	mov tosl, R22

	pop R27	
	pop R26
	pop R23
	pop R22
	pop R1
	pop R0
   jmp_ DO_NEXT		; this is the end of the word
; &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&

; &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
VE_FADD:
    .dw $ff02 
    .db "f+"
    .dw VE_HEAD
    .set VE_HEAD = VE_FADD
XT_FADD:
    .dw PFA_FADD
PFA_FADD:
; save registers
	push R0
	push R1
	push R22
	push R23
	push R26
	push R27
	; R28 do not use, = Y
	; R29 do not use, = Y
;######################################################	
;main body
; Floating point B = A + B	
; IEEE 754
;     High        Low
; A = R25 R24 R27 R26  IN
; B = R23 R22 R31 R30  IN / OUT

	; fetch B 
	mov R22, tosl
	mov R23, tosh	
	ld R30, Y+
	ld R31, Y+
	; fetch A	
	ld R24, Y+
	ld R25, Y+
	ld R26, Y+
	ld R27, Y+
	
	; ############
	; ### BLD R14, 7
	push R28
	push R29

	CALL __ADDF12
	
	pop R29
	pop R28
	; ### BST R14, 7
	; ############
	
	; store B
	st -Y , R31
	st -Y , R30
	mov tosh, R23
	mov tosl, R22

	pop R27	
	pop R26
	pop R23
	pop R22
	pop R1
	pop R0
   jmp_ DO_NEXT		; this is the end of the word
; &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&

; &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
VE_FSUB:
    .dw $ff02 
    .db "f-"
    .dw VE_HEAD
    .set VE_HEAD = VE_FSUB
XT_FSUB:
    .dw PFA_FSUB
PFA_FSUB:
; save registers
	push R0
	push R1
	push R22
	push R23
	push R26
	push R27
	; R28 do not use, = Y
	; R29 do not use, = Y
;######################################################	
;main body
; Floating point B = A - B	
; IEEE 754
;     High        Low
; A = R25 R24 R27 R26  IN
; B = R23 R22 R31 R30  IN / OUT

	; fetch A	
	mov R24, tosl
	mov R25, tosh
	ld R26, Y+
	ld R27, Y+	
	
	; fetch B 
	ld R22, Y+
	ld R23, Y+	
	ld R30, Y+
	ld R31, Y+
	
	; ############
	; ### BLD R14, 7
	push R28
	push R29
	
	CALL __SUBF12
	
	pop R29
	pop R28
	; ### BST R14, 7
	; ############
	
	; store B
	st -Y , R31
	st -Y , R30
	mov tosh, R23
	mov tosl, R22

	pop R27	
	pop R26
	pop R23
	pop R22
	pop R1
	pop R0
   jmp_ DO_NEXT		; this is the end of the word
; &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&

; &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
VE_FSIN:
    .dw $ff04 
    .db "fsin"
    .dw VE_HEAD
    .set VE_HEAD = VE_FSIN
XT_FSIN:
    .dw PFA_FSIN
PFA_FSIN:
; save registers
	push R0
	push R1
	push R22
	push R23
	push R26
	push R27
	; R28 do not use, = Y
	; R29 do not use, = Y
;######################################################	
;main body
; Floating point B = sin (A)	
; IEEE 754
;     High        Low
; A = R25 R24 R27 R26  IN
; B = R23 R22 R31 R30  IN / OUT

	; fetch A	
	mov R24, tosl
	mov R25, tosh
	ld R26, Y+
	ld R27, Y+	
	
	; ############
	; ### BLD R14, 7
	push R28
	push R29
	;FLIB DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW (FLIBSTACK-8)
	LDI  R29,HIGH (FLIBSTACK-8)
	ST   Y,R26    	; one param: b=sin (a) via stack 
	STD  Y+1,R27
	STD  Y+2,R24
	STD  Y+3,R25

	CALL _sin
	
	pop R29
	pop R28
	; ### BST R14, 7
	; ############
	
	; store B
	st -Y , R31
	st -Y , R30
	mov tosh, R23
	mov tosl, R22

	pop R27	
	pop R26
	pop R23
	pop R22
	pop R1
	pop R0
   jmp_ DO_NEXT		; this is the end of the word
; &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&

; &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
VE_FCOS:
    .dw $ff04 
    .db "fcos"
    .dw VE_HEAD
    .set VE_HEAD = VE_FCOS
XT_FCOS:
    .dw PFA_FCOS
PFA_FCOS:
; save registers
	push R0
	push R1
	push R22
	push R23
	push R26
	push R27
	; R28 do not use, = Y
	; R29 do not use, = Y
;######################################################	
;main body
; Floating point B = cos (A)	
; IEEE 754
;     High        Low
; A = R25 R24 R27 R26  IN
; B = R23 R22 R31 R30  IN / OUT

	; fetch A	
	mov R24, tosl
	mov R25, tosh
	ld R26, Y+
	ld R27, Y+	
	
	; ############
	; ### BLD R14, 7
	push R28
	push R29
	;FLIB DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW (FLIBSTACK-8)
	LDI  R29,HIGH (FLIBSTACK-8)
	ST   Y,R26    	; one param: b=sin (a) via stack 
	STD  Y+1,R27
	STD  Y+2,R24
	STD  Y+3,R25

	CALL _cos
	
	pop R29
	pop R28
	; ### BST R14, 7
	; ############
	
	; store B
	st -Y , R31
	st -Y , R30
	mov tosh, R23
	mov tosl, R22

	pop R27	
	pop R26
	pop R23
	pop R22
	pop R1
	pop R0
   jmp_ DO_NEXT		; this is the end of the word
; &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&

; &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
VE_FTAN:
    .dw $ff04 
    .db "ftan"
    .dw VE_HEAD
    .set VE_HEAD = VE_FTAN
XT_FTAN:
    .dw PFA_FTAN
PFA_FTAN:
; save registers
	push R0
	push R1
	push R22
	push R23
	push R26
	push R27
	; R28 do not use, = Y
	; R29 do not use, = Y
;######################################################	
;main body
; Floating point B = tan (A)	
; IEEE 754
;     High        Low
; A = R25 R24 R27 R26  IN
; B = R23 R22 R31 R30  IN / OUT

	; fetch A	
	mov R24, tosl
	mov R25, tosh
	ld R26, Y+
	ld R27, Y+	
	
	; ############
	; ### BLD R14, 7
	push R28
	push R29
	;FLIB DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW (FLIBSTACK-8)
	LDI  R29,HIGH (FLIBSTACK-8)
	ST   Y,R26    	; one param: b=sin (a) via stack 
	STD  Y+1,R27
	STD  Y+2,R24
	STD  Y+3,R25

	CALL _tan
	
	pop R29
	pop R28
	; ### BST R14, 7
	; ############
	
	; store B
	st -Y , R31
	st -Y , R30
	mov tosh, R23
	mov tosl, R22

	pop R27	
	pop R26
	pop R23
	pop R22
	pop R1
	pop R0
   jmp_ DO_NEXT		; this is the end of the word
; &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&


; &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
VE_FASIN:
    .dw $ff05 
    .db "fasin",0
    .dw VE_HEAD
    .set VE_HEAD = VE_FASIN
XT_FASIN:
    .dw PFA_FASIN
PFA_FASIN:
; save registers
	push R0
	push R1
	push R22
	push R23
	push R26
	push R27
	; R28 do not use, = Y
	; R29 do not use, = Y
;######################################################	
;main body
; Floating point B = asin (A)	
; IEEE 754
;     High        Low
; A = R25 R24 R27 R26  IN
; B = R23 R22 R31 R30  IN / OUT

	; fetch A	
	mov R24, tosl
	mov R25, tosh
	ld R26, Y+
	ld R27, Y+	
	
	; ############
	; ### BLD R14, 7
	push R28
	push R29
	;FLIB DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW (FLIBSTACK-8)
	LDI  R29,HIGH (FLIBSTACK-8)
	ST   Y,R26    	; one param: b=sin (a) via stack 
	STD  Y+1,R27
	STD  Y+2,R24
	STD  Y+3,R25

	CALL _asin
	
	pop R29
	pop R28
	; ### BST R14, 7
	; ############
	
	; store B
	st -Y , R31
	st -Y , R30
	mov tosh, R23
	mov tosl, R22

	pop R27	
	pop R26
	pop R23
	pop R22
	pop R1
	pop R0
   jmp_ DO_NEXT		; this is the end of the word
; &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&

; &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
VE_FACOS:
    .dw $ff05 
    .db "facos",0
    .dw VE_HEAD
    .set VE_HEAD = VE_FACOS
XT_FACOS:
    .dw PFA_FACOS
PFA_FACOS:
; save registers
	push R0
	push R1
	push R22
	push R23
	push R26
	push R27
	; R28 do not use, = Y
	; R29 do not use, = Y
;######################################################	
;main body
; Floating point B = acos (A)	
; IEEE 754
;     High        Low
; A = R25 R24 R27 R26  IN
; B = R23 R22 R31 R30  IN / OUT

	; fetch A	
	mov R24, tosl
	mov R25, tosh
	ld R26, Y+
	ld R27, Y+	
	
	; ############
	; ### BLD R14, 7
	push R28
	push R29
	;FLIB DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW (FLIBSTACK-8)
	LDI  R29,HIGH (FLIBSTACK-8)
	ST   Y,R26    	; one param: b=sin (a) via stack 
	STD  Y+1,R27
	STD  Y+2,R24
	STD  Y+3,R25

	CALL _acos
	
	pop R29
	pop R28
	; ### BST R14, 7
	; ############
	
	; store B
	st -Y , R31
	st -Y , R30
	mov tosh, R23
	mov tosl, R22

	pop R27	
	pop R26
	pop R23
	pop R22
	pop R1
	pop R0
   jmp_ DO_NEXT		; this is the end of the word
; &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&

; &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
VE_FATAN:
    .dw $ff05 
    .db "fatan",0
    .dw VE_HEAD
    .set VE_HEAD = VE_FATAN
XT_FATAN:
    .dw PFA_FATAN
PFA_FATAN:
; save registers
	push R0
	push R1
	push R22
	push R23
	push R26
	push R27
	; R28 do not use, = Y
	; R29 do not use, = Y
;######################################################	
;main body
; Floating point B = atan (A)	
; IEEE 754
;     High        Low
; A = R25 R24 R27 R26  IN
; B = R23 R22 R31 R30  IN / OUT

	; fetch A	
	mov R24, tosl
	mov R25, tosh
	ld R26, Y+
	ld R27, Y+	
	
	; ############
	; ### BLD R14, 7
	push R28
	push R29
	;FLIB DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW (FLIBSTACK-8)
	LDI  R29,HIGH (FLIBSTACK-8)
	ST   Y,R26    	; one param: b=sin (a) via stack 
	STD  Y+1,R27
	STD  Y+2,R24
	STD  Y+3,R25

	CALL _atan
	
	pop R29
	pop R28
	; ### BST R14, 7
	; ############
	
	; store B
	st -Y , R31
	st -Y , R30
	mov tosh, R23
	mov tosl, R22

	pop R27	
	pop R26
	pop R23
	pop R22
	pop R1
	pop R0
   jmp_ DO_NEXT		; this is the end of the word
; &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&


; &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
VE_FSINH:
    .dw $ff05 
    .db "fsinh",0
    .dw VE_HEAD
    .set VE_HEAD = VE_FSINH
XT_FSINH:
    .dw PFA_FSINH
PFA_FSINH:
; save registers
	push R0
	push R1
	push R22
	push R23
	push R26
	push R27
	; R28 do not use, = Y
	; R29 do not use, = Y
;######################################################	
;main body
; Floating point B = sinh (A)	
; IEEE 754
;     High        Low
; A = R25 R24 R27 R26  IN
; B = R23 R22 R31 R30  IN / OUT

	; fetch A	
	mov R24, tosl
	mov R25, tosh
	ld R26, Y+
	ld R27, Y+	
	
	; ############
	; ### BLD R14, 7
	push R28
	push R29
	;FLIB DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW (FLIBSTACK-8)
	LDI  R29,HIGH (FLIBSTACK-8)
	ST   Y,R26    	; one param: b=sin (a) via stack 
	STD  Y+1,R27
	STD  Y+2,R24
	STD  Y+3,R25

	CALL _sinh
	
	pop R29
	pop R28
	; ### BST R14, 7
	; ############
	
	; store B
	st -Y , R31
	st -Y , R30
	mov tosh, R23
	mov tosl, R22

	pop R27	
	pop R26
	pop R23
	pop R22
	pop R1
	pop R0
   jmp_ DO_NEXT		; this is the end of the word
; &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&

; &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
VE_FCOSH:
    .dw $ff05 
    .db "fcosh",0
    .dw VE_HEAD
    .set VE_HEAD = VE_FCOSH
XT_FCOSH:
    .dw PFA_FCOSH
PFA_FCOSH:
; save registers
	push R0
	push R1
	push R22
	push R23
	push R26
	push R27
	; R28 do not use, = Y
	; R29 do not use, = Y
;######################################################	
;main body
; Floating point B = cosh (A)	
; IEEE 754
;     High        Low
; A = R25 R24 R27 R26  IN
; B = R23 R22 R31 R30  IN / OUT

	; fetch A	
	mov R24, tosl
	mov R25, tosh
	ld R26, Y+
	ld R27, Y+	
	
	; ############
	; ### BLD R14, 7
	push R28
	push R29
	;FLIB DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW (FLIBSTACK-8)
	LDI  R29,HIGH (FLIBSTACK-8)
	ST   Y,R26    	; one param: b=sin (a) via stack 
	STD  Y+1,R27
	STD  Y+2,R24
	STD  Y+3,R25

	CALL _cosh
	
	pop R29
	pop R28
	; ### BST R14, 7
	; ############
	
	; store B
	st -Y , R31
	st -Y , R30
	mov tosh, R23
	mov tosl, R22

	pop R27	
	pop R26
	pop R23
	pop R22
	pop R1
	pop R0
   jmp_ DO_NEXT		; this is the end of the word
; &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&

; &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
VE_FTANH:
    .dw $ff05 
    .db "ftanh",0
    .dw VE_HEAD
    .set VE_HEAD = VE_FTANH
XT_FTANH:
    .dw PFA_FTANH
PFA_FTANH:
; save registers
	push R0
	push R1
	push R22
	push R23
	push R26
	push R27
	; R28 do not use, = Y
	; R29 do not use, = Y
;######################################################	
;main body
; Floating point B = tanh(A)	
; IEEE 754
;     High        Low
; A = R25 R24 R27 R26  IN
; B = R23 R22 R31 R30  IN / OUT

	; fetch A	
	mov R24, tosl
	mov R25, tosh
	ld R26, Y+
	ld R27, Y+	
	
	; ############
	; ### BLD R14, 7
	push R28
	push R29
	;FLIB DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW (FLIBSTACK-8)
	LDI  R29,HIGH (FLIBSTACK-8)
	ST   Y,R26    	; one param: b=sin (a) via stack 
	STD  Y+1,R27
	STD  Y+2,R24
	STD  Y+3,R25

	CALL _tanh
	
	pop R29
	pop R28
	; ### BST R14, 7
	; ############
	
	; store B
	st -Y , R31
	st -Y , R30
	mov tosh, R23
	mov tosl, R22

	pop R27	
	pop R26
	pop R23
	pop R22
	pop R1
	pop R0
   jmp_ DO_NEXT		; this is the end of the word
; &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&


; &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
VE_FEXP:
    .dw $ff04 
    .db "fexp"
    .dw VE_HEAD
    .set VE_HEAD = VE_FEXP
XT_FEXP:
    .dw PFA_FEXP
PFA_FEXP:
; save registers
	push R0
	push R1
	push R22
	push R23
	push R26
	push R27
	; R28 do not use, = Y
	; R29 do not use, = Y
;######################################################	
;main body
; Floating point B = exp(A)	
; IEEE 754
;     High        Low
; A = R25 R24 R27 R26  IN
; B = R23 R22 R31 R30  IN / OUT

	; fetch A	
	mov R24, tosl
	mov R25, tosh
	ld R26, Y+
	ld R27, Y+	
	
	; ############
	; ### BLD R14, 7
	push R28
	push R29
	;FLIB DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW (FLIBSTACK-8)
	LDI  R29,HIGH (FLIBSTACK-8)
	ST   Y,R26    	; one param: b=sin (a) via stack 
	STD  Y+1,R27
	STD  Y+2,R24
	STD  Y+3,R25

	CALL _exp
	
	pop R29
	pop R28
	; ### BST R14, 7
	; ############
	
	; store B
	st -Y , R31
	st -Y , R30
	mov tosh, R23
	mov tosl, R22

	pop R27	
	pop R26
	pop R23
	pop R22
	pop R1
	pop R0
   jmp_ DO_NEXT		; this is the end of the word
; &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&


; &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
VE_FLOG:
    .dw $ff04 
    .db "flog"
    .dw VE_HEAD
    .set VE_HEAD = VE_FLOG
XT_FLOG:
    .dw PFA_FLOG
PFA_FLOG:
; save registers
	push R0
	push R1
	push R22
	push R23
	push R26
	push R27
	; R28 do not use, = Y
	; R29 do not use, = Y
;######################################################	
;main body
; Floating point B = log(A)	
; IEEE 754
;     High        Low
; A = R25 R24 R27 R26  IN
; B = R23 R22 R31 R30  IN / OUT

	; fetch A	
	mov R24, tosl
	mov R25, tosh
	ld R26, Y+
	ld R27, Y+	
	
	; ############
	; ### BLD R14, 7
	push R28
	push R29
	;FLIB DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW (FLIBSTACK-8)
	LDI  R29,HIGH (FLIBSTACK-8)
	ST   Y,R26    	; one param: b=sin (a) via stack 
	STD  Y+1,R27
	STD  Y+2,R24
	STD  Y+3,R25

	CALL _log
	
	pop R29
	pop R28
	; ### BST R14, 7
	; ############
	
	; store B
	st -Y , R31
	st -Y , R30
	mov tosh, R23
	mov tosl, R22

	pop R27	
	pop R26
	pop R23
	pop R22
	pop R1
	pop R0
   jmp_ DO_NEXT		; this is the end of the word
; &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&

; &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
VE_FLOG10:
    .dw $ff06 
    .db "flog10"
    .dw VE_HEAD
    .set VE_HEAD = VE_FLOG10
XT_FLOG10:
    .dw PFA_FLOG10
PFA_FLOG10:
; save registers
	push R0
	push R1
	push R22
	push R23
	push R26
	push R27
	; R28 do not use, = Y
	; R29 do not use, = Y
;######################################################	
;main body
; Floating point B = log10(A)	
; IEEE 754
;     High        Low
; A = R25 R24 R27 R26  IN
; B = R23 R22 R31 R30  IN / OUT

	; fetch A	
	mov R24, tosl
	mov R25, tosh
	ld R26, Y+
	ld R27, Y+	
	
	; ############
	; ### BLD R14, 7
	push R28
	push R29
	;FLIB DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW (FLIBSTACK-8)
	LDI  R29,HIGH (FLIBSTACK-8)
	ST   Y,R26    	; one param: b=sin (a) via stack 
	STD  Y+1,R27
	STD  Y+2,R24
	STD  Y+3,R25

	CALL _log10
	
	pop R29
	pop R28
	; ### BST R14, 7
	; ############
	
	; store B
	st -Y , R31
	st -Y , R30
	mov tosh, R23
	mov tosl, R22

	pop R27	
	pop R26
	pop R23
	pop R22
	pop R1
	pop R0
   jmp_ DO_NEXT		; this is the end of the word
; &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&

; &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
VE_FSQRT:
    .dw $ff05 
    .db "fsqrt",0
    .dw VE_HEAD
    .set VE_HEAD = VE_FSQRT
XT_FSQRT:
    .dw PFA_FSQRT
PFA_FSQRT:
; save registers
	push R0
	push R1
	push R22
	push R23
	push R26
	push R27
	; R28 do not use, = Y
	; R29 do not use, = Y
;######################################################	
;main body
; Floating point B = sqrt(A)	
; IEEE 754
;     High        Low
; A = R25 R24 R27 R26  IN
; B = R23 R22 R31 R30  IN / OUT

	; fetch A	
	mov R24, tosl
	mov R25, tosh
	ld R26, Y+
	ld R27, Y+	
	
	; ############
	; ### BLD R14, 7
	push R28
	push R29
	;FLIB DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW (FLIBSTACK-8)
	LDI  R29,HIGH (FLIBSTACK-8)
	ST   Y,R26    	; one param: b=sin (a) via stack 
	STD  Y+1,R27
	STD  Y+2,R24
	STD  Y+3,R25

	CALL _sqrt
	
	pop R29
	pop R28
	; ### BST R14, 7
	; ############
	
	; store B
	st -Y , R31
	st -Y , R30
	mov tosh, R23
	mov tosl, R22

	pop R27	
	pop R26
	pop R23
	pop R22
	pop R1
	pop R0
   jmp_ DO_NEXT		; this is the end of the word
; &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&

; &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
VE_FPOW:
    .dw $ff04 
    .db "fpow"
    .dw VE_HEAD
    .set VE_HEAD = VE_FPOW
XT_FPOW:
    .dw PFA_FPOW
PFA_FPOW:
; save registers
	push R0
	push R1
	push R22
	push R23
	push R26
	push R27
	; R28 do not use, = Y
	; R29 do not use, = Y
;######################################################	
;main body
; Floating point B = A pow B	
; IEEE 754
;     High        Low
; A = R25 R24 R27 R26  IN
; B = R23 R22 R31 R30  IN / OUT

	; fetch A	
	mov R24, tosl
	mov R25, tosh
	ld R26, Y+
	ld R27, Y+	
	
	; fetch B 
	ld R22, Y+
	ld R23, Y+	
	ld R30, Y+
	ld R31, Y+
	
	; ############
	; ### BLD R14, 7
	push R28
	push R29
	;FLIB DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW (FLIBSTACK-8)
	LDI  R29,HIGH (FLIBSTACK-8)
	ST   Y,R26    	 ; one param: b=sin (a) via stack
	STD  Y+1,R27
	STD  Y+2,R24
	STD  Y+3,R25
	STD  Y+4,R30     ; two param: pow b=b^a via stack
	STD  Y+5,R31
	STD  Y+6,R22
	STD  Y+7,R23

	CALL _pow
	
	pop R29
	pop R28
	; ### BST R14, 7
	; ############
	
	; store B
	st -Y , R31
	st -Y , R30
	mov tosh, R23
	mov tosl, R22

	pop R27	
	pop R26
	pop R23
	pop R22
	pop R1
	pop R0
   jmp_ DO_NEXT		; this is the end of the word
; &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&

; &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
VE_FATAN2:
    .dw $ff06 
    .db "fatan2"
    .dw VE_HEAD
    .set VE_HEAD = VE_FATAN2
XT_FATAN2:
    .dw PFA_FATAN2
PFA_FATAN2:
; save registers
	push R0
	push R1
	push R22
	push R23
	push R26
	push R27
	; R28 do not use, = Y
	; R29 do not use, = Y
;######################################################	
;main body
; Floating point B = fatan A/B	
; IEEE 754
;     High        Low
; A = R25 R24 R27 R26  IN
; B = R23 R22 R31 R30  IN / OUT

	; fetch A	
	mov R24, tosl
	mov R25, tosh
	ld R26, Y+
	ld R27, Y+	
	
	; fetch B 
	ld R22, Y+
	ld R23, Y+	
	ld R30, Y+
	ld R31, Y+
	
	; ############
	; ### BLD R14, 7
	push R28
	push R29
	;FLIB DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW (FLIBSTACK-8)
	LDI  R29,HIGH (FLIBSTACK-8)
	ST   Y,R26    	 ; one param: b=sin (a) via stack
	STD  Y+1,R27
	STD  Y+2,R24
	STD  Y+3,R25
	STD  Y+4,R30     ; two param: pow b=b^a via stack
	STD  Y+5,R31
	STD  Y+6,R22
	STD  Y+7,R23

	CALL _atan2
	
	pop R29
	pop R28
	; ### BST R14, 7
	; ############
	
	; store B
	st -Y , R31
	st -Y , R30
	mov tosh, R23
	mov tosl, R22

	pop R27	
	pop R26
	pop R23
	pop R22
	pop R1
	pop R0
   jmp_ DO_NEXT		; this is the end of the word
; &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&


; $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
; ******************** Do not touch !!! *****************
	;.EQU SPL=0x3D
	;.EQU SPH=0x3E
	
	.MACRO __SUBWRN
	SUBI R@0,LOW(@2)
	SBCI R@1,HIGH(@2)
	.ENDM

	.MACRO __GETD1N
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __GETD2N
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM	
	
	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
	.ENDM
		
	.MACRO __PUTD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R31
	STD  Y+@0+2,R22
	STD  Y+@0+3,R23
	.ENDM

	.CSEG
_ftrunc:
   ldd  r23,y+3
   ldd  r22,y+2
   ldd  r31,y+1
   ld   r30,y
   ; ### bst  r23,7
   MOV R14, R23
   ; ###
   lsl  r23
   sbrc r22,7
   sbr  r23,1
   mov  r25,r23
   subi r25,0x7e
   breq __ftrunc0
   brcs __ftrunc0
   cpi  r25,24
   brsh __ftrunc1
   clr  r26
   clr  r27
   clr  r24
__ftrunc2:
   sec
   ror  r24
   ror  r27
   ror  r26
   dec  r25
   brne __ftrunc2
   and  r30,r26
   and  r31,r27
   and  r22,r24
   rjmp __ftrunc1
__ftrunc0:
   ; ### clt
   CLR R14
   ; ###
   clr  r23
   clr  r30
   clr  r31
   clr  r22
__ftrunc1:
   cbr  r22,0x80
   lsr  r23
   brcc __ftrunc3
   sbr  r22,0x80
__ftrunc3:
   ; ### bld  r23,7
   MOV R23, R14
   ; ###
   ld   r26,y+
   ld   r27,y+
   ld   r24,y+
   ld   r25,y+
   cp   r30,r26
   cpc  r31,r27
   cpc  r22,r24
   cpc  r23,r25
   ; ### bst  r25,7
   MOV R14, R25
   ; ###
   ret
_floor:
	CALL SUBOPT_0x6
	CALL __PUTPARD1
	CALL _ftrunc
	CALL SUBOPT_0x0
    brne __floor1
__floor0:
	CALL SUBOPT_0x6
	RJMP _0x2080002
__floor1:
    ; ### brtc __floor0
	SBRS R14,7
	RJMP __floor0
	; ###
	CALL SUBOPT_0x7
	CALL __SUBF12
	RJMP _0x2080002
_log:
	SBIW R28,4
	ST   -Y,R17
	ST   -Y,R16
	CALL SUBOPT_0x8
	CALL __CPD02
	BRLT _0x200000C
	CALL SUBOPT_0x9
	RJMP _0x2080008
_0x200000C:
	CALL SUBOPT_0xA
	CALL __PUTPARD1
	IN   R30,SPL
	IN   R31,SPH
	SBIW R30,1
	ST   -Y,R31
	ST   -Y,R30
	PUSH R17
	PUSH R16
	CALL _frexp
	POP  R16
	POP  R17
	CALL SUBOPT_0xB
	CALL SUBOPT_0x8
	CALL SUBOPT_0xC
	BRSH _0x200000D
	CALL SUBOPT_0xD
	CALL __ADDF12
	CALL SUBOPT_0xB
	__SUBWRN 16,17,1
_0x200000D:
	CALL SUBOPT_0xE
	CALL __SUBF12
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0xE
	CALL __ADDF12
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __DIVF21
	CALL SUBOPT_0xB
	CALL SUBOPT_0xD
	CALL SUBOPT_0xF
	__GETD2N 0x3F654226
	CALL __MULF12
	MOVW R26,R30
	MOVW R24,R22
	__GETD1N 0x4054114E
	CALL SUBOPT_0x10
	CALL SUBOPT_0x8
	CALL __MULF12
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x11
	__GETD2N 0x3FD4114D
	CALL __SUBF12
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __DIVF21
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	MOVW R30,R16
	CALL __CWD1
	CALL __CDF1
	__GETD2N 0x3F317218
	CALL __MULF12
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __ADDF12
_0x2080008:
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,10
	RET
_log10:
	CALL SUBOPT_0x2
	CALL __CPD02
	BRLT _0x200000E
	CALL SUBOPT_0x9
	RJMP _0x2080002
_0x200000E:
	CALL SUBOPT_0x12
	RCALL _log
	__GETD2N 0x3EDE5BD9
	CALL __MULF12
	RJMP _0x2080002
_exp:
	SBIW R28,8
	ST   -Y,R17
	ST   -Y,R16
	CALL SUBOPT_0x13
	__GETD1N 0xC2AEAC50
	CALL __CMPF12
	BRSH _0x200000F
	CALL SUBOPT_0x14
	RJMP _0x2080007
_0x200000F:
	__GETD1S 10
	CALL __CPD10
	BRNE _0x2000010
	CALL SUBOPT_0x15
	RJMP _0x2080007
_0x2000010:
	CALL SUBOPT_0x13
	__GETD1N 0x42B17218
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x2000011
	CALL SUBOPT_0x16
	RJMP _0x2080007
_0x2000011:
	CALL SUBOPT_0x13
	__GETD1N 0x3FB8AA3B
	CALL __MULF12
	__PUTD1S 10
	CALL __PUTPARD1
	RCALL _floor
	CALL __CFD1
	MOVW R16,R30
	MOVW R30,R16
	CALL SUBOPT_0x13
	CALL __CWD1
	CALL __CDF1
	CALL SUBOPT_0x10
	MOVW R26,R30
	MOVW R24,R22
	CALL SUBOPT_0x17
	CALL SUBOPT_0x10
	CALL SUBOPT_0xB
	CALL SUBOPT_0xD
	CALL SUBOPT_0xF
	__GETD2N 0x3D6C4C6D
	CALL __MULF12
	__GETD2N 0x40E6E3A6
	CALL __ADDF12
	CALL SUBOPT_0x8
	CALL __MULF12
	CALL SUBOPT_0xB
	CALL SUBOPT_0x11
	__GETD2N 0x41A68D28
	CALL __ADDF12
	__PUTD1S 2
	CALL SUBOPT_0xA
	__GETD2S 2
	CALL __ADDF12
	__GETD2N 0x3FB504F3
	CALL __MULF12
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x8
	CALL SUBOPT_0x11
	CALL __SUBF12
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL SUBOPT_0x18
	ST   -Y,R17
	ST   -Y,R16
	CALL _ldexp
_0x2080007:
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,14
	RET
_pow:
	SBIW R28,4
	CALL SUBOPT_0x19
	CALL __CPD10
	BRNE _0x2000012
	CALL SUBOPT_0x14
	RJMP _0x2080001
_0x2000012:
	CALL SUBOPT_0x1A
	BRGE _0x2000013
	CALL SUBOPT_0x3
	CALL __CPD10
	BRNE _0x2000014
	CALL SUBOPT_0x15
	RJMP _0x2080001
_0x2000014:
	CALL SUBOPT_0x19
	CALL SUBOPT_0x1B
	RJMP _0x2080001
_0x2000013:
	CALL SUBOPT_0x3
	MOVW R26,R28
	CALL __CFD1
	CALL __PUTDP1
	CALL SUBOPT_0x6
	CALL __CDF1
	MOVW R26,R30
	MOVW R24,R22
	CALL SUBOPT_0x3
	CALL __CPD12
	BREQ _0x2000015
	CALL SUBOPT_0x14
	RJMP _0x2080001
_0x2000015:
	CALL SUBOPT_0x19
	CALL __ANEGF1
	CALL SUBOPT_0x1B
	__PUTD1S 8
	CALL SUBOPT_0x6
	ANDI R30,LOW(0x1)
	BRNE _0x2000016
	CALL SUBOPT_0x19
	RJMP _0x2080001
_0x2000016:
	CALL SUBOPT_0x19
	CALL __ANEGF1
	RJMP _0x2080001
_sin:
	CALL SUBOPT_0x1C
	__GETD1N 0x3E22F983
	CALL __MULF12
	CALL SUBOPT_0x1D
	CALL SUBOPT_0x1E
	CALL __PUTPARD1
	RCALL _floor
	CALL SUBOPT_0x1F
	CALL SUBOPT_0x10
	CALL SUBOPT_0x1D
	CALL SUBOPT_0x1F
	CALL SUBOPT_0x17
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x2000017
	CALL SUBOPT_0x1E
	CALL SUBOPT_0x20
	CALL __SUBF12
	CALL SUBOPT_0x1D
	LDI  R17,LOW(1)
_0x2000017:
	CALL SUBOPT_0x1F
	__GETD1N 0x3E800000
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x2000018
	CALL SUBOPT_0x1F
	CALL SUBOPT_0x17
	CALL __SUBF12
	CALL SUBOPT_0x1D
_0x2000018:
	CPI  R17,0
	BREQ _0x2000019
	CALL SUBOPT_0x21
_0x2000019:
	CALL SUBOPT_0x22
	CALL SUBOPT_0x23
	CALL SUBOPT_0x24
	__GETD2N 0x4226C4B1
	CALL __MULF12
	MOVW R26,R30
	MOVW R24,R22
	__GETD1N 0x422DE51D
	CALL SUBOPT_0x10
	CALL SUBOPT_0x25
	__GETD2N 0x4104534C
	CALL __ADDF12
	CALL SUBOPT_0x1F
	CALL __MULF12
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x24
	__GETD2N 0x3FDEED11
	CALL __ADDF12
	CALL SUBOPT_0x25
	__GETD2N 0x3FA87B5E
	CALL __ADDF12
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __DIVF21
	RJMP _0x2080003
_cos:
	CALL SUBOPT_0x2
	__GETD1N 0x3FC90FDB
	CALL __SUBF12
	CALL __PUTPARD1
	RCALL _sin
	RJMP _0x2080002
_tan:
	SBIW R28,4
	CALL SUBOPT_0x5
	RCALL _cos
	CALL SUBOPT_0x0
	CALL __CPD10
	BRNE _0x200001A
	CALL SUBOPT_0x26
	CALL __CPD02
	BRGE _0x200001B
	CALL SUBOPT_0x16
	RJMP _0x2080006
_0x200001B:
	CALL SUBOPT_0x9
	RJMP _0x2080006
_0x200001A:
	CALL SUBOPT_0x5
	RCALL _sin
	MOVW R26,R30
	MOVW R24,R22
	CALL SUBOPT_0x6
	RJMP _0x2080005
_sinh:
	SBIW R28,4
	ST   -Y,R17
	LDI  R17,0
	LDD  R26,Y+8
	TST  R26
	BRPL _0x200001C
	CALL SUBOPT_0x21
	LDI  R17,LOW(1)
_0x200001C:
	CALL SUBOPT_0x27
	CALL SUBOPT_0x1F
	CALL SUBOPT_0x10
	CALL SUBOPT_0x20
	CALL __MULF12
	CALL SUBOPT_0x23
	CPI  R17,0
	BREQ _0x200001D
	CALL SUBOPT_0x28
	RJMP _0x2080003
_0x200001D:
	RJMP _0x2080004
_cosh:
	CALL SUBOPT_0x12
	CALL _fabs
	CALL __PUTPARD1
	RCALL _exp
	CALL SUBOPT_0x0
	CALL SUBOPT_0x7
	CALL __DIVF21
	CALL SUBOPT_0x2
	CALL __ADDF12
	CALL SUBOPT_0x20
	CALL __MULF12
	RJMP _0x2080002
_tanh:
	SBIW R28,4
	ST   -Y,R17
	LDI  R17,0
	LDD  R26,Y+8
	TST  R26
	BRPL _0x200001E
	CALL SUBOPT_0x21
	LDI  R17,LOW(1)
_0x200001E:
	CALL SUBOPT_0x27
	CALL SUBOPT_0x23
	__GETD2S 1
	CALL SUBOPT_0x1E
	CALL __SUBF12
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x24
	CALL SUBOPT_0x1F
	CALL __ADDF12
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __DIVF21
	CALL SUBOPT_0x23
	CPI  R17,0
	BREQ _0x200001F
	CALL SUBOPT_0x28
	RJMP _0x2080003
_0x200001F:
	RJMP _0x2080004
_xatan:
	SBIW R28,4
	CALL SUBOPT_0x3
	CALL SUBOPT_0x26
	CALL __MULF12
	CALL SUBOPT_0x0
	CALL SUBOPT_0x6
	__GETD2N 0x40CBD065
	CALL SUBOPT_0x29
	CALL SUBOPT_0x26
	CALL __MULF12
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x6
	__GETD2N 0x41296D00
	CALL __ADDF12
	CALL SUBOPT_0x2
	CALL SUBOPT_0x29
	POP  R26
	POP  R27
	POP  R24
	POP  R25
_0x2080005:
	CALL __DIVF21
_0x2080006:
	ADIW R28,8
	RET
_yatan:
	CALL SUBOPT_0x2
	__GETD1N 0x3ED413CD
	CALL __CMPF12
	BRSH _0x2000020
	CALL SUBOPT_0x12
	RCALL _xatan
	RJMP _0x2080002
_0x2000020:
	CALL SUBOPT_0x2
	__GETD1N 0x401A827A
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x2000021
	CALL SUBOPT_0x7
	CALL SUBOPT_0x18
	RCALL _xatan
	CALL SUBOPT_0x2A
	RJMP _0x2080002
_0x2000021:
	CALL SUBOPT_0x7
	CALL __SUBF12
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x7
	CALL __ADDF12
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL SUBOPT_0x18
	RCALL _xatan
	__GETD2N 0x3F490FDB
	CALL __ADDF12
	RJMP _0x2080002
_asin:
	CALL SUBOPT_0x1C
	CALL SUBOPT_0x2B
	BRLO _0x2000023
	CALL SUBOPT_0x1F
	CALL SUBOPT_0x15
	CALL __CMPF12
	BREQ PC+4
	BRCS PC+3
	JMP  _0x2000023
	RJMP _0x2000022
_0x2000023:
	CALL SUBOPT_0x16
	RJMP _0x2080003
_0x2000022:
	LDD  R26,Y+8
	TST  R26
	BRPL _0x2000025
	CALL SUBOPT_0x21
	LDI  R17,LOW(1)
_0x2000025:
	CALL SUBOPT_0x22
	__GETD2N 0x3F800000
	CALL SUBOPT_0x10
	CALL __PUTPARD1
	CALL _sqrt
	CALL SUBOPT_0x23
	CALL SUBOPT_0x1F
	CALL SUBOPT_0xC
	BREQ PC+2
	BRCC PC+3
	JMP  _0x2000026
	CALL SUBOPT_0x1E
	__GETD2S 1
	CALL SUBOPT_0x18
	RCALL _yatan
	CALL SUBOPT_0x2A
	RJMP _0x2000035
_0x2000026:
	CALL SUBOPT_0x24
	CALL SUBOPT_0x1F
	CALL SUBOPT_0x18
	RCALL _yatan
_0x2000035:
	__PUTD1S 1
	CPI  R17,0
	BREQ _0x2000028
	CALL SUBOPT_0x28
	RJMP _0x2080003
_0x2000028:
_0x2080004:
	__GETD1S 1
_0x2080003:
	LDD  R17,Y+0
	ADIW R28,9
	RET
_acos:
	CALL SUBOPT_0x2
	CALL SUBOPT_0x2B
	BRLO _0x200002A
	CALL SUBOPT_0x2
	CALL SUBOPT_0x15
	CALL __CMPF12
	BREQ PC+4
	BRCS PC+3
	JMP  _0x200002A
	RJMP _0x2000029
_0x200002A:
	CALL SUBOPT_0x16
	RJMP _0x2080002
_0x2000029:
	CALL SUBOPT_0x12
	RCALL _asin
	CALL SUBOPT_0x2A
	RJMP _0x2080002
_atan:
	LDD  R26,Y+3
	TST  R26
	BRMI _0x200002C
	CALL SUBOPT_0x12
	RCALL _yatan
	RJMP _0x2080002
_0x200002C:
	CALL SUBOPT_0x2C
_0x2080002:
	ADIW R28,4
	RET
_atan2:
	SBIW R28,4
	CALL SUBOPT_0x3
	CALL __CPD10
	BRNE _0x200002D
	CALL SUBOPT_0x19
	CALL __CPD10
	BRNE _0x200002E
	CALL SUBOPT_0x16
	RJMP _0x2080001
_0x200002E:
	CALL SUBOPT_0x1A
	BRGE _0x200002F
	__GETD1N 0x3FC90FDB
	RJMP _0x2080001
_0x200002F:
	__GETD1N 0xBFC90FDB
	RJMP _0x2080001
_0x200002D:
	CALL SUBOPT_0x3
	__GETD2S 8
	CALL __DIVF21
	CALL SUBOPT_0x0
	CALL SUBOPT_0x26
	CALL __CPD02
	BRGE _0x2000030
	LDD  R26,Y+11
	TST  R26
	BRMI _0x2000031
	CALL SUBOPT_0x12
	RCALL _yatan
	RJMP _0x2080001
_0x2000031:
	CALL SUBOPT_0x2C
	RJMP _0x2080001
_0x2000030:
	LDD  R26,Y+11
	TST  R26
	BRMI _0x2000032
	CALL SUBOPT_0x6
	CALL __ANEGF1
	CALL __PUTPARD1
	RCALL _yatan
	__GETD2N 0x40490FDB
	CALL SUBOPT_0x10
	RJMP _0x2080001
_0x2000032:
	CALL SUBOPT_0x12
	RCALL _yatan
	__GETD2N 0xC0490FDB
	CALL __ADDF12
_0x2080001:
	ADIW R28,12
	RET
	.CSEG
_fabs:
    ld   r30,y+
    ld   r31,y+
    ld   r22,y+
    ld   r23,y+
    cbr  r23,0x80
    ret
	.DSEG
	.CSEG
	.DSEG
__seed_G101:
	.BYTE 0x4
	.CSEG
SUBOPT_0x0:
	CALL __PUTD1S0
	RET
SUBOPT_0x1:
	CALL __GETD1S0
	__GETD2S 4
	RET
SUBOPT_0x2:
	CALL __GETD2S0
	RET
SUBOPT_0x3:
	__GETD1S 4
	RET
SUBOPT_0x4:
	RCALL SUBOPT_0x0
	RCALL SUBOPT_0x3
	CALL __PUTPARD1
	RET
SUBOPT_0x5:
	RCALL SUBOPT_0x3
	CALL __PUTPARD1
	RET
SUBOPT_0x6:
	CALL __GETD1S0
	RET
SUBOPT_0x7:
	RCALL SUBOPT_0x6
	__GETD2N 0x3F800000
	RET
SUBOPT_0x8:
	__GETD2S 6
	RET
SUBOPT_0x9:
	__GETD1N 0xFF7FFFFF
	RET
SUBOPT_0xA:
	__GETD1S 6
	RET
SUBOPT_0xB:
	__PUTD1S 6
	RET
SUBOPT_0xC:
	__GETD1N 0x3F3504F3
	CALL __CMPF12
	RET
SUBOPT_0xD:
	RCALL SUBOPT_0xA
	RJMP SUBOPT_0x8
SUBOPT_0xE:
	RCALL SUBOPT_0xA
	__GETD2N 0x3F800000
	RET
SUBOPT_0xF:
	CALL __MULF12
	__PUTD1S 2
	RET
SUBOPT_0x10:
	CALL __SWAPD12
	CALL __SUBF12
	RET
SUBOPT_0x11:
	__GETD1S 2
	RET
SUBOPT_0x12:
	RCALL SUBOPT_0x6
	CALL __PUTPARD1
	RET
SUBOPT_0x13:
	__GETD2S 10
	RET
SUBOPT_0x14:
	__GETD1N 0x0
	RET
SUBOPT_0x15:
	__GETD1N 0x3F800000
	RET
SUBOPT_0x16:
	__GETD1N 0x7F7FFFFF
	RET
SUBOPT_0x17:
	__GETD1N 0x3F000000
	RET
SUBOPT_0x18:
	CALL __DIVF21
	CALL __PUTPARD1
	RET
SUBOPT_0x19:
	__GETD1S 8
	RET
SUBOPT_0x1A:
	__GETD2S 8
	CALL __CPD02
	RET
SUBOPT_0x1B:
	CALL __PUTPARD1
	CALL _log
	__GETD2S 4
	CALL __MULF12
	CALL __PUTPARD1
	JMP  _exp
SUBOPT_0x1C:
	SBIW R28,4
	ST   -Y,R17
	LDI  R17,0
	__GETD2S 5
	RET
SUBOPT_0x1D:
	__PUTD1S 5
	RET
SUBOPT_0x1E:
	__GETD1S 5
	RET
SUBOPT_0x1F:
	__GETD2S 5
	RET
SUBOPT_0x20:
	__GETD2N 0x3F000000
	RET
SUBOPT_0x21:
	RCALL SUBOPT_0x1E
	CALL __ANEGF1
	RJMP SUBOPT_0x1D
SUBOPT_0x22:
	RCALL SUBOPT_0x1E
	RCALL SUBOPT_0x1F
	CALL __MULF12
	RET
SUBOPT_0x23:
	__PUTD1S 1
	RET
SUBOPT_0x24:
	__GETD1S 1
	RET
SUBOPT_0x25:
	__GETD2S 1
	CALL __MULF12
	RET
SUBOPT_0x26:
	__GETD2S 4
	RET
SUBOPT_0x27:
	RCALL SUBOPT_0x1E
	CALL __PUTPARD1
	CALL _exp
	RCALL SUBOPT_0x1D
	RCALL SUBOPT_0x1E
	__GETD2N 0x3F800000
	CALL __DIVF21
	RET
SUBOPT_0x28:
	RCALL SUBOPT_0x24
	CALL __ANEGF1
	RET
SUBOPT_0x29:
	CALL __MULF12
	__GETD2N 0x414A8F4E
	CALL __ADDF12
	RET
SUBOPT_0x2A:
	__GETD2N 0x3FC90FDB
	RJMP SUBOPT_0x10
SUBOPT_0x2B:
	__GETD1N 0xBF800000
	CALL __CMPF12
	RET
SUBOPT_0x2C:
	RCALL SUBOPT_0x6
	CALL __ANEGF1
	CALL __PUTPARD1
	CALL _yatan
	CALL __ANEGF1
	RET
	.CSEG
_frexp:
	LD   R26,Y+
	LD   R27,Y+
	LD   R30,Y+
	LD   R31,Y+
	LD   R22,Y+
	LD   R23,Y+
	; ### BST  R23,7
	MOV R14, R23
	; ###
	LSL  R22
	ROL  R23
	CLR  R24
	SUBI R23,0x7E
	SBC  R24,R24
	ST   X+,R23
	ST   X,R24
	LDI  R23,0x7E
	LSR  R23
	ROR  R22
	; ### BRTS __ANEGF1
	SBRC R14,7
	RJMP __ANEGF1
	; ###
	RET
_ldexp:
	LD   R26,Y+
	LD   R27,Y+
	LD   R30,Y+
	LD   R31,Y+
	LD   R22,Y+
	LD   R23,Y+
	; ### BST  R23,7
	MOV R14, R23
	; ###
	LSL  R22
	ROL  R23
	ADD  R23,R26
	LSR  R23
	ROR  R22
	; ### BRTS __ANEGF1
	SBRC R14,7
	RJMP __ANEGF1
	; ###
	RET
__ANEGF1:
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
	BREQ __ANEGF10
	SUBI R23,0x80
__ANEGF10:
	RET
__ROUND_REPACK:
	TST  R21
	BRPL __REPACK
	CPI  R21,0x80
	BRNE __ROUND_REPACK0
	SBRS R30,0
	RJMP __REPACK
__ROUND_REPACK0:
	ADIW R30,1
	ADC  R22,R25
	ADC  R23,R25
	BRVS __REPACK1
__REPACK:
	LDI  R21,0x80
	EOR  R21,R23
	BRNE __REPACK0
	PUSH R21
	RJMP __ZERORES
__REPACK0:
	CPI  R21,0xFF
	BREQ __REPACK1
	LSL  R22
	LSL  R0
	ROR  R21
	ROR  R22
	MOV  R23,R21
	RET
__REPACK1:
	PUSH R21
	TST  R0
	BRMI __REPACK2
	RJMP __MAXRES
__REPACK2:
	RJMP __MINRES
__UNPACK:
	LDI  R21,0x80
	MOV  R1,R25
	AND  R1,R21
	LSL  R24
	ROL  R25
	EOR  R25,R21
	LSL  R21
	ROR  R24
__UNPACK1:
	LDI  R21,0x80
	MOV  R0,R23
	AND  R0,R21
	LSL  R22
	ROL  R23
	EOR  R23,R21
	LSL  R21
	ROR  R22
	RET
__CFD1U:
	; ### SET
	CLR R14
	COM R14
	; ###
	RJMP __CFD1U0
__CFD1:
	; ### CLT
	CLR R14
	; ###
__CFD1U0:
	PUSH R21
	RCALL __UNPACK1
	CPI  R23,0x80
	BRLO __CFD10
	CPI  R23,0xFF
	BRCC __CFD10
	RJMP __ZERORES
__CFD10:
	LDI  R21,22
	SUB  R21,R23
	BRPL __CFD11
	NEG  R21
	CPI  R21,8
	; ### BRTC __CFD19
	SBRS R14,7
	RJMP __CFD19
	; ###
	CPI  R21,9
__CFD19:
	BRLO __CFD17
	SER  R30
	SER  R31
	SER  R22
	LDI  R23,0x7F
	; ### BLD  R23,7
	MOV R23, R14
	; ###
	RJMP __CFD15
__CFD17:
	CLR  R23
	TST  R21
	BREQ __CFD15
__CFD18:
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R23
	DEC  R21
	BRNE __CFD18
	RJMP __CFD15
__CFD11:
	CLR  R23
__CFD12:
	CPI  R21,8
	BRLO __CFD13
	MOV  R30,R31
	MOV  R31,R22
	MOV  R22,R23
	SUBI R21,8
	RJMP __CFD12
__CFD13:
	TST  R21
	BREQ __CFD15
__CFD14:
	LSR  R23
	ROR  R22
	ROR  R31
	ROR  R30
	DEC  R21
	BRNE __CFD14
__CFD15:
	TST  R0
	BRPL __CFD16
	RCALL __ANEGD1
__CFD16:
	POP  R21
	RET
__CDF1U:
	; ### SET
	CLR R14
	COM R14
	; ###
	RJMP __CDF1U0
__CDF1:
	; ### CLT
	CLR R14
	; ###
__CDF1U0:
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
	BREQ __CDF10
	CLR  R0
	; ### BRTS __CDF11
	SBRC R14,7
	RJMP __CDF11
	; ###
	TST  R23
	BRPL __CDF11
	COM  R0
	RCALL __ANEGD1
__CDF11:
	MOV  R1,R23
	LDI  R23,30
	TST  R1
__CDF12:
	BRMI __CDF13
	DEC  R23
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R1
	RJMP __CDF12
__CDF13:
	MOV  R30,R31
	MOV  R31,R22
	MOV  R22,R1
	PUSH R21
	RCALL __REPACK
	POP  R21
__CDF10:
	RET
__SWAPACC:
	PUSH R20
	MOVW R20,R30
	MOVW R30,R26
	MOVW R26,R20
	MOVW R20,R22
	MOVW R22,R24
	MOVW R24,R20
	MOV  R20,R0
	MOV  R0,R1
	MOV  R1,R20
	POP  R20
	RET
__UADD12:
	ADD  R30,R26
	ADC  R31,R27
	ADC  R22,R24
	RET
__NEGMAN1:
	COM  R30
	COM  R31
	COM  R22
	SUBI R30,-1
	SBCI R31,-1
	SBCI R22,-1
	RET
__SUBF12:
	PUSH R21
	RCALL __UNPACK
	CPI  R25,0x80
	BREQ __ADDF129
	LDI  R21,0x80
	EOR  R1,R21
	RJMP __ADDF120
__ADDF12:
	PUSH R21
	RCALL __UNPACK
	CPI  R25,0x80
	BREQ __ADDF129
__ADDF120:
	CPI  R23,0x80
	BREQ __ADDF128
__ADDF121:
	MOV  R21,R23
	SUB  R21,R25
	BRVS __ADDF1211
	BRPL __ADDF122
	RCALL __SWAPACC
	RJMP __ADDF121
__ADDF122:
	CPI  R21,24
	BRLO __ADDF123
	CLR  R26
	CLR  R27
	CLR  R24
__ADDF123:
	CPI  R21,8
	BRLO __ADDF124
	MOV  R26,R27
	MOV  R27,R24
	CLR  R24
	SUBI R21,8
	RJMP __ADDF123
__ADDF124:
	TST  R21
	BREQ __ADDF126
__ADDF125:
	LSR  R24
	ROR  R27
	ROR  R26
	DEC  R21
	BRNE __ADDF125
__ADDF126:
	MOV  R21,R0
	EOR  R21,R1
	BRMI __ADDF127
	RCALL __UADD12
	BRCC __ADDF129
	ROR  R22
	ROR  R31
	ROR  R30
	INC  R23
	BRVC __ADDF129
	RJMP __MAXRES
__ADDF128:
	RCALL __SWAPACC
__ADDF129:
	RCALL __REPACK
	POP  R21
	RET
__ADDF1211:
	BRCC __ADDF128
	RJMP __ADDF129
__ADDF127:
	SUB  R30,R26
	SBC  R31,R27
	SBC  R22,R24
	BREQ __ZERORES
	BRCC __ADDF1210
	COM  R0
	RCALL __NEGMAN1
__ADDF1210:
	TST  R22
	BRMI __ADDF129
	LSL  R30
	ROL  R31
	ROL  R22
	DEC  R23
	BRVC __ADDF1210
__ZERORES:
	CLR  R30
	CLR  R31
	CLR  R22
	CLR  R23
	POP  R21
	RET
__MINRES:
	SER  R30
	SER  R31
	LDI  R22,0x7F
	SER  R23
	POP  R21
	RET
__MAXRES:
	SER  R30
	SER  R31
	LDI  R22,0x7F
	LDI  R23,0x7F
	POP  R21
	RET
__MULF12:
	PUSH R21
	RCALL __UNPACK
	CPI  R23,0x80
	BREQ __ZERORES
	CPI  R25,0x80
	BREQ __ZERORES
	EOR  R0,R1
	SEC
	ADC  R23,R25
	BRVC __MULF124
	BRLT __ZERORES
__MULF125:
	TST  R0
	BRMI __MINRES
	RJMP __MAXRES
__MULF124:
	PUSH R0
	PUSH R17
	PUSH R18
	PUSH R19
	PUSH R20
	CLR  R17
	CLR  R18
	CLR  R25
	MUL  R22,R24
	MOVW R20,R0
	MUL  R24,R31
	MOV  R19,R0
	ADD  R20,R1
	ADC  R21,R25
	MUL  R22,R27
	ADD  R19,R0
	ADC  R20,R1
	ADC  R21,R25
	MUL  R24,R30
	RCALL __MULF126
	MUL  R27,R31
	RCALL __MULF126
	MUL  R22,R26
	RCALL __MULF126
	MUL  R27,R30
	RCALL __MULF127
	MUL  R26,R31
	RCALL __MULF127
	MUL  R26,R30
	ADD  R17,R1
	ADC  R18,R25
	ADC  R19,R25
	ADC  R20,R25
	ADC  R21,R25
	MOV  R30,R19
	MOV  R31,R20
	MOV  R22,R21
	MOV  R21,R18
	POP  R20
	POP  R19
	POP  R18
	POP  R17
	POP  R0
	TST  R22
	BRMI __MULF122
	LSL  R21
	ROL  R30
	ROL  R31
	ROL  R22
	RJMP __MULF123
__MULF122:
	INC  R23
	BRVS __MULF125
__MULF123:
	RCALL __ROUND_REPACK
	POP  R21
	RET
__MULF127:
	ADD  R17,R0
	ADC  R18,R1
	ADC  R19,R25
	RJMP __MULF128
__MULF126:
	ADD  R18,R0
	ADC  R19,R1
__MULF128:
	ADC  R20,R25
	ADC  R21,R25
	RET
__DIVF21:
	PUSH R21
	RCALL __UNPACK
	CPI  R23,0x80
	BRNE __DIVF210
	TST  R1
__DIVF211:
	BRPL __DIVF219
	RJMP __MINRES
__DIVF219:
	RJMP __MAXRES
__DIVF210:
	CPI  R25,0x80
	BRNE __DIVF218
__DIVF217:
	RJMP __ZERORES
__DIVF218:
	EOR  R0,R1
	SEC
	SBC  R25,R23
	BRVC __DIVF216
	BRLT __DIVF217
	TST  R0
	RJMP __DIVF211
__DIVF216:
	MOV  R23,R25
	PUSH R17
	PUSH R18
	PUSH R19
	PUSH R20
	CLR  R1
	CLR  R17
	CLR  R18
	CLR  R19
	CLR  R20
	CLR  R21
	LDI  R25,32
__DIVF212:
	CP   R26,R30
	CPC  R27,R31
	CPC  R24,R22
	CPC  R20,R17
	BRLO __DIVF213
	SUB  R26,R30
	SBC  R27,R31
	SBC  R24,R22
	SBC  R20,R17
	SEC
	RJMP __DIVF214
__DIVF213:
	CLC
__DIVF214:
	ROL  R21
	ROL  R18
	ROL  R19
	ROL  R1
	ROL  R26
	ROL  R27
	ROL  R24
	ROL  R20
	DEC  R25
	BRNE __DIVF212
	MOVW R30,R18
	MOV  R22,R1
	POP  R20
	POP  R19
	POP  R18
	POP  R17
	TST  R22
	BRMI __DIVF215
	LSL  R21
	ROL  R30
	ROL  R31
	ROL  R22
	DEC  R23
	BRVS __DIVF217
__DIVF215:
	RCALL __ROUND_REPACK
	POP  R21
	RET
__CMPF12:
	TST  R25
	BRMI __CMPF120
	TST  R23
	BRMI __CMPF121
	CP   R25,R23
	BRLO __CMPF122
	BRNE __CMPF121
	CP   R26,R30
	CPC  R27,R31
	CPC  R24,R22
	BRLO __CMPF122
	BREQ __CMPF123
__CMPF121:
	CLZ
	CLC
	RET
__CMPF122:
	CLZ
	SEC
	RET
__CMPF123:
	SEZ
	CLC
	RET
__CMPF120:
	TST  R23
	BRPL __CMPF122
	CP   R25,R23
	BRLO __CMPF121
	BRNE __CMPF122
	CP   R30,R26
	CPC  R31,R27
	CPC  R22,R24
	BRLO __CMPF122
	BREQ __CMPF123
	RJMP __CMPF121
_sqrt:
	sbiw r28,4
	push r21
	ldd  r25,y+7
	tst  r25
	brne __sqrt0
	adiw r28,8
	rjmp __zerores
__sqrt0:
	brpl __sqrt1
	adiw r28,8
	rjmp __maxres
__sqrt1:
	push r20
	ldi  r20,66
	ldd  r24,y+6
	ldd  r27,y+5
	ldd  r26,y+4
__sqrt2:
	st   y,r24
	std  y+1,r25
	std  y+2,r26
	std  y+3,r27
	movw r30,r26
	movw r22,r24
	ldd  r26,y+4
	ldd  r27,y+5
	ldd  r24,y+6
	ldd  r25,y+7
	rcall __divf21
	ld   r24,y
	ldd  r25,y+1
	ldd  r26,y+2
	ldd  r27,y+3
	rcall __addf12
	rcall __unpack1
	dec  r23
	rcall __repack
	ld   r24,y
	ldd  r25,y+1
	ldd  r26,y+2
	ldd  r27,y+3
	eor  r26,r30
	andi r26,0xf8
	brne __sqrt4
	cp   r27,r31
	cpc  r24,r22
	cpc  r25,r23
	breq __sqrt3
__sqrt4:
	dec  r20
	breq __sqrt3
	movw r26,r30
	movw r24,r22
	rjmp __sqrt2
__sqrt3:
	pop  r20
	pop  r21
	adiw r28,8
	ret
__ANEGD1:
	COM  R31
	COM  R22
	COM  R23
	NEG  R30
	SBCI R31,-1
	SBCI R22,-1
	SBCI R23,-1
	RET
__CWD1:
	MOV  R22,R31
	ADD  R22,R22
	SBC  R22,R22
	MOV  R23,R22
	RET
__PUTDP1:
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	RET
__GETD1S0:
	LD   R30,Y
	LDD  R31,Y+1
	LDD  R22,Y+2
	LDD  R23,Y+3
	RET
__GETD2S0:
	LD   R26,Y
	LDD  R27,Y+1
	LDD  R24,Y+2
	LDD  R25,Y+3
	RET
__PUTD1S0:
	ST   Y,R30
	STD  Y+1,R31
	STD  Y+2,R22
	STD  Y+3,R23
	RET
__PUTPARD1:
	ST   -Y,R23
	ST   -Y,R22
	ST   -Y,R31
	ST   -Y,R30
	RET
__SWAPD12:
	MOV  R1,R24
	MOV  R24,R22
	MOV  R22,R1
	MOV  R1,R25
	MOV  R25,R23
	MOV  R23,R1
__SWAPW12:
	MOV  R1,R27
	MOV  R27,R31
	MOV  R31,R1
__SWAPB12:
	MOV  R1,R26
	MOV  R26,R30
	MOV  R30,R1
	RET
__CPD10:
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
	RET
__CPD02:
	CLR  R0
	CP   R0,R26
	CPC  R0,R27
	CPC  R0,R24
	CPC  R0,R25
	RET
__CPD12:
	CP   R30,R26
	CPC  R31,R27
	CPC  R22,R24
	CPC  R23,R25
	RET
; ***************************** END OF LIB **************************
