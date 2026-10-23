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

(local alarms [{:name (relay 6)
                :side :front
                :tick 1}
               {:name (relay 7)
                :side :bottom
                :tick 11}
               {:name (relay 6)
                :side :right
                :tick 2}
               {:name (relay 6)
                :side :front
                :tick 11}
               {:name (relay 6)
                :side :back
                :tick 3}
               {:name (relay 6)
                :side :right
                :tick 13}
               {:name (relay 6)
                :side :left
                :tick 4}
               {:name (relay 6)
                :side :back
                :tick 14}
               {:name (relay 6)
                :side :left
                :tick 5}
               {:name (relay 6)
                :side :back
                :tick 15}
               {:name (relay 8)
                :side :back
                :tick 6}
               {:name (relay 6)
                :side :left
                :tick 16}
               {:name (relay 8)
                :side :left
                :tick 7}
               {:name (relay 8)
                :side :back
                :tick 17}
               {:name (relay 5)
                :side :left
                :tick 8}
               {:name (relay 8)
                :side :left
                :tick 19}
               {:name (relay 5)
                :side :front
                :tick 9}
               {:name (relay 8)
                :side :front
                :tick 21}
               {:name (relay 5)
                :side :right
                :tick 10}
               {:name (relay 5)
                :side :front
                :tick 22}
               {:name (relay 5)
                :side :back
                :tick 11}
               {:name (relay 5)
                :side :right
                :tick 23}
               ])

(fn pulse [relay]
  (let [{: name : side } relay]
    (peripheral.call name :setOutput side true)
    (set (. stop-alarms (os.setAlarm (+ (os.time :ingame) 0.01))) relay)))

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
                       (set (. stop-alarms redstone.pid) nil))))))

(when (not ...)
  (main))
