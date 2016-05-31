mqtt_address  = "192.168.1.49"
client_id     = "power_test"
memento_topic = "home/powertest/memento"
command_topic = "home/powertest/command"
status_topic  = "home/powertest/status"

boot_state    = nil
sleep_seconds = 10

m = mqtt.Client(client_id, 60, "", "", 1) 

-- subscribe as soon as connected
m:on("connect", function() 
	print("mqtt connected") 
	m:subscribe(memento_topic, 0)
	m:subscribe(command_topic, 0)
end )

-- Deal with incoming messages
m:on("message", function(client, topic, data) 
	handle_message(client, topic, data) 
end)

-- Shortcuts
function send_status(message)
	m:publish(status_topic, message, 0, 0)
end

function send_memento(message)
	-- retained
	m:publish(memento_topic, message, 0, 1)
end

-- Retrieve / set wakeup status from memento topic
-- Respond to commands on command topic
function handle_message(client, topic, data) 
	if topic == memento_topic then 
		if boot_state == nil then
			if data == "bootup" then 
				boot_state = "reset"
			elseif data == "sleep" then
				boot_state = "sleep"
			end
			send_memento("bootup")
			send_status("boot state: " .. boot_state)
		end
	elseif topic == command_topic then
		if data == "sleep" then
			go_to_sleep()
		elseif data == "restart" then
			node.restart()
		end
	else
		print(topic .. ": " .. data)
	end
end

-- Verbose sleeping
function go_to_sleep()
	send_memento("sleep")
	send_status("going to sleep now...")
	-- this delay to make sure above messages get sent
	tmr.alarm(2, 1000, tmr.ALARM_SINGLE, function() 
		node.dsleep(sleep_seconds*1000000) 
	end)
end

-- Connect up and do something, so you know it's not sleeping
m:connect(mqtt_address, 1883, 0, 1) 
tmr.alarm(1, 10*1000, tmr.ALARM_AUTO, function() 
	send_status("still awake") 
end)

