LUAFILES:= init.lua mqtt_display_node.lua

PORT=/dev/ttyUSB0
BAUD=9600

all: flash restart term

flash: $(LUAFILES) 
	nodemcu-uploader -p $(PORT) -b $(BAUD) upload $^

restart:
	echo "node.restart()" | cat > $(PORT)

term:
	pyterm $(PORT) $(BAUD)

