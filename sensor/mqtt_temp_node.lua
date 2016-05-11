mqtt_address     = "192.168.1.49"
temp_topic       = "home/outdoors/temperature"
humid_topic      = "home/outdoors/humidity"
status_topic     = "home/outdoors/status"
update_frequency = 10 -- sec
dht_pin          = 4  -- Pin D4 on my setup

-- Set up named client with 60 sec keepalive, 
-- no username/password, 
-- and a clean session each time
m = mqtt.Client("outdoors", 60, "", "", 1) 

function subscribed(topic)
	print("subscribed to " .. topic)
end

function subscribe_topics(client)
	client:subscribe(temp_topic,   0, subscribed(temp_topic))
	-- client:subscribe(humid_topic,  0, subscribed(humid_topic))
	-- client:subscribe(status_topic, 0, subscribed(status_topic))
end

function handle_message(client, topic, data) 
	if topic == temp_topic then
		display_temp(data)
	end
end
function display_temp(data)
	print("temp: " .. data)
end


-- subscribe as soon as connected
m:on("connect", function() print("mqtt connected") end )
m:on("offline", function() print("mqtt offline");  end)
m:on("message", function(client, topic, data) handle_message(client, topic, data) end)

m:connect(mqtt_address, 1883, 0, 1) 

function publish_temp_humidity(client)
	status, temp, humi, temp_dec, humi_dec = dht.read(dht_pin)
	if status == dht.OK then
		m:publish(temp_topic, temp, 0, 0)
		m:publish(humid_topic, humi, 0, 0)
	elseif status == dht.ERROR_CHECKSUM then
		print( "DHT Checksum error." )
	elseif status == dht.ERROR_TIMEOUT then
		print( "DHT timed out." )
	end
end

tmr.alarm(1, update_frequency*1000, tmr.ALARM_AUTO, function() publish_temp_humidity(m) end)



-- Set up periodic connections / display updates
-- tmr.alarm(1, 5*1000, tmr.ALARM_AUTO, function() m:publish(status_topic, "ping", 0, 0) end)
