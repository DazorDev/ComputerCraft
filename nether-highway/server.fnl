(var len 0)
(var configured? nil)
(var clients 0)
(var clients-done 0)

(fn wait-for-timer [timer-id]
  (var timer-done? nil)
  (while (not timer-done?)
    (let [(_ id) (os.pullEvent "timer")]
      (when (= id timer-id)
        (set timer-done? true)))))

(fn handle-timer []
  (let [timer (os.startTimer 1)]
    (wait-for-timer timer)
    (set configured? true)))

(fn handle-registering []
  (while (not configured?)
    (let [(id message) (rednet.receive)
          register-turtle? (= message :configured)]
      (print (string.format "Turtle: %s registered" id))
      (when register-turtle?
        (set clients (+ clients 1))))))

(fn init []
  (peripheral.find :modem rednet.open)
  (rednet.broadcast :setup :nether-highway)
  (parallel.waitForAny handle-timer handle-registering)
  (print "Finished registering")
  (print "Length of Highway: ")
  (set len (read))
  (print "Finished configuring"))

(fn update []
  (for [_ 1 len]
    (let [(id message) (rednet.receive "nether-highway")
          is-client? (. clients id)]
      (when is-client?
        (set clients-done (+ clients done 1))
        (when (= clients clients-done)
          (set clients-done 0)
          (rednet.broadcast "continue" :nether-highway))))))

(fn main []
  (init)
  (update))

(when (not ...)
  (main))
