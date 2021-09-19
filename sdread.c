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

void CMD(unsigned char b1, unsigned char b2, unsigned char b3,unsigned char b4, unsigned char b5) {
//	unsigned char data[8] = {0xFF, b1, b2, b3, b4, b5, 0x95, 0xFF};
//	wiringPiSPIDataRW(0, data, 8);
	SPI_byte(0xFF);
	SPI_byte(b1);
	SPI_byte(b2);
	SPI_byte(b3);
	SPI_byte(b4);
	SPI_byte(b5);
	SPI_byte(0x95);
	SPI_byte(0xFF);
}

int main() {
	unsigned char data[512];
	int i, j, k;

	wiringPiSetup();
	wiringPiSPISetup(0, 12000);
	pinMode(30, OUTPUT);

        digitalWrite(30, 1);
	for(i=0; i<10; i++)
		SPI_byte(0xFF);
        digitalWrite(30, 0);

	CMD(0x40, 0x00, 0x00, 0x00, 0x00);
	CMD(0x48, 0x00, 0x00, 0x01, 0xAA);
	for(;;) {
		CMD(0x77, 0, 0, 0, 0);
		CMD(0x69, 0x40, 0, 0, 0);
		if(SPI_byte(0xFF)==0)
			break;
	}

	wiringPiSPISetup(0, 250e6/16); // even 250e6/4 seemed to work

        digitalWrite(30, 1);
	for(i=0; i<10; i++)
		SPI_byte(0xFF);
        digitalWrite(30, 0);

	CMD(0x51, 0x00, 0x00, 0x50, 0x00); // READ_SINGLE_BLOCK

	// Wait for token
	while(SPI_byte(0xFF)!=0xFE);

	// Read the data
        for(i=0; i<512; i++)
                data[i] = SPI_byte(0xFF);

	// for some reason this isn't reliable, but the alternative is
	//        wiringPiSPIDataRW(0, data, 512);

	// CRC bytes
	SPI_byte(0xFF);
	SPI_byte(0xFF);

	// Print the data
	for(i=0; i<512/16; i++) {
		for(j=0; j<16; j++)
			printf("%.2X ", data[j+i*16]);
		printf("\n");
	}

}
