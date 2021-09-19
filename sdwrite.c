/*

	3.3V	WHITE
	GND	BLACK

	CS	YELLOW
	MOSI	ORANGE
	SCLK	RED
	MISO	BROWN
      ___________________________
     | NC CS DI V+ SCK GND DO NC |
     |                           |
     |                           |
     |                           |
    /                            |
   /    BOTTOM OF THE uSD CARD   |
  /                              |
 |                               |
 |                               |
 |                               |
 |                               |
 |                               |
 |                               |
 |                               |
 |                               |
 |                               |
 |_______________________________|

*/

#include <stdio.h>
#include <stdlib.h>
#include <sys/ioctl.h>
#include <linux/spi/spidev.h>
#include <wiringPi.h>
#include <wiringPiSPI.h>

unsigned char SPI_byte(unsigned char a) {
	wiringPiSPIDataRW(0, &a, 1);
	return a;
}

void CMD(unsigned char d0, unsigned char d1, unsigned char d2,unsigned char d3, unsigned char d4) {
	SPI_byte(0xFF);
	SPI_byte(d0);
	SPI_byte(d1);
	SPI_byte(d2);
	SPI_byte(d3);
	SPI_byte(d4);
	SPI_byte(0x95);
	SPI_byte(0xFF);
}

int main() {
	int i, j, k;

	wiringPiSetup();
	wiringPiSPISetup(0, 12000);
	pinMode(30, OUTPUT);

        digitalWrite(30, 1);
	for(i=0; i<10; i++)
		j = SPI_byte(0xFF);
        digitalWrite(30, 0);

	CMD(0x40, 0x00, 0x00, 0x00, 0x00);
	CMD(0x48, 0x00, 0x00, 0x01, 0xAA);
	for(;;) {
		CMD(0x77, 0, 0, 0, 0);
		CMD(0x69, 1<<6, 0, 0, 0);
		if(SPI_byte(0xFF)==0)
			break;
	}

	wiringPiSPISetup(0, 250e6/16);
	for(i=0; i<10; i++)
		j = SPI_byte(0xFF);

	CMD(0x58, 0x00, 0x00, 0x50, 0x00); // WRITE_SINGLE_BLOCK
	while(SPI_byte(0xFF)!=0);

	// Send token
	SPI_byte(0xFE);

	// Write the data
	for(i=0; i<512; i++)
		SPI_byte(i&255);

	// CRC bytes
	SPI_byte(0xFF);
	SPI_byte(0xFF);

	// Wait for write to finnish
	while(SPI_byte(0xFF)!=0xFF);
}
