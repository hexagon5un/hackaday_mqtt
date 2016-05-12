WIFI_ESSID    = ""
WIFI_PASSWORD = ""
EXEC_FILE     = "mqtt_display_node.lua"
timeout       = 15

wifi.setmode(wifi.STATION)
wifi.sta.config(WIFI_ESSID, WIFI_PASSWORD)

function print_wifi_status(status)
	if status == wifi.STA_WRONGPWD then
		print("wrong passsword")
	elseif status == wifi.STA_APNOTFOUND then
		print("can't find AP")
	elseif status == wifi.STA_FAIL then
		print("failed")
	elseif status == wifi.STA_GOTIP then 
		print("got IP")
	end
end

-- Loop until WiFi configured, then branch
-- If there's a configuration problem with AP name or PW, 
--   delete the init.lua file and reboot.
counts  = 1
tmr.alarm(0, 1*1000, tmr.ALARM_AUTO, function() 
	status = wifi.sta.status() 
	print_wifi_status(status)
	if (status == wifi.STA_WRONGPWD or status == wifi.STA_APNOTFOUND) then
		print("wifi incorrectly configured: removing init.lua")
		file.remove("init.lua")
		tmr.unregister(0)
		node.restart()
	end
	if status ~= wifi.STA_GOTIP then	
		print("waiting for wifi " .. counts)
		counts = counts + 1
		if counts > timeout then  -- timeout
			tmr.unregister(0)
			print("failed to acquire IP address, restarting")
			node.restart()
		end

	else
		tmr.unregister(0)
		print(wifi.sta.getip()) 
		dofile(EXEC_FILE)
	end 
end
)

-- cancel init just in case it's porked
-- file.remove("init.lua")


