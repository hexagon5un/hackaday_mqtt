mqtt_address = "192.168.1.49"
temp_topic   = "home/outdoors/temperature"
humid_topic  = "home/outdoors/humidity"
status_topic = "home/outdoors/status"
ws2812b_pin  = 4  -- Pin D4 on my setup
status       = "on"
temp         = 20

-- Set up named client with 60 sec keepalive, 
-- no username/password, 
-- and a clean session each time
m = mqtt.Client("monitor", 60, "", "", 1) 
m:on("offline", function() print("mqtt offline");  end)

-- subscribe as soon as connected
m:on("connect", function() print("mqtt connected") subscribe_topics(m) end )

function subscribe_topics(client)
	client:subscribe(temp_topic,   0, subscribed(temp_topic))
	client:subscribe(humid_topic,  0, subscribed(humid_topic))
	client:subscribe(status_topic, 0, subscribed(status_topic))
end

function subscribed(topic)
	print("subscribed to " .. topic)
end

-- Deal with incoming messages
m:on("message", function(client, topic, data) handle_message(client, topic, data) end)

-- Print out all data & display temperature data 
function handle_message(client, topic, data) 
	print(topic .. ": " .. data)
	if topic == status_topic then
		status = data
	elseif topic == temp_topic then
		temp = data
	end
	-- and display
	if status == "on" or status == "o" then
		display_temp(temp)
	else
		display_off()
	end
end

-- Fancy temperature display! Blue-green-yellow-red fade.
function display_temp(data)
	data = tonumber(data)
	r = math.min(2*math.max(data-20, 0), 40)
	b = math.max(40-2*data, 0)
	g = 20 - math.min(math.abs(20 - data), 20)
	ws2812.writergb(ws2812b_pin, string.char(r, g, b))
end

function display_off()
	ws2812.writergb(ws2812b_pin, string.char(0, 0, 0))
end

m:connect(mqtt_address, 1883, 0, 1) 
