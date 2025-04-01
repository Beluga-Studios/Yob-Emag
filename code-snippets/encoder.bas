symbol joyX = b1
symbol joyY = b2
symbol buttons = b3
symbol btn1 = bit0  ' Button 1
symbol btn2 = bit1  ' Button 2
symbol jPush = bit2 ' Joystick Push

' Example input values
joyX = 128   ' Joystick X position (0-255)
joyY = 200   ' Joystick Y position (0-255)
btn1 = 1     ' Button 1 pressed
btn2 = 0     ' Button 2 not pressed
jPush = 1    ' Joystick push pressed

' Pack button states into a single byte
buttons = (btn2 * 4) + (btn1 * 2) + (jPush * 1)

' Send 3 bytes (Joystick X, Y, and Buttons)
serout C.1, N2400, (joyX, joyY, buttons)
