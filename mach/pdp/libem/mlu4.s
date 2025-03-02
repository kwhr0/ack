#define TEST	0
.sect .text; .sect .rom; .sect .data; .sect .bss; .sect .text
.sect .text
#if TEST
.define _mlu4
_mlu4:
#else
.define mlu4~
mlu4~:
#endif
mov r5,-(sp)
mov sp,r5
sub $030,sp
mov r2,-(sp)
mov r3,-(sp)
mov 6(r5),-2(r5)	! a0 = x
mov 4(r5),-4(r5)	! a1 = x >> 16
mov 10(r5),-6(r5)	! b0 = y
mov 8(r5),-8(r5)	! b1 = y >> 16
clr r1
mov -2(r5),r0
bge 1f
inc r1
1:
bic $-32768,r0
mov r0,-10(r5)	! a0l = a0 & 0x7fff
mov r1,-12(r5)	! a0m = a0 < 0
clr r1
mov -4(r5),r0
bge 1f
inc r1
1:
bic $-32768,r0
mov r0,-14(r5)	! a1l = a1 & 0x7fff
mov r1,-16(r5)	! a1m = a1 < 0
clr r1
mov -6(r5),r0
bge 1f
inc r1
1:
bic $-32768,r0
mov r0,-18(r5)	! b0l = b0 & 0x7fff
mov r1,-20(r5)	! b0m = b0 < 0
clr r1
mov -8(r5),r0
bge 1f
inc r1
1:
bic $-32768,r0
mov r0,-22(r5)	! b1l = b1 & 0x7fff
mov r1,-24(r5)	! b1m = b1 < 0
mov -18(r5),r0
mul -10(r5),r0
mov r0,r2
mov r1,r3	! r = a0l * b0l
tst -12(r5)
jeq I1_4
mov -18(r5),r1
clr r0
ashc $15,r0
add r1,r3
adc r0
add r0,r2	! if (a0m) r += b0l << 15
I1_4:
tst -20(r5)
jeq I1_7
mov -10(r5),r1
clr r0
ashc $15,r0
add r1,r3
adc r0
add r0,r2	! if (b0m) r += a0l << 15
I1_7:
tst -12(r5)
jeq I1_a
tst -20(r5)
jeq I1_a
add $16384,r2	! if (a0m && b0m) r += 0x40000000
I1_a:
mov -14(r5),r0
mul -18(r5),r0
add r1,r2	! r += a1l * b0l << 16
tst -16(r5)
jeq I1_e
bit $1,-18(r5)
jeq I1_e
add $-32768,r2	! if (a1m && b0l & 1) r += 0x80000000
I1_e:
tst -20(r5)
jeq I1_12
bit $1,-14(r5)
jeq I1_12
add $-32768,r2	! if (b0m && a1l & 1) r += 0x80000000
I1_12:
mov -10(r5),r0
mul -22(r5),r0
add r1,r2	! r += a0l * b1l << 16
tst -12(r5)
jeq I1_16
bit $1,-22(r5)
jeq I1_16
add $-32768,r2	! if (a0m && b1l & 1) r += 0x80000000
I1_16:
tst -24(r5)
jeq I1_1a
bit $1,-10(r5)
jeq I1_1a
add $-32768,r2	! if (b1m && a0l & 1) r += 0x80000000
I1_1a:
mov r3,r1
mov r2,r0
mov (sp)+,r3
mov (sp)+,r2
!RT
mov r5,sp
mov (sp)+,r5
mov (sp)+,retadr
#if !TEST
add $010,sp
#endif
mov retadr,-(sp)
rts pc
.sect .bss
retadr:	.space	2
