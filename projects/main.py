import shrike
from machine import Pin
from time import sleep_ms
import os


# =================================================
# ROTARY ENCODER PIN CONFIGURATION
# =================================================
# EC11 rotary encoder module:
# CLK -> GP2
# DT  -> GP3
# SW  -> GP4
# +   -> 3V3
# GND -> GND

ENC_A_PIN = 7       # CLK
ENC_B_PIN = 6       # DT
ENC_SW_PIN = 5      # SW


# =================================================
# FPGA PROGRAM LIST
# =================================================

PROGRAMS = [
    ("Blink", "blink.bin"),
    ("RGB LED", "rgb.bin"),
    ("Gates", "gates.bin"),
    ("PWM", "pwm.bin")
]

STATE_FILE = "last_program.txt"


# =================================================
# PIN SETUP
# =================================================

enc_a = Pin(ENC_A_PIN, Pin.IN, Pin.PULL_UP)
enc_b = Pin(ENC_B_PIN, Pin.IN, Pin.PULL_UP)
enc_sw = Pin(ENC_SW_PIN, Pin.IN, Pin.PULL_UP)


# =================================================
# FILE AND STATE FUNCTIONS
# =================================================

def file_exists(filename):
    try:
        os.stat(filename)
        return True
    except OSError:
        return False


def load_last_index():
    try:
        with open(STATE_FILE, "r") as f:
            index = int(f.read().strip())

        if 0 <= index < len(PROGRAMS):
            return index

    except Exception:
        pass

    return 0


def save_last_index(index):
    try:
        with open(STATE_FILE, "w") as f:
            f.write(str(index))

        print("Saved last state:", PROGRAMS[index][1])

    except Exception as e:
        print("Could not save state:", e)


# =================================================
# FPGA FLASH FUNCTION
# =================================================

def flash_program(index):
    name, filename = PROGRAMS[index]

    if not file_exists(filename):
        print("File missing:", filename)
        return False

    print()
    print("Flashing:", filename)

    try:
        shrike.reset()
        sleep_ms(100)

        shrike.flash(filename)

        save_last_index(index)

        print("Done:", filename)
        return True

    except Exception as e:
        print("Flash failed:", e)
        return False


# =================================================
# EC11 ROTARY ENCODER READER
# =================================================

encoder_last_state = (enc_a.value() << 1) | enc_b.value()
encoder_accumulator = 0


def read_encoder_step():
    """
    Returns:
       1  = clockwise
      -1  = counter-clockwise
       0  = no completed step
    """

    global encoder_last_state
    global encoder_accumulator

    a = enc_a.value()
    b = enc_b.value()

    current_state = (a << 1) | b

    if current_state != encoder_last_state:
        transition = (encoder_last_state << 2) | current_state

        # Direction 1
        if transition in (
            0b0001,
            0b0111,
            0b1110,
            0b1000
        ):
            encoder_accumulator += 1

        # Direction 2
        elif transition in (
            0b0010,
            0b1011,
            0b1101,
            0b0100
        ):
            encoder_accumulator -= 1

        encoder_last_state = current_state

        # EC11 usually gives 4 transitions per physical click
        if encoder_accumulator >= 4:
            encoder_accumulator = 0
            return 1

        elif encoder_accumulator <= -4:
            encoder_accumulator = 0
            return -1

    return 0


# =================================================
# ENCODER SWITCH FUNCTION
# =================================================

def switch_pressed():
    if enc_sw.value() == 0:
        sleep_ms(30)

        if enc_sw.value() == 0:
            while enc_sw.value() == 0:
                sleep_ms(10)

            sleep_ms(30)
            return True

    return False


# =================================================
# STARTUP
# =================================================

selected = load_last_index()

print()
print("=================================")
print("Shrike-Lite FPGA Program Selector")
print("=================================")
print("Last saved program:", PROGRAMS[selected][1])

# Automatically flash last saved program on boot
flash_program(selected)

print()
print("Rotate encoder to select program.")
print("Press encoder switch to flash and save.")
print("Current selection:", PROGRAMS[selected][1])


# =================================================
# MAIN LOOP
# =================================================

while True:
    step = read_encoder_step()

    if step != 0:
        selected = (selected + step) % len(PROGRAMS)

        print("Selected:", PROGRAMS[selected][1])
        sleep_ms(80)

    if switch_pressed():
        print("Confirmed:", PROGRAMS[selected][1])
        flash_program(selected)

    sleep_ms(5)
