local server = nil
local left_edge_3f = nil
local right_edge_3f = nil
local function turtle_block_3f()
  local res, block = turtle.inspect()
  return (res and ((block.name == "computercraft:turtle_normal") or (block.name == "computercraft:turtle_advanced")))
end
local function edge_turtle_3f()
  turtle.turnLeft()
  if not turtle_block_3f() then
    left_edge_3f = true
  else
  end
  turtle.turnRight()
  turtle.turnRight()
  if not turtle_block_3f() then
    right_edge_3f = true
    return nil
  else
    return nil
  end
end
local function init()
  peripheral.find("modem", rednet.open)
  local configured_3f = nil
  while not configured_3f do
    peripheral.find("modem", rednet.open)
    do
      local id, msg = rednet.receive("nether-highway")
      local setup_3f = (msg == "setup")
      if setup_3f then
        edge_turtle_3f()
        configured_3f = true
      else
      end
    end
    rednet.send(server, "configured", "nether-highway")
  end
  return nil
end
local function finished_step()
  return rednet.send(server, "done", "nether-highway")
end
local function step()
  turtle.dig()
  turtle.digUp()
  if left_edge_3f then
    turtle.turnLeft()
    turtle.place()
    turtle.turnRight()
  else
  end
  if right_edge_3f then
    turtle.turnRight()
    turtle.place()
    turtle.turnLeft()
  else
  end
  turtle.forward()
  return finished_step()
end
local function main()
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
  return nil
end
if not ... then
  return main()
else
  return nil
end
