## MQTT & DHT sensor build:  http://nodemcu-build.com/

This was built against the master branch and includes the following modules:
dht, file, gpio, mqtt, node, tmr, uart, wifi, ws2812.

## RUNME

If you've got `esptool.py` installed, you can simply:
`esptool.py --port /dev/ttyUSB0 --baud 57600 write_flash 0x00000 nodemcu-master-9-modules-2016-05-05-20-09-20-integer.bin`

