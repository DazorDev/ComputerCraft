(var server nil)
(var left-edge? nil)
(var right-edge? nil)
(fn turtle-block? []
  (let [(res block) (turtle.inspect)]
    (and res (or (= block.name "computercraft:turtle_normal")
                 (= block.name "computercraft:turtle_advanced")))))

(fn check-edges []
  (turtle.turnLeft)
  (when (not (turtle-block?))
    (set left-edge? true))
  (turtle.turnRight)
  (turtle.turnRight)
  (when (not (turtle-block?))
    (set right-edge? true))
  (turtle.turnLeft))

(fn init []
  (peripheral.find :modem rednet.open)
  (var configured? nil)
  (while (not configured?)
    (let [(id msg) (rednet.receive :nether-highway)
          setup? (= msg :setup)]
      (when setup?
        (rednet.send server :configured :nether-highway)
        (check-edges)
        (set server id)
        (set configured? true)))))

(fn finished-step []
  (rednet.send server "done" "nether-highway"))

(fn step []
  (turtle.dig)
  (turtle.digUp)
  (when left-edge?
    (turtle.turnLeft)
    (turtle.place)
    (turtle.turnRight))
  (when right-edge?
    (turtle.turnRight)
    (turtle.place)
    (turtle.turnLeft))
  (turtle.forward)
  (finished-step))

(fn main []
  (init)
  (var running? true)
  (while running?
    (let [(id msg) (rednet.receive "nether-highway")
          server? (= id server)]
      (when server?
        (case msg
          :done (set running? nil)
          :continue (step)))))
 (peripheral.find :modem rednet.open))

(when (not ...)
  (main))
