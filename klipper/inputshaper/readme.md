The instructions on this page to downgrade to buster work, however the baud rate was wrong, had to change to 115200

avrdude -patmega328p -c arduino  -b115200 -P /dev/ttyUSB1 -v  -D -Uflash:w:out/klipper.elf.hex:i


https://www.reddit.com/r/klippers/comments/y82u4o/how_to_use_an_accelerometer_over_usb/

