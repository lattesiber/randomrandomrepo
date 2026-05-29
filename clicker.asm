format PE GUI 4.0
entry start

include 'win32a.inc'

; --- AYARLAR ---
BUTON_X equ 400    ; Tıklanacak butonun X koordinatı (Piksel)
BUTON_Y equ 300    ; Tıklanacak butonun Y koordinatı (Piksel)

section '.data' data readable writeable
    active        db 0
    title_str     db 'Buton Clicker', 0
    start_msg     db 'Buton Clicker Hazir! (F3: Baslat/Durdur, ESC: Cikis)', 0

section '.code' code readable executable

start:
    invoke MessageBox, 0, start_msg, title_str, MB_OK

main_loop:
    invoke Sleep, 10
    
    ; ESC ile çıkış kontrolü
    invoke GetAsyncKeyState, VK_ESCAPE
    test ax, 0x8000
    jnz exit_program

    ; F3 ile açma/kapatma
    invoke GetAsyncKeyState, VK_F3
    test ax, 0x8000
    jz check_click
    
    invoke Sleep, 200
    xor [active], 1
    
check_click:
    cmp [active], 1
    jne main_loop

    ; 1. Fareyi butonun olduğu koordinata ışınla
    invoke SetCursorPos, BUTON_X, BUTON_Y
    
    ; 2. O noktada sol tıka bas
    invoke mouse_event, MOUSEEVENTF_LEFTDOWN, 0, 0, 0, 0
    invoke Sleep, 10
    
    ; 3. Sol tıkı bırak
    invoke mouse_event, MOUSEEVENTF_LEFTUP, 0, 0, 0, 0

    ; Tıklama hızı (milisaniye). İhtiyacına göre burayı değiştirebilirsin.
    invoke Sleep, 50 

    jmp main_loop

exit_program:
    invoke ExitProcess, 0

section '.idata' import data readable

  library kernel32, 'KERNEL32.DLL',\
          user32,   'USER32.DLL'

  import kernel32,\
         ExitProcess, 'ExitProcess',\
         Sleep,       'Sleep'

  import user32,\
         MessageBox,     'MessageBoxA',\
         GetAsyncKeyState, 'GetAsyncKeyState',\
         SetCursorPos,    'SetCursorPos',\
         mouse_event,     'mouse_event'
