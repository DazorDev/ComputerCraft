--for testing purposes
function main()
    
end

--boolean to determin if this programm should log whats done or not
doLogging = true

/*
 * boolean that isUsed to determin is the movement will be recorded so it could be used in a
 * go back methode to reverse the movement or to log the movement done
 */
doRecord = false

--a list holding all of the movements that were recorded
recordedMovement={}

/*
 * a table that has the possibile movement options of the turtle
 * each direction e.g. up, down, forward, lookingRight, lookingLeft, etc...
 * linking to a function doing that thing
 */
movementLookupTable={
    ["up"]=turtle.up,
    ["forward"]=turtle.forward,
    ["down"]=turtle.down,
    ["back"]=turtle.back,
    ["left"]=turtle.turnLeft,
    ["right"]=turtle.turnRight
}


/*
 * a table that has the opposite of each possibile movement options of the turtle
 * each direction e.g. up, down, forward, lookingRight, lookingLeft, etc...
 * linking to a function doing that does the opposite of that thing
 * this is used for returning to the start and the record function
 * for example we moved our turtle like this and recorded it {up, up, forward, left, forward}
 * with the help of this table we pass these in and get the invers of it
 * the invers of this is example is going to be {down, down, back, right, back}
 * this can be used to for example return to where we started to record
 */
returnTable={
    ["up"]      = turtle.down,
    ["forward"] = turtle.back,
    ["down"]    = turtle.up,
    ["left"]    = turtle.turnRight,
    ["right"]   = turtle.turnLeft
}

function move(...)
    if arg[1] == nil then
        return
    end
    for index,key in pairs(arg) do
        do(key)
    end
end

--Function that will take in a string and use it to get a function that does that movement
function do(direction)
    --Gets the function as a firstclass memeber by using the direction as the key of the lookuptable
    func = movementLookupTable[direction]
    --if the function doesn´t exsist for the key then just break out of the function
    if func == nil then
        log("funtion not found")
        return
    end
    log("now doing the "..direction.."movement")
    --do the movement 
    func()
end

--toggles the doRecord boolean to the opposite value to turn on or off the recording
function toggleRecord()
    --takes the opposite value of doRecord
    doRecord = (not doRecord) 
    log("toggle recording to "..doRecord)
end

--Function that is recording the movement
function record(movement)
    if not doRecord then
        log("recording is not enabled")
        return
    end
    recordedMovement[table.getn(recordedMovement)] = movement
end

/*
 * function that walks back to the start of the recording
 * by traversing the every single step in the recordedMovements and then using the
 * return table to get the invers of the taken action
 */
function returnToStart()
    --toggle the recording because we dont want to record the going back as part of the path
    toggleRecord()
    log("returning to start")
    --for every single function in the recordedMovements
    for i=1,table.getn(recordedMovement) do
        log("now executing "..recordedMovement[i])
        --get the function that does the invers of the movement
        func = returnTable[recordedMovement[i]]
        --execute the function
        func()
    end
end

/*
 * walks the recorded path
 * used to return after the return from the start
 */
function traversRecordedPath()
    --for every single function in the recordedMovements
    for i=1,table.getn(recordedMovement) do
        --get the function that does the movement
        func = movementTable[recordedMovement[i]]
        --execute the function
        func()
    end
end

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

--clears the recorded path table by creating a new table and assigning it
function clearRecord()
    recordedMovement = {}
end

--call of the main function for testing purposes
main()