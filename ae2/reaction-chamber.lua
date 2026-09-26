local certus_dupe_recipe = {["ae2:certus_quartz_dust"] = 16, ["ae2:charged_certus_quartz_crystal"] = 16}
local certus_charge_recipe = {["ae2:certus_quartz_crystal"] = 16}
local reaction_output_slot = 10
local function is_adjacent_3f()
end
local function is_inscriber_3f(name)
  return string.find(name, "ae2:inscriber")
end
local function is_reaction_chamber_3f(name)
  return string.find(name, "advanced_ae:reaction_chamber")
end
local function is_sink_3f(name)
  return string.find(name, "cookingforblockheads:sink")
end
local function is_chest_3f(name)
  return string.find(name, "minecraft:chest")
end
local function init()
  local reaction_chamber = peripheral.find("inventory", is_reaction_chamber_3f)
  local sink = peripheral.find("fluid_storage", is_sink_3f)
  local chest = peripheral.find("inventory", is_chest_3f)
  local inscriber = peripheral.find("inventory", is_inscriber_3f)
  return {["reaction-chamber"] = reaction_chamber, sink = sink, chest = chest, inscriber = inscriber}
end
local function get_certus_slot(chest)
  local found_certus_3f = nil
  for slot, item in pairs(chest.list()) do
    if found_certus_3f then break end
    if (item.name == "ae2:certus_quartz_crystal") then
      found_certus_3f = slot
    else
    end
  end
  return found_certus_3f
end
local function craft_charged_certus(reaction_chamber, chest)
  print("Started crafting charged certus")
  local slot = nil
  while not slot do
    print("Searching for certus quartz in chest")
    slot = get_certus_slot(chest)
    sleep(0)
  end
  print("Moved Item to reaction chamber")
  reaction_chamber.pullItems(peripheral.getName(chest), slot, nil, 1)
  print("Started Waiting till crystals are charged")
  while not reaction_chamber.list()[10] do
    sleep(1)
  end
  print("Crystal Charged")
  chest.pullItems(peripheral.getName(reaction_chamber), 10, 32)
  print("Moved Extra output to chest")
  reaction_chamber.pullItems(peripheral.getName(reaction_chamber), 10, 16, 1)
  return print("Moved crafting input back into reactor input")
end
local function craft_certus_dust(reaction_chamber, inscriber)
  inscriber.pullItems(peripheral.getName(reaction_chamber), 10, 16)
  print("Moved Items into inscriber")
  for slot, item in pairs(inscriber.list()) do
    print(slot)
    print(item.name)
  end
  local done_crafting_3f = nil
  while not done_crafting_3f do
    print("Waiting till Inscriber crushed crystals")
    do
      local items = inscriber.list()
      done_crafting_3f = (items[4] and (items[4].count == 16))
    end
    sleep(1)
  end
  return nil
end
local function craft_certus_crystal(reaction_chamber, inscriber, chest)
  reaction_chamber.pullItems(peripheral.getName(inscriber), 4)
  local done_crafting_3f = nil
  while not done_crafting_3f do
    local items = reaction_chamber.list()
    done_crafting_3f = (items and items[10])
  end
  return chest.pullItems(peripheral.getName(reaction_chamber), 10)
end
local function craft(reaction_chambers, inscribers, chests)
  while true do
    sleep(1)
    craft_charged_certus(reaction_chambers, chests)
    craft_certus_dust(reaction_chambers, inscribers)
    craft_certus_crystal(reaction_chambers, inscribers, chests)
  end
  return nil
end
local function supply_water(reaction_chamber, sink)
  local sink_name = peripheral.getName(sink)
  while true do
    sleep(1)
    reaction_chamber.pullFluid(sink_name)
  end
  return nil
end
local function main()
  local _let_2_ = init()
  local reaction_chamber = _let_2_["reaction-chamber"]
  local sink = _let_2_.sink
  local chest = _let_2_.chest
  local inscriber = _let_2_.inscriber
  local function _3_(...)
    return supply_water(reaction_chamber, sink, ...)
  end
  local function _4_(...)
    return craft(reaction_chamber, inscriber, chest, ...)
  end
  return parallel.waitForAny(_3_, _4_)
end
if not ... then
  return main()
else
  return nil
end
