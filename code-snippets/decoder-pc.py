import serial

ser = serial.Serial('COM3', 2400)  # Adjust COM port

while True:
    data = ser.read(3)  # Read 3 bytes
    if len(data) == 3:
        joyX = data[0]
        joyY = data[1]
        buttons = data[2]

        # Extract button states
        btn1 = (buttons & 0b00000010) >> 1
        btn2 = (buttons & 0b00000100) >> 2
        jPush = (buttons & 0b00000001)

        print(f"Joystick X: {joyX}, Y: {joyY}")
        print(f"Button 1: {btn1}, Button 2: {btn2}, Joystick Push: {jPush}")
