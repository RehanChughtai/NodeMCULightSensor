pinADC = 0
pinLED = 2
--A0 pin
mytimer = tmr.create()
pwm.setup(pinLED, 500, 1023)
pwm.start(pinLED)

mytimer:register(200, 1, function() 
    dc = adc.read(pinADC)
    --the maximum for NodeMCU ADC is 1.1v
    --it is a 10-bit ADC, can represent 0-1023
    --1023 represent 1.1v or larger
    print(dc)
    pwm.setduty(pinLED, math.floor(dc/2))
end
)

mytimer:start()
--Please identify the limitation of this implementation
--And propose your own solution.
