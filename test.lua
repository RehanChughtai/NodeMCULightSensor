pinADC = 0
pinLED = 2
buttonPin = 3
gpio.mode(buttonPin, gpio.INPUT)
gpio.write(buttonPin, gpio.LOW)
gpio.mode(pinLED, gpio.OUTPUT)
pushed = 0
mytimer = tmr.create()

pwm.setup(pinLED, 500, 1023)
pwm.start(pinLED)

    mytimer:register(100, 1, function() 
    if gpio.read(buttonPin)==1 and pushed then 
       pushed = 1
       gpio.write(pinLED, gpio.LOW)
       dc = adc.read(pinADC)
       print(dc)
       pwm.setduty(pinLED, math.floor(dc/2))
    end 
    end)

mytimer:start()
