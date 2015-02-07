	.text
	.global sc_downcall
sc_downcall:
	MOV r0.w0, r14.w0		//* save the pointer to the handler function
	//* first issue the downcall ready
	LDI r14, 254			//* DOWNCALL_READY
	LDI r31, 35			//* SYSCALL_VALUE
	HALT				//* host must save R3.w0 locally
	//* the host will manipulate our state so that the arguments are correct
	JAL r3.w2, r0.w0		//* call
	MOV r0, r14			//* save the return code
	//* when we return here, we will inform the host of the result
	LDI r14, 255			//* DOWNCALL_DONE
	LDI r31, 35			//* SYSCALL_VALUE
	HALT				//* host must return to save R3.w0
