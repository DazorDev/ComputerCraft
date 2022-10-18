--for testing purposes
function main()
    toggleRecord()
    move("left", 5, "forward")
    returnToStart()
    toggleRecord()
end

----------------------------------------------------------------------------------------------

--boolean to determin if this programm should log whats done or not
doLogging = true

--[[
 * boolean that isUsed to determin is the movement will be recorded so it could be used in a
 * go back methode to reverse the movement or to log the movement done
 --]]
doRecord = false

extraExecuteBefore = true

--a list holding all of the movements that were recorded
recordedMovement={}

--
forEach={}

--[[
 * a table that has the possibile movement options of the turtle
 * each direction e.g. up, down, forward, lookingRight, lookingLeft, etc...
 * linking to a function doing that thing
 --]]
 movementLookupTable={
    ["up"]      = turtle.up,
    ["forward"] = turtle.forward,
    ["fw"]      = turtle.forward,
    ["down"]    = turtle.down,
    ["back"]    = turtle.back,
    ["left"]    = turtle.turnLeft,
    ["right"]   = turtle.turnRight
}


--[[
 * a table that has the opposite of each possibile movement options of the turtle
 * each direction e.g. up, down, forward, lookingRight, lookingLeft, etc...
 * linking to a function doing that does the opposite of that thing
 * this is used for returning to the start and the record function
 * for example we moved our turtle like this and recorded it {up, up, forward, left, forward}
 * with the help of this table we pass these in and get the invers of it
 * the invers of this is example is going to be {down, down, back, right, back}
 * this can be used to for example return to where we started to record
 --]]
returnTable={
    ["up"]      = turtle.down,
    ["forward"] = turtle.back,
    ["fw"]      = turtle.back,
    ["down"]    = turtle.up,
    ["back"]    = turtle.forward,
    ["left"]    = turtle.turnRight,
    ["right"]   = turtle.turnLeft
}

----------------------------------------------------------------------------------------------

--Abstraction of different Input commands and extra input functions

--Loops over the forEach table and uses the function in the spot
function loopExtraExecute()
    for i=1,table.getn(forEach) do
        extraFunction = forEach[i]
        extraFunction()
    end
end

--Function that will take in a string and use it to get a function that does that movement
function execute(direction)
    --Gets the function as a firstclass memeber by using the direction as the key of the lookuptable
    func = movementLookupTable[direction]
    --if the function doesn´t exsist for the key then just break out of the function
    if func == nil then
        log("function not found")
        return
    end
    log("now doing the "..direction.." movement")
    --loop over all the extra functions added in the foreach array before
    if extraExecuteBefore then
        loopExtraExecute()
    end
    --do the movement 
    func()
    --record the movement
    record(direction)
end



----------------------------------------------------------------------------------------------

--Higherlevel Checks to see what to do given different inputs

function functionCheck(inputArray, inputN)
    operationFunction = operatorTable[type(inputArray[inputN])]
    return operationFunction(inputArray, inputN)
end

function executeBooleanFunction(inputArray,inputN)
    --Check if there is a String in the next ArrayElement
    if inputArray[inputN+1] == nil then
        --If not break out of the function
        return inputN
    end
    --Get the pointer to the function
    booleanFunction = inputArray[inputN]

    boolean = booleanFunction()
    log("The boolean before is "..tostring(boolean))
    --loop while this function is true
    while boolean == true do
        --execute the function at num + 1
        execute(inputArray[inputN+1])
        --
        boolean = booleanFunction()
        log("The boolean after is "..tostring(boolean))
    end

    log("broke out of the loop")
    --indicate to the outside that the function next in the array has also been executed
    return inputN + 1
end

--Execute a Function a number of times
function executeNumberFunction(inputArray, inputN)
    --Check if there is a String in the next ArrayElement
    if inputArray[inputN+1] == nil then
        --If not break out of the function
        return inputN
    end

    if inputArray[inputN] < 1 then
        return inputN + 1
    end

    --since the input at num is now confirmed to be a number loop so many times 
    for i=1,inputArray[inputN]-1 do
        --execute the function at num + 1
        execute(inputArray[inputN+1])
    end
    --indicate to the outside that the function next in the array has also been executed
    return inputN + 1
end

function executeFunction(input, num) 
    --if it isn´t then execute the function at the given spot in the array
    execute(input[num])
    --indication no change in the current array spot
    return num
end  

operatorTable={
    ["function"]= executeBooleanFunction,
    ["number"]  = executeNumberFunction,
    ["string"]  = executeFunction
}

-----------------------------------------------------------------------------------------------

--High level Implementation of the Past paragraph
function move(...)
    for i=1,table.getn(arg) do
        i = functionCheck(arg,i)
        if i >= table.getn(arg) then
            return
        end
    end
end

----------------------------------------------------------------------------------------------

--toggles the doRecord boolean to the opposite value to turn on or off the recording
function toggleRecord()
    --takes the opposite value of doRecord
    doRecord = (not doRecord) 
    log("toggle recording to "..tostring(doRecord))
end

--Function that is recording the movement
function record(movement)
    if doRecord == false then
        log("recording is not enabled")
        return
    end
    recordedMovement[table.getn(recordedMovement)+1] = movement
end

----------------------------------------------------------------------------------------------

--[[
 * function that walks back to the start of the recording
 * by traversing the every single step in the recordedMovements and then using the
 * return table to get the invers of the taken action
 --]]
function returnToStart()
    --toggle the recording because we dont want to record the going back as part of the path
    toggleRecord()
    log("returning to start")
    log("length of the recordedMovements "..table.getn(recordedMovement))
    --for every single function in the recordedMovements loop over it backwards, 
    --because the last movement done must be the first one now to return
    for i=table.getn(recordedMovement), 1, -1 do
        log("now executing inverse of "..recordedMovement[i])
        --get the function that does the invers of the movement
        func = returnTable[recordedMovement[i]]
        --execute the function
        func()
    end
end

--[[
 * walks the recorded path
 * used to return after the return from the start
 --]]
function traversRecordedPath()
    --for every single function in the recordedMovements
    for i=1,table.getn(recordedMovement) do
        --get the function that does the movement
        func = movementTable[recordedMovement[i]]
        --execute the function
        func()
    end
end

----------------------------------------------------------------------------------------------

--simple logging function controlled by the doLogging boolean
function log(input)
    --check if logging is enabled
    if not doLogging then
        --break out if it isn´t
        return
    end
    --print the input to the function to the console
    print(input)
end

function addExtraFunction(inputFunction)
    forEach[table.getn(forEach)+1] = inputFunction
end

--clears the recorded path table by creating a new table and assigning it
function clearRecord()
    recordedMovement = {}
end

return {move=move, toggleRecord=toggleRecord, addFunction=addExtraFunction, returnToStart=returnToStart, clearRecord=clearRecord}

----------------------------------------------------------------------------------------------