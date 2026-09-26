(macro debug-print [string]
  `(print ,string))
(local certus-dupe-recipe {:ae2:certus_quartz_dust 16
                           :ae2:charged_certus_quartz_crystal 16})

(local certus-charge-recipe {:ae2:certus_quartz_crystal 16})
(local reaction-output-slot 10)

(fn is-adjacent? [])
(fn is-inscriber? [name]
  (string.find name "ae2:inscriber"))
(fn is-reaction-chamber? [name]
  (string.find name "advanced_ae:reaction_chamber"))
(fn is-sink? [name]
  (string.find name "cookingforblockheads:sink"))
(fn is-chest? [name]
  (string.find name "minecraft:chest"))

(fn init []
  (let [reaction-chamber (peripheral.find :inventory is-reaction-chamber?)
        sink (peripheral.find :fluid_storage is-sink?)
        chest (peripheral.find :inventory is-chest?)
        inscriber (peripheral.find :inventory is-inscriber?)]
    {: reaction-chamber
     : sink
     : chest
     : inscriber}))

(fn get-certus-slot [chest]
  (var found-certus? nil)
  (each [slot item (pairs (chest.list)) &until found-certus?]
    (when (= item.name :ae2:certus_quartz_crystal)
      (set found-certus? slot)))
  found-certus?)

(fn craft-charged-certus [reaction-chamber chest]
  (debug-print "Started crafting charged certus")
  (var slot nil)
  (while (not slot)
    (debug-print "Searching for certus quartz in chest" (peripheral.getName chest))
    (set slot (get-certus-slot chest))
    (sleep 0))
  (debug-print "Moved Item to reaction chamber")
  (reaction-chamber.pullItems (peripheral.getName chest) slot nil 1)
  (debug-print "Started Waiting till crystals are charged")
  (while (not (. (reaction-chamber.list) 10))
    (sleep 1))
  (debug-print "Crystal Charged")
  (chest.pullItems (peripheral.getName reaction-chamber) 10 32)
  (debug-print "Moved Extra output to chest")
  (reaction-chamber.pullItems (peripheral.getName reaction-chamber) 10 16 1)
  (debug-print "Moved crafting input back into reactor input"))

(fn craft-certus-dust [reaction-chamber inscriber]
  (inscriber.pullItems (peripheral.getName reaction-chamber) 10 16)
  (debug-print "Moved Items into inscriber")
  (each [slot item (pairs (inscriber.list))]
    (debug-print slot)
    (debug-print item.name))
  (var done-crafting? nil)
  (while (not done-crafting?)
    (debug-print "Waiting till Inscriber crushed crystals")
    (let [items (inscriber.list)]
      (set done-crafting? (and (. items 4)
                               (= (. items 4 :count) 16))))
    (sleep 1)))

(fn craft-certus-crystal [reaction-chamber inscriber chest]
  (reaction-chamber.pullItems (peripheral.getName inscriber) 4)
  (var done-crafting? nil)
  (while (not done-crafting?)
    (let [items (reaction-chamber.list)]
      (set done-crafting? (and items
                               (. items 10)))))
  (chest.pullItems (peripheral.getName reaction-chamber) 10))

(fn craft [reaction-chambers inscribers chests]
  (while true
    (sleep 1)
    (craft-charged-certus reaction-chambers chests)
    (craft-certus-dust reaction-chambers inscribers)
    (craft-certus-crystal reaction-chambers inscribers chests)))

(fn supply-water [reaction-chamber sink]
  "Constant Water supply to all reaction chambers that are in network"
  (let [sink-name (peripheral.getName sink)]
    (while true 
      (sleep 1)
      (reaction-chamber.pullFluid sink-name))))

(fn main []
  "Main entry function for program"
  (let [{: reaction-chamber : sink : chest : inscriber} (init)]
    (parallel.waitForAny (partial supply-water reaction-chamber sink)
                         (partial craft reaction-chamber inscriber chest))))

(when (not ...)
  (main))
