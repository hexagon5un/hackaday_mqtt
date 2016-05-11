LUAFILES:= init.lua mqtt_display_node.lua

PORT=/dev/ttyUSB0
BAUD=9600
#BAUD=115200

flash: $(LUAFILES) 
	nodemcu-uploader -p $(PORT) -b $(BAUD) upload $^
	sleep 1
	echo "node.restart()" | cat > $(PORT)
	sleep 1
	pyterm $(PORT) $(BAUD)

