WIFI_ESSID=""
WIFI_PASSWORD=""
EXEC_FILE="mqtt_display_node.lua"


wifi.setmode(wifi.STATION)
wifi.sta.config(WIFI_ESSID, WIFI_PASSWORD)
counts = 1

-- Check for 
tmr.alarm(0, 1*1000, tmr.ALARM_AUTO, 
	function() 
	if wifi.sta.getip()==nil then	
		print("waiting for wifi " .. counts)
		counts = counts + 1
		if counts > 25 then  -- timeout
			tmr.unregister(0)
			print("wifi timeout: removing init.lua and restarting...")
			file.remove("init.lua")
			node.restart()
		end
						
	else
		tmr.unregister(0)
		print('ip address', wifi.sta.getip()) 
		dofile(EXEC_FILE)
	end 
end
)

-- cancel init just in case it's porked
-- file.remove("init.lua")

