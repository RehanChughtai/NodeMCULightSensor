--    Author : Akshai M <akshaim.in>
wifi.setmode(wifi.STATION)
station_cfg={}
station_cfg.ssid="Wifi Name" 
station_cfg.pwd="Password"
station_cfg.save=false
wifi.sta.config(station_cfg)
mytimer=tmr.create()
mytimer:register(3000, 1, function() 
   if wifi.sta.getip()==nil then
        print("Connecting to AP...\n")
   else
        ip, nm, gw=wifi.sta.getip()
        print("IP Info: \nIP Address: ",ip)
        print("Netmask: ",nm)
        print("Gateway Addr: ",gw,"\n")
   end 
end)
mytimer:start()


LED1 = 1
LED2 = 4
gpio.mode(LED1, gpio.OUTPUT)
gpio.mode(LED2, gpio.OUTPUT)
if (srv ~= nil) then
    -- shut down old server instance
    srv:close()
else
    srv=net.createServer(net.TCP)
end
srv:listen(80,function(conn)
    conn:on("receive", function(client,request)
        local buf = ""
        local _, _, method, path, vars = string.find(request, "([A-Z]+) (.+)?(.+) HTTP")
        if(method == nil)then
            _, _, method, path = string.find(request, "([A-Z]+) (.+) HTTP")
        end
        local _GET = {}
        if (vars ~= nil)then
            for k, v in string.gmatch(vars, "(%w+)=(%w+)&*") do
                _GET[k] = v
            end
        end
        buf = buf.."<h1>NodeMCU TCP - Web Server</h1>"
        buf = buf.."<p>LED 1 - LED Connected to D1 <a href=\"?pin=ON1\"><button>ON</button></a>&nbsp;<a href=\"?pin=OFF1\"><button>OFF</button></a></p>"
        buf = buf.."<p>LED 2 - Onboard Blue <a href=\"?pin=ON2\"><button>ON</button></a>&nbsp;<a href=\"?pin=OFF2\"><button>OFF</button></a></p>"
        local _on,_off = "",""
        if(_GET.pin == "ON1")then
              gpio.write(LED1, gpio.HIGH)
        elseif(_GET.pin == "OFF1")then
              gpio.write(LED1, gpio.LOW)
        elseif(_GET.pin == "ON2")then
              gpio.write(LED2, gpio.LOW)
        elseif(_GET.pin == "OFF2")then
              gpio.write(LED2, gpio.HIGH)
        end
        client:send(buf)
    end)
    conn:on("sent", function(client)
        client:close()
    end)
end)
