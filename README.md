# FPGA-Rubiks-Cube-State-Input
Touch Screen LCD quartus project for inputting the state of a Rubik's Cube for use in a Rubik's Cube solving robot. Designed for the Altera Max 10 DE10 Lite development board with an MSP2807 tft screen.

The screen has two spi controllers, one for the LCD, the other for the touch screen. The LCD uses an ILI9341, and the touch screen uses an XPT2046.

## Building
 - Clone project and open file in quartus and compile
 - Connect screen as shown in this table:

| Screen Pin | FPGA Pin | FPGA GPIO # |
| ---------- | -------- | ----------- |
| VCC        | 3.3V     | 29          |
| GND        | GND      | 30          |
| CS         | Y7       | 28          |
| RST        | AA8      | 27          |
| DC/RS      | AA9      | 25          |
| SDI (MOSI) | Y8       | 26          |
| SCK        | AB10     | 23          |
| LED        | AA10     | 24          |
| SDO (MISO) | AB11     | 21          |
| T_CLK      | W11      | 22          |
| T_CS       | AB12     | 19          |
| T_DIN      | Y11      | 20          |
| T_DO       | W12      | 17          |
| T_IRQ      | AB13     | 18          |


## Images:

Here is the default state of the cube:
![Solved State](media/Solved_State.jpg)

Here is the mixed up state:
![Mixed State](media/Working_LCD.jpg)

Here is the colour picker interface:
![Colour Picker](media/Colour_Picker_Interface.jpg)

Thanks to [https://github.com/thekroko/ili9341_fpga](https://github.com/thekroko/ili9341_fpga) for LCD SPI interface help.