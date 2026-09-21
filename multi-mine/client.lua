peripheral.find("modem", rednet.open)
local length = nil
repeat
   id, message = rednet.receive("Mining Operation")
   length = tonumber(message)
until length
shell.run("tunnel.lua", message)
peripheral.find("modem", rednet.close)
