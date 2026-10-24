(local current-alarms [])
(local next-alarms [])
(fn relay [number]
  (.. "redstone_relay_" (tostring number)))

(local timings [{:name (relay 6)
                :side :front
                :tick 1}
               {:name (relay 7)
                :side :bottom
                :tick 11}
               {:name (relay 6)
                :side :right
                :tick 4}
               {:name (relay 6)
                :side :front
                :tick 12}
               {:name (relay 6)
                :side :back
                :tick 5}
               {:name (relay 6)
                :side :right
                :tick 14}
               {:name (relay 6)
                :side :left
                :tick 6}
               {:name (relay 6)
                :side :back
                :tick 15}
               {:name (relay 8)
                :side :back
                :tick 7}
               {:name (relay 6)
                :side :left
                :tick 16}
               {:name (relay 8)
                :side :left
                :tick 8}
               {:name (relay 8)
                :side :back
                :tick 17}
               {:name (relay 5)
                :side :left
                :tick 8}
               {:name (relay 8)
                :side :left
                :tick 18}
               {:name (relay 5)
                :side :front
                :tick 10}
               {:name (relay 8)
                :side :front
                :tick 19}
               {:name (relay 5)
                :side :right
                :tick 11}
               {:name (relay 5)
                :side :front
                :tick 20}
               {:name (relay 5)
                :side :back
                :tick 12}
               {:name (relay 5)
                :side :right
                :tick 21}
               ])

(fn pulse [relay]
  (let [{: name : side : tick &as alarm} relay]
    (peripheral.call name :setOutput side true)
    (sleep 0.1)
    (peripheral.call name :setOutput side false)))

(fn init []
 (let [current-time (os.time :ingame)]
    (each [_ {: tick &as alarm} (ipairs timings)]
      (set (. current-alarms (-> tick
                                (* 0.001)
                                (+ (os.time :ingame))
                                (% 24.0)
                                (os.setAlarm))) alarm))))


(fn worker [spawn]
  (while true
    (let [(_ id) (os.pullEvent :alarm)
          alarm (. current-alarms id)]
      (when alarm
        (spawn (partial pulse alarm))
        (set (. current-alarms id) nil)))))

(fn main []
  (sleep 1)
  (init)
  (parallel.waitForAll worker))

(when (not ...)
  (main))
