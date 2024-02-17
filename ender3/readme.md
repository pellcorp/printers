# Input Shaper

The instructions on this page to downgrade to buster work, however the baud rate was wrong, had to change to 115200

https://nate15329.com/klipper-input-shaper-w-arduino-nano/

avrdude -patmega328p -c arduino  -b115200 -P /dev/ttyUSB1 -v  -D -Uflash:w:out/klipper.elf.hex:i


https://www.reddit.com/r/klippers/comments/y82u4o/how_to_use_an_accelerometer_over_usb/

# Notifer

In order to be able to use fastmail with a private url, needed to use mode=ssl, this issue helped with figuring that out

https://github.com/caronc/apprise/pull/774

# Pressure Advance

https://ellis3dp.com/Print-Tuning-Guide/articles/index_pressure_advance.html

