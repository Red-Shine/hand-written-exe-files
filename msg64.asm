; DOS Header
db 77, 90 ; MZ
dw 144 ; cblp
times 7 dq 0
dd 64 ; lfanew

; PE Header
; Coff Header
db 80, 69, 0, 0 ; PE\0\0
dw 34404; ; AMD64
dw 2 ; # of sections
dd 0 ; timestamp (null)
dd 0 ; sym table ptr
dd 0 ; num of syms
dw 240 ; size of optional header
dw 47 ; flags

; Optional Header
dw 523 ; optional header magic (0b 02)
dw 0 ; linker version (null)
dd 0 ; code size (null)
dd 0 ; size of initialized data (null)
dd 0 ; size of uninitialized data (null)
dd sect0 ; entrypoint
dd 0 ; code base (null)
dq 4194304 ; image base
dd 1 ; section alignment
dd 1 ; file alignment
dd 0 ; os ver (null)
dd 0 ; image ver (null)
dd 4 ; subsystem ver
dd 0 ; win32 ver (res)
dd sect1end ; image size
dd sect0 ; header size
dd 0 ; checksum (null)
dw 2 ; subsystem (GUI)
dw 0 ; dll characteristics
dq 4096 ; stack reserve
dq 4096 ; stack commit
dq 65536 ; heap reserve
dq 0 ; heap commit
dd 0 ; loader flags (res)
dd 16 ; rva
dq 0 ; data dir 1
; data dir 2
dd sect1 ; rva
dd (sect1end-sect1) ; size
times 14 dq 0 ; other data directories

; sect 0 (code) header
dq 0 ; name
dd (sect0end-sect0) ; virtual size
dd sect0 ; virtual address
dd (sect0end-sect0) ; data size
dd sect0 ; data ptr
dq 0 ; reloc and ln ptrs
dd 0 ; reloc and ln nums
dd 0x60000020 ; characteristics

; sect 1 (data) header
dq 1 ; name
dd (sect1end-sect1) ; virtual size
dd sect1 ; virtual address
dd (sect1end-sect1) ; data size
dd sect1 ; data ptr
dq 0 ; reloc and ln ptrs
dd 0 ; reloc and ln nums
dd 0xc0000040 ; characteristics

BITS 64
; sect 0 (code)
sect0:
add rsp, 40
mov rcx, dword 0
mov rdx, dword 0
mov r8, dword (0x400000+msg)
mov r9, dword 0
mov qword [rsp + 32], 0
mov qword [rsp + 40], 0
call [(0x400000+thread)] ; REL_V_PTR = R_PTR + (-(VIRTUAL_ADDRESS) + DATA_PTR)
add rsp, 40
jmp sect0
msg:
add rsp, 40
mov rcx, dword 0
mov rdx, dword (0x400000+text) ; RVA = IMAGE_BASE + R_PTR
mov r8, dword (0x400000+title)
mov r9, dword 0
call [(0x400000+msgbox)]
add rsp, 40
ret
sect0end:

; sect 1 (data)
sect1:
dd iltmsgbox ; lookup rva
dd 0 ; timestamp
dd 0 ; forwarder chain
dd u32 ; name rva
dd msgbox ; iat rva
dd iltthread ; lookup rva
dd 0 ; timestamp
dd 0 ; forwarder chain
dd k32 ; name rva
dd thread ; iat rva
times 5 dd 0 ; null entry
u32 db "user32.dll", 0 ; dll name
k32 db "kernel32.dll", 0 ; dll name
msgbox dq hintmsgbox ; name rva
dq 0
iltmsgbox dq hintmsgbox ; name rva
dq 0
hintmsgbox dw 0 ; hint
db "MessageBoxA", 0 ; name string
thread dq hintthread ; name rva
dq 0
iltthread dq hintthread ; name rva
dq 0
hintthread dw 0 ; hint
db "CreateThread", 0 ; name string
text db "hello world", 0
title db "test", 0
sect1end:
