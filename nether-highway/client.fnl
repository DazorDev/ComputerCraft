(var server nil)
(var left-edge? nil)
(var right-edge? nil)
(fn turtle-block? []
  (let [(res block) (turtle.inspect)]
    (and res (or (= block.name "computercraft:turtle_normal")
                 (= block.name "computercraft:turtle_advanced")))))

(fn edge-turtle? []
  (turtle.turnLeft)
  (when (not (turtle-block?))
    (set left-edge? true))
  (turtle.turnRight)
  (turtle.turnRight)
  (when (not (turtle-block?))
    (set right-edge? true)))

(fn init []
  (var configured? nil)
  (while (not configured?)
    (peripheral.find :modem rednet.open)
    (let [(id msg) (rednet.receive :nether-highway)
          setup? (= msg :setup)]
      (when setup?
        (edge-turtle?)
        (set configured? true)))
    (rednet.send server :configured :nether-highway)))

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
  (var running? true)
  (while running?
    (let [(id msg) (rednet.receive "nether-highway")
          server? (= id server)]
      (when server?
        (case msg
          :done (set running? nil)
          :continue (step))))))
(when (not ...)
  (main))
