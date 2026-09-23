local server = nil
local left_edge_3f = nil
local right_edge_3f = nil
local function turtle_block_3f()
  local res, block = turtle.inspect()
  return (res and ((block.name == "computercraft:turtle_normal") or (block.name == "computercraft:turtle_advanced")))
end
local function check_edges()
  turtle.turnLeft()
  if not turtle_block_3f() then
    left_edge_3f = true
  else
  end
  turtle.turnRight()
  turtle.turnRight()
  if not turtle_block_3f() then
    right_edge_3f = true
  else
  end
  return turtle.turnLeft()
end
local function init()
  peripheral.find("modem", rednet.open)
  local configured_3f = nil
  while not configured_3f do
    local id, msg = rednet.receive("nether-highway")
    local setup_3f = (msg == "setup")
    if setup_3f then
      rednet.send(id, "configured", "nether-highway")
      check_edges()
      server = id
      configured_3f = true
    else
    end
  end
  return nil
end
local function or_wait(func)
  while (turtle.getItemCount() == 0) do
    sleep(1)
  end
  return func()
end
local function step()
  turtle.dig()
  turtle.digUp()
  or_wait(turtle.placeDown)
  if left_edge_3f then
    turtle.turnLeft()
    or_wait(turtle.place)
    turtle.turnRight()
  else
  end
  if right_edge_3f then
    turtle.turnRight()
    or_wait(turtle.place)
    turtle.turnLeft()
  else
  end
  or_wait(turtle.forward)
  return rednet.send(server, "done", "nether-highway")
end
local function main()
  init()
  local running_3f = true
  while running_3f do
    local id, msg = rednet.receive("nether-highway")
    local server_3f = (id == server)
    if server_3f then
      if (msg == "done") then
        running_3f = nil
      elseif (msg == "continue") then
        step()
      else
      end
    else
    end
  end
  return peripheral.find("modem", rednet.open)
end
if not ... then
  return main()
else
  return nil
end
