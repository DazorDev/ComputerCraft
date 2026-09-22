local len = 0
local configured_3f = nil
local clients = 0
local clients_done = 0
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
    local id, message = rednet.receive()
    local register_turtle_3f = (message == "configured")
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
  len = read("How long should the highway be: ")
  return nil
end
local function update()
  for i = 1, len do
    local id, message = rednet.receive("nether-highway")
    local is_client_3f = clients[id]
    if is_client_3f then
      clients_done = (clients + done + 1)
      if (clients == clients_done) then
        clients_done = 0
        rednet.broadcast("continue", "nether-highway")
      else
      end
    else
    end
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
