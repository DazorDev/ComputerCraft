local turtle_movement = {
   forward=turtle.forward,
   left=turtle.turnLeft,
   right=turtle.turnRight,
   back=turtle.back,
   up=turtle.up,
   down=turtle.down
}

local saddle = peripheral.wrap("left")
local success, msg = nil
repeat
   success, msg = saddle.capture()
until success

local event, direction, pressed
local state = "idle"
while true do 
    _, direction, pressed = os.pullEvent('saddle_control')
    movement = turtle_movement[direction]
    if pressed == "released" then
       state = "idle"
       continue
    else
       state = direction
       if movement then
	  movement()
       end
    end
end
