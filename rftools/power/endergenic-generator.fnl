;; (fn main []
;;   (print "Starting Setup")
;;   (print "Preparing Second Generator")
;;   (peripheral.call (. generator-data 2 :name) :setOutput :front true)
;;   (sleep 0.1)
;;   (peripheral.call (. generator-data 2 :name) :setOutput :front false)
;;   (sleep 0.5)
;;   (print "Launching pearl")
;;   (peripheral.call pearl-injector.name :setOutput pearl-injector.side true)
;;   (sleep 0.1)
;;   (peripheral.call pearl-injector.name :setOutput pearl-injector.side false)
;;   (print "Completed Setup")
;;   (sleep 1)
;;   ;; (while true 
;;   ;;   (print "Preparing Second Generator")
;;   ;;   (peripheral.call (. generator-data 2 :name) :setOutput :front true)
;;   ;;   (sleep 0.1)
;;   ;;   (peripheral.call (. generator-data 2 :name) :setOutput :front false)
;;   ;;   (print "Prepared, Waiting")
;;   ;;   (sleep 0.5)
;;   ;;   (print "Launching from first generator")
;;   ;;   (peripheral.call (. generator-data 1 :name) :setOutput :front true)
;;   ;;   (sleep 0.1)
;;   ;;   (peripheral.call (. generator-data 1 :name) :setOutput :front false)
;;   ;;   (print "Launched")
;;   ;;   (print "Preparing Third Generator")
;;   ;;   (peripheral.call (. generator-data 3 :name) :setOutput :front true)
;;   ;;   (sleep 0.1)
;;   ;;   (peripheral.call (. generator-data 3 :name) :setOutput :front false)
;;   ;;   (print "Pepared, Waiting")
;;   ;;   (sleep 0.5)
;;   ;;   (print "Launching from second generator")
;;   ;;   (peripheral.call (. generator-data 2 :name) :setOutput :front true)
;;   ;;   (sleep 0.1)
;;   ;;   (peripheral.call (. generator-data 2 :name) :setOutput :front false)

;;   ;;   (print "Preparing first Generator")
;;   ;;   (peripheral.call (. generator-data 1 :name) :setOutput :front true)
;;   ;;   (sleep 0.1)
;;   ;;   (peripheral.call (. generator-data 1 :name) :setOutput :front false)
;;   ;;   (sleep 0.5)
;;   ;;   (peripheral.call (. generator-data 3 :name) :setOutput :front true)
;;   ;;   (sleep 0.1)
;;   ;;   (peripheral.call (. generator-data 3 :name) :setOutput :front false))
;;   )

(macro redstone-relay [name side]
  (assert-compile name "Name must be specified")
  (assert-compile side "Side must be specified")
  {: name : side})

(macro ticks->time [number]
  (* number 0.05))

(macro pulse [redstone-relay duration]
  `(let [{:name name# :side side#} ,redstone-relay]
     (peripheral.call name# :setOutput side# true)
     (sleep (* ,duration 0.05))
     (peripheral.call name# :setOutput side# false)))

(local pearl-injector (redstone-relay "redstone_relay_8"
                                      :front))
(local generator-data [(redstone-relay "redstone_relay_1"
                                       :front)
                       (redstone-relay "redstone_relay_7"
                                       :front)
                       (redstone-relay "redstone_relay_3"
                                       :front)])
(local optimal-ticks 10)
(local delta-ticks 2)
(local redstone-pulse-ticks 2)

(local tasks [])

(fn main []
  (sleep 3)
  (let [[first second third] generator-data]
    ;; "Preparing second"
    ;; (pulse second 2)
    ;; (sleep (ticks->time 6))
    ;; "Launching first"
    ;; (pulse pearl-injector 2)
    ;; (while true
    ;;   "Preparing third"
    ;;   (pulse third 2)
    ;;   (sleep (ticks->time 6))
    ;;   "Launching second"
    ;;   (pulse second 2)
    ;;   "Preparing first"
    ;;   (pulse first 2)
    ;;   (sleep (ticks->time 6))
    ;;   "Launching third"
    ;;   (pulse third 2)
    ;;   "Preparing second"
    ;;   (pulse second 2)
    ;;   (sleep (ticks->time 6))
    ;;   "Launching first"
    ;;   (pulse first 2)
    ;;   "Preparing second"
    ;;   (pulse second 2)
    ;;   (sleep (ticks->time 6)))
    ))

(when (not ...)
  (main))
