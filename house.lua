-- house API --
local MAX_SLOT_NUMBER = 16

local function placeBlock()
  if ( turtle.detectDown() ) then
    turtle.digDown()
  end
  slotNum = 0
  repeat
    slotNum = slotNum + 1
    if ( slotNum > MAX_SLOT_NUMBER ) then
      print ("No blocks to place!")
      return
    end
    turtle.select(slotNum)    
  until turtle.placeDown()
end 

local function placeBlockRow(length)
  for i=1, length do
    turtle.forward()
    placeBlock()
  end
end

local function turn(direction)
  if direction == "left" then
    turtle.turnLeft()
  elseif direction == "right" then
    turtle.turnRight()
  else
    print("Not a valid direction")
    return
  end
end

local function moveTurtleForward(distance)
  for i=1, distance do
    turtle.forward()
  end
end

function createFloor(length, width)
  for i=1, width do
    placeBlockRow(length)
    direction = "left"
    if ( (i % 2) == 0 ) then
      direction = "right"
    end
    turn(direction)
    turtle.forward()
    turn(direction)
    turtle.back()  
  end
  if ( direction == "left" ) then
    moveTurtleForward(length+1)
    turtle.turnLeft()
    turtle.turnLeft()
  end
  turtle.turnRight()
  turtle.up()
  moveTurtleForward(width)
  turtle.down()
  turtle.turnLeft()  
end

local function calculateDistance(index, length, width)
  if ( index == 1 ) then
    distance = length
  elseif ( index == 2 ) then
    distance = width - 1
  elseif ( index == 3 ) then
    distance = length - 1
  else
    distance = width - 2
  end
  return distance
end

function createWalls(length, width, height)
  for i=1, height do
    turtle.up()
    for j = 1, 4 do
      placeBlockRow(calculateDistance(j, length, width))
      turtle.turnLeft()
    end
    turtle.turnRight()
    turtle.forward()
    turtle.turnLeft()
    turtle.back()
  end
  for i=1, height do
    turtle.down()
  end
end

function createCeiling(length, width, height)
  for i=1, height+1 do
    turtle.up()
  end
  createFloor(length, width)
  for i=1, height+1 do
    turtle.down()
  end
end

function createDoor()
  turtle.turnRight()
  turtle.forward()
  turtle.turnLeft()
  moveTurtleForward(2)
  turtle.turnLeft()
  turtle.dig()
  turtle.up()
  turtle.dig()
  turtle.down()
  turtle.select(MAX_SLOT_NUMBER)
  turtle.place()
  turtle.select(1)
  turtle.turnLeft()
  moveTurtleForward(2)
  turtle.turnRight()
  turtle.forward()
  turtle.turnRight()
end
