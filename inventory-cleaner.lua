local chest = peripheral.wrap("right")
local trash = peripheral.wrap("top")
local trash_items = {"minecraft:cobbled_deepslate", "minecraft:cobblestone", "minecraft:tuff", "minecraft:netherrack"}
local function is_trash_3f(item)
  local trash_3f = nil
  for _, trash_item in ipairs(trash_items) do
    if trash_3f then break end
    if (item.name == trash_item) then
      trash_3f = true
    else
    end
  end
  return trash_3f
end
local function main()
  local inventory_size = chest.size()
  local trash_name = peripheral.getName(trash)
  while true do
    for slot = 1, inventory_size do
      local item = chest.getItemDetail(slot)
      if is_trash_3f(item) then
        chest.pushItem(trash_name, slot)
      else
      end
    end
  end
  return nil
end
if not ... then
  return main()
else
  return nil
end
