#define F_CPU 1000000 // use internal oscillator, set to 1 MHz
#include <avr/io.h>
#include <util/delay.h>

int main(void) {
	DDRD = 0xFF;
	for (;;) {
		PORTD ^= 1;
		_delay_ms(500);
	}
}
