PROG = blink
MCU = attiny2313
#MCU = attiny2313a
#MCU = attiny4313

CC = avr-gcc
CFLAGS = -Os -Wall $(POWER_MODE) \
	-mmcu=$(MCU) -funsigned-bitfields -fpack-struct -fshort-enums -std=gnu99

OBJCOPY = avr-objcopy

# This is correct for the $10 USB programmer from alldav.com
#AVRDUDE_PROGRAMMER = stk500v2
#AVRDUDE_PORT = -P /dev/ttyUSB0

# USBTiny programmer
AVRDUDE_PROGRAMMER = usbtiny
AVRDUDE_PORT =

# Avrdude flags
AVRDUDE_FLAGS = 

# Note that the default target just builds the hex file:
# use "make program" to burn it to the device
all : $(PROG).hex

$(PROG).o : $(PROG).c
	$(CC) $(CFLAGS) -c $(PROG).c -o $(PROG).o

$(PROG).elf : $(PROG).o
	$(CC) -mmcu=$(MCU) $(PROG).o -o $@ -Wl,-Map=$(PROG).map,--cref -lm

$(PROG).hex : $(PROG).elf
	$(OBJCOPY) -O ihex -R .eeprom $(PROG).elf $(PROG).hex

program : $(PROG).hex
	avrdude -p $(MCU) $(AVRDUDE_PORT) -c $(AVRDUDE_PROGRAMMER) $(AVRDUDE_FLAGS) -U flash:w:$(PROG).hex

clean :
	rm -f *.o *.elf *.hex *.map
