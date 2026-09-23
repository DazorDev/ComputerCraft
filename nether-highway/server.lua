local len = 0
local configured_3f = nil
local clients = 0
local function wait_for_timer(timer_id)
  local timer_done_3f = nil
  while not timer_done_3f do
    local _, id = os.pullEvent("timer")
    if (id == timer_id) then
      timer_done_3f = true
    else
    end
  end
  return nil
end
local function handle_timer()
  local timer = os.startTimer(1)
  wait_for_timer(timer)
  configured_3f = true
  return nil
end
local function handle_registering()
  while not configured_3f do
    local id, message = rednet.receive("nether-highway")
    local register_turtle_3f = (message == "configured")
    print(string.format("Turtle: %s registered", id))
    if register_turtle_3f then
      clients = (clients + 1)
    else
    end
  end
  return nil
end
local function init()
  peripheral.find("modem", rednet.open)
  rednet.broadcast("setup", "nether-highway")
  parallel.waitForAny(handle_timer, handle_registering)
  print("Finished registering")
  print("Length of Highway: ")
  len = read()
  return print("Finished configuring")
end
local function update()
  for _ = 1, len do
    for _0 = 1, clients do
      local _1, _2 = rednet.receive("nether-highway")
      __fnl_global__clients_2ddone = (clients + done + 1)
    end
    rednet.broadcast("continue", "nether-highway")
  end
  return nil
end
local function main()
  init()
  return update()
end
if not ... then
  return main()
else
  return nil
end
