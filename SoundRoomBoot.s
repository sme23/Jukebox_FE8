.thumb
.align

.global SoundRoomBoot
.type SoundRoomBoot, %function

.equ ProcStart,0x8002C7D
.macro blh to, reg=r3
  push {\reg}
  ldr \reg, =\to
  mov lr, \reg
  pop {\reg}
  .short 0xf800
.endm

SoundRoomBoot:

push {r5-r7,r14}
sub sp,#4

//make a dummy proc
ldr r0,=DummyProc
mov r1,#0
mov r2,#0
mov r3,#0
blh ProcStart

mov r4,r0
mov r0,#0

ldr r1,=0x80AF535
bx r1

.ltorg
.align

