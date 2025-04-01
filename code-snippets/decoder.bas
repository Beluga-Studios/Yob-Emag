symbol joyX = b1
symbol joyY = b2
symbol buttons = b3
symbol btn1 = bit0
symbol btn2 = bit1
symbol jPush = bit2

' Receive the 3-byte packet
serin C.1, N2400, joyX, joyY, buttons

' Extract buttons
btn1 = buttons & %00000010
btn2 = buttons & %00000100
jPush = buttons & %00000001

' Shift bits down to 1 or 0
btn1 = btn1 / 2
btn2 = btn2 / 4
