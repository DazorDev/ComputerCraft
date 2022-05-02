local isTree = false

local mc = "minecraft:"
local log = "_log"
local offset = 0
local treeTypes = {mc.."oak"..log, mc.."birch"..log}

local height = 0

function init()
    boolean, block = turtle.inspect()
    if not boolean then
        return
    end
    isTree = checkIfTree(block)
    print(isTree)
end

function checkIfTree(block)
    for i=1,table.getn(treeTypes) do
        if  block.name == treeTypes[i] then 
            return true
        end
    end
    return false 
end


function start()
    
    if not isTree then 
        return
    end
    
    breakTree()
end

function moveFw()
    while turtle.getFuelLevel() < 4 do
        refuel()
    end
    turtle.forward()
end

function moveUp()
    while turtle.getFuelLevel() < 4 do
        refuel()    
    end
    turtle.up()
    height = height + 1
end

function checkIfUp()
    boolean, block = turtle.inspectUp()
    
    if not boolean then
        return false
    end
    
    return checkIfTree(block)    
end

function breakTree()        
    turtle.dig()
    moveFw()

    while checkIfUp() do
        turtle.digUp()
        moveUp()
    end

    for i=1,height do
        turtle.down()
    end            
end

function refuel()
    for i=1+offset,16 do
        amountOfItem = turtle.getItemCount(i)
        if amountOfItem == 0 then
            offset = offset + 1
            return
        end
        
        offset = 0
        
        item = turtle.getItemDetail(i)
        
        if item.name == mc.."coal" then
            turtle.select(i)
            turtle.refuel(64)
        end
        
        if checkIfTree(item) then
            turtle.craft()
            newAmountOfItem = amountOfItem*4
            if newAmountOfItem > 64 then
                for i=1,newAmountOfItem%64 do
                    turtle.select(i)
                    turtle.refuel(64)
                end
                turtle.select(1)
                return
            end
            turtle.refuel(64)
        end                   
    end                         
end

function main() 
    init()
    start()
end

main()
