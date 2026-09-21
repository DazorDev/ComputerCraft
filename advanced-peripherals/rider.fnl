(local movement {:forward turtle.forward
                 :back turtle.back
                 :left turtle.turnLeft
                 :right turtle.turnRight
                 :up turtle.up
                 :down turtle.down})
(var running true)
(var state nil)

(fn handle-input [saddle]
  (while (saddle.hasRider)
    (let [(event direction pressed) (os.pullEvent "saddle_control")
          new-state (and pressed direction)]
      (set state new-state))))

(fn update [saddle]
  (while (saddle.hasRider)
    (let [movement-func (. movement state)]
      (when movement-func
        (movement-func)))))

(fn init [saddle]
  (while (not (saddle.hasRider))
    (saddle.capture)))

(fn main []
  (let [saddle (peripheral.wrap "left")]
    (init saddle)
    (parallel.waitForAll (fn [] (handle-input saddle))
                         (fn [] (update saddle)))))

(main)
