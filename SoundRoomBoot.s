.thumb
.align

.global SoundRoomBoot
.type SoundRoomBoot, %function

.equ ProcStart,0x8002C7D
.equ ProcStartBlocking,0x08002CE1
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


.global InfiniteLoopProcRoutine
.type InfiniteLoopProcRoutine, %function

InfiniteLoopProcRoutine:
bx r14

.ltorg
.align


.global BeginningProcStarterThings
.type BeginningProcStarterThings, %function

BeginningProcStarterThings:

push {r4,r14}
mov r4,r0 @r4 = parent proc ptr

ldr r0,=#0x08A21338 @SoundRoomUI proc
mov r1,r4
mov r2,#0
mov r3,#0
blh ProcStartBlocking

pop {r4}
pop {r0}
bx r0

.ltorg
.align

.global NewBootFunc
.type NewBootFunc, %function

NewBootFunc:
push {r14}

//make a dummy proc
ldr r0,=DummyProc
mov r1,#0
mov r2,#0
mov r3,#0
blh ProcStart

pop {r0}
bx r0

.ltorg
.align
