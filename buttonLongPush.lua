push_threshold = 1000
--has to be pressed for more than 1000ms as a positive detection
tmr_interval = 100
count_threshold = math.floor(push_threshold/tmr_interval)
--print(count_threshold)
buttonPin = 7
gpio.mode(buttonPin, gpio.INPUT)
gpio.write(buttonPin, gpio.LOW)
pushed_count = 0
pushed = 0
long_pushed = 0
mytimerPush = tmr.create()
mytimerRelease = tmr.create()

mytimerPush:register(tmr_interval, 1, function() 
if gpio.read(buttonPin)==1  then 
   pushed_count = pushed_count+1
   pushed=1
   print(pushed_count)
end 
end)

mytimerRelease:register(tmr_interval, 1, function() 
if gpio.read(buttonPin)==0 and pushed==1 then
    if pushed_count>=count_threshold then
        pushed_count = 0
        pushed = 0
        long_pushed=1
        print("Long Button Push detected")
    else
    pushed_count = 0
    long_pushed=0
    end
end 
end)

mytimerPush:start()
mytimerRelease:start()
--There are pitfalls in this implementation.
--Can you think of a better alternative to solve the problem?
