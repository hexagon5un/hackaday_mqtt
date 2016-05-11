LUAFILES:= init.lua mqtt_temp_node.lua

PORT=/dev/ttyUSB0
BAUD=9600

flash: $(LUAFILES) 
	nodemcu-uploader -p $(PORT) -b $(BAUD) upload $^
	sleep 1
	echo "node.restart()" | cat > $(PORT)
	sleep 1
	pyterm $(PORT) $(BAUD)


