peripheral.find("modem", rednet.open)
local number = nil
local msg = nil
repeat
   msg = read()
   number = tonumber(msg)
until number
rednet.broadcast(number, "Mining Operation")
