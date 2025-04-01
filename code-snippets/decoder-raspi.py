import RPi.GPIO as GPIO
import time

# GPIO Setup
GPIO.setmode(GPIO.BCM)
DATA_PIN = 17  # GPIO pin for receiving data
GPIO.setup(DATA_PIN, GPIO.IN)

def read_byte():
    """Reads a single byte from the GPIO pin bit by bit."""
    byte_value = 0
    for i in range(8):  # Read 8 bits
        while GPIO.input(DATA_PIN) == 0:  # Wait for HIGH signal (bit start)
            pass
        time.sleep(0.001)  # Short delay for stability
        bit = GPIO.input(DATA_PIN)
        byte_value = (byte_value << 1) | bit  # Shift and add bit
        time.sleep(0.001)  # Allow next bit time to arrive
    return byte_value

while True:
    # Read 3 bytes: Joystick X, Joystick Y, and Packed Buttons
    joyX = read_byte()
    joyY = read_byte()
    buttons = read_byte()

    # Extract button states
    btn1 = (buttons & 0b00000010) >> 1
    btn2 = (buttons & 0b00000100) >> 2
    jPush = (buttons & 0b00000001)

    # Print values, replace with what you want
    print(f"Joystick X: {joyX}, Joystick Y: {joyY}")
    print(f"Button 1: {btn1}, Button 2: {btn2}, Joystick Push: {jPush}")
    
    time.sleep(0.1)  # Small delay to avoid CPU overload
