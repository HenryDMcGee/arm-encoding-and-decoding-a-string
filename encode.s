/*

r6 = value of input str
r4 = i
r5 = encoded
r7 = key value
r8 = temp
r9 = holds position of key

*/
	 .global encode
encode:
  push {r4-r9, lr}

	//Set i = 0, j = 0
	mov r4, #0
	mov r9, #0


loop_encode:

	mov r8, #0
	ldrb r6, [r0, r4]
	ldrb r7, [r2, r9]

	//Stop of there is a \0
	cmp r6, #0
	beq done

	//Reset key to 0th position if \0 found
	cmp r7, #0
	bne not_end_key
	mov r9, #0
	ldrb r7, [r2, r9]

not_end_key:

	//Don't do anything if there is a space
	cmp r6, #96
	blt continue_space
	cmp r7, #96
	blt continue_space




	//Put on 1 - 26 scale
	sub r6, r6, #96
	sub r7, r7, #96

	cmp r3, #1
	beq loop_decode

	//encode portion
	add r8, r6, r7

	cmp r8, #26
	bgt over
	add r6, r6, r7
	bal continue

over:
	add r6, r6, r7
	sub r6, r6, #26
	bal continue


loop_decode:
	//decode portion
	sub r8, r6, r7

	cmp r8, #0
	ble under
	sub r6, r6, r7
	bal continue

under:
	sub r6, r6, r7
	add r6, r6, #26
	bal continue


continue:

	//put back onto ascii scale
	add r6, r6, #96
	add r7, r7, #96
	// i++, j++
continue_space:
	strb r6, [r1, r4]
	add r4, r4, #1
	add r9, r9, #1
	bal loop_encode
done:
	mov r8, #0
	strb r8, [r1, r4]
  pop {r4-r9, pc}
