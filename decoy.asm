; DOS Header
db 77, 90 ; MZ
dw 144 ; cblp
times 7 dq 0
dd 64 ; lfanew

; PE Header
; Coff Header
db 80, 69, 0, 0 ; PE\0\0
dw 332; ; Intel x86
dw 1 ; # of sections
dd 0 ; timestamp (null)
dd 0 ; sym table ptr (null)
dd 0 ; num of syms (null)
dw 224 ; size of optional header
dw 271 ; flags

; Optional Header
dw 267 ; optional header magic (0b 01)
dw 0 ; linker version (null)
dd 0 ; code size (null)
dd 0 ; size of initialized (null)
dd 0 ; uninitialized data (null)
dd sect0 ; entrypoint
dd 0 ; code base (null)
dd 0 ; data base (null)
dd 4194304 ; image base
dd 1 ; section alignment
dd 1 ; file alignment
dd 0 ; os ver (null)
dd 0 ; image ver (null)
dd 4 ; subsystem ver
dd 0 ; win32 ver (res)
dd sect0end ; image size
dd sect0 ; header size
dd 0 ; checksum (null)
dw 2 ; subsystem (GUI)
dw 0 ; dll characteristics
dd 4096 ; stack reserve
dd 4096 ; stack commit
dd 65536 ; heap reserve
dd 0 ; heap commit
dd 0 ; loader flags (res)
dd 16 ; rva
times 16 dq 0 ; data directories

; sect 0 (code) header
dq 0 ; name
dd (sect0end-sect0) ; virtual size
dd sect0 ; virtual address
dd (sect0end-sect0) ; data size
dd sect0 ; data ptr
dq 0 ; reloc and ln ptrs
dd 0 ; reloc and ln nums
dd 1610612768 ; characteristics

; sect 0 (code)
sect0:
jmp $
sect0end: