(local chest (peripheral.wrap :right))
(local trash (peripheral.wrap :top))
(local trash-items ["minecraft:cobbled_deepslate"
                    "minecraft:cobblestone"
                    "minecraft:tuff"
                    "minecraft:netherrack"])

(fn is-trash? [item]
  (var trash? nil)
  (each [_ trash-item (ipairs trash-items) &until trash?]
    (when (= item.name trash-item)
      (set trash? true)))
  trash?)

(fn main []
  (local inventory-size (chest.size))
  (local trash-name (peripheral.getName trash))
  (while true
    (for [slot 1 inventory-size]
      (let [item (chest.getItemDetail slot)]
        (when (is-trash? item)
          (chest.pushItem trash-name slot))))))

(when (not ...)
  (main))
