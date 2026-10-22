(local start-alarms [])
(local stop-alarms [])
(macro redstone-relay [name side]
  (assert-compile name "Name must be specified")
  (assert-compile side "Side must be specified")
  {: name : side})

(macro ticks->time [number]
  (* number 0.05))

(fn relay [number]
  (.. "redstone_relay_" (tostring number)))

(fn generator [number]
  (.. "rftoolspower:endergenic_" (tostring number)))

(local alarms [{:pid nil
                :tick 1
                :name (relay 4)
                :side :front}
               {:pid nil
                :tick 10
                :name (relay 4)
                :side :left}
               {:pid nil
                :tick 12
                :name (relay 4)
                :side :front}
               {:pid nil
                :tick 13
                :name (relay 4)
                :side :right}
               {:pid nil
                :tick 3
                :name (relay 4)
                :side :right}
               {:pid nil
                :tick 4
                :name (relay 4)
                :side :back}])

(fn pulse [relay]
  (let [{: name : side } relay]
    (peripheral.call name :setOutput side true)
    (set (. stop-alarms (os.setAlarm (+ (os.time :ingame) 0.001))) relay)))

(local optimal-ticks 10)
(local delta-ticks 2)
(local redstone-pulse-ticks 2)

(fn main []
  (sleep 1)
  (let [current-time (os.time :ingame)]
    (each [_ {: tick &as alarm} (ipairs alarms)]
      (set alarm.pid (-> tick
                         (* 0.001)
                         (+ current-time)
                         (% 24.0)
                         (os.setAlarm)))
      (set (. start-alarms alarm.pid) alarm)))
  (print "Started all alarms")
  (while true
    (let [( _ id) (os.pullEvent :alarm)
          alarm (. start-alarms id)
          redstone (. stop-alarms id)]
      (if alarm (do (pulse alarm)
                    (set (. start-alarms alarm.pid) nil))
          redstone (do (peripheral.call redstone.name :setOutput redstone.side false)
                       (set (. stop-alarms redstone.pid) nil)))))

  (pulse {:name (relay 4)
          :side :right})
  (sleep (* 7 0.05))
  (pulse {:name (relay 4)
          :side :front})
  )

(when (not ...)
  (main))
