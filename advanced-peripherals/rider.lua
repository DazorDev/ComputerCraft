local movement = {forward = turtle.forward, back = turtle.back, left = turtle.turnLeft, right = turtle.turnRight, up = turtle.up, down = turtle.down}
local running = true
local state = nil
local function handle_input(saddle)
  while saddle.hasRider() do
    local event, direction, pressed = os.pullEvent("saddle_control")
    local new_state = (pressed and direction)
    state = new_state
  end
  return nil
end
local function update(saddle)
  while saddle.hasRider() do
    local movement_func = movement[state]
    if movement_func then
      movement_func()
    else
    end
  end
  return nil
end
local function init(saddle)
  while not saddle.hasRider() do
    saddle.capture()
  end
  return nil
end
local function main()
  local saddle = peripheral.wrap("left")
  init(saddle)
  local function _2_()
    return handle_input(saddle)
  end
  local function _3_()
    return update(saddle)
  end
  return parallel.waitForAll(_2_, _3_)
end
return main()
