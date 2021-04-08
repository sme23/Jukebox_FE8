.thumb
.align

.global SoundRoomBoot
.type SoundRoomBoot, %function

.equ ProcStart,0x8002C7D @r0 = proc address in ROM to start, r1 = parent proc address in RAM
.equ ProcStartBlocking, 0x8002ce1 @r0 = proc address in ROM to start, r1 = parent proc address in RAM
.equ RegisterTileGraphics, 0x08002015 @r0 = frame data????, r1 = area of vram, r2 = 0x2000???? (i dont think this is actually necessary?)
.equ LoadBgConfig, 0x0881B59 @r0 = something but we can keep it as 0
.equ InitOAMSplice,0x80020fd
.equ SoundRoomStart, 0x80AFF1C

.macro blh to, reg=r3
  push {\reg}
  ldr \reg, =\to
  mov lr, \reg
  pop {\reg}
  .short 0xf800
.endm

.global SoundRoomBootFunc
.type SoundRoomBootFunc, %function

SoundRoomBootFunc:
push {r14}
//make a dummy proc
ldr r0,=DummyProc
mov r1,#0
mov r2,#0
mov r3,#0
mov r5,#0
blh ProcStart
pop {r0}
bx r0

.ltorg
.align


SoundRoomBoot:

push {r5-r7,r14}
sub sp,#4

//make a dummy proc
ldr r0,=DummyProc
mov r1,#0
mov r2,#0
mov r3,#0
mov r5,#0
blh ProcStart

mov r4,r0

//mov r1,r4
//ldr r0,=#0x8A21338 //sound room UI proc
//blh ProcStart



mov r0,#0
ldr r1,=0x80AF535
bx r1

.ltorg
.align

.global InfiniteLoopProcFunc
.type InfiniteLoopProcFunc, %function

InfiniteLoopProcFunc:
bx r14

.ltorg
.align

.global Frame1BootFunc
.type Frame1BootFunc, %function

Frame1BootFunc:
//this used to be dumb but now it's going to actually do something
push {r14}
pop {r0}
bx r0

.ltorg
.align

.global GrrThisIsWhatIGet
.type GrrThisIsWhatIGet, %function

GrrThisIsWhatIGet:
mov r0,#0
mov r1,#0xF
blh InitOAMSplice

