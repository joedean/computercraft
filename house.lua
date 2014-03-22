-- house api --
local function move(direction, distance)
  for i=1, distance do
  	if direction == "up" then
      turtle.up()
    elseif direction == "down" then
      turtle.down()
    elseif direction == "forward" then
      turtle.forward()
    elseif direction == "back" then
      turtle.back()
    else
      print "invalid direction"
      break
    end
    -- Try to dynamically call with the following
  	--func = loadstring('turtle.'..direction..'()')
  	--setfenv(func, getfenv())
  	--func()
  end
end

local function placeBlock()
  slotNum = 1
  while true do
    if(turtle.placeDown()) then 
      break
    else
      slotNum = slotNum + 1
      turtle.select(slotNum)
      if (slotNum > 16) then
        break
      end
    end
  end    
end

local function layBlockRow(length, action, direction)
  for i=1, length do
    if direction == "forward" then
      turtle.forward()
    else
      turtle.back()
    end
    if action == "dig" then
      turtle.digDown()
    end
    placeBlock()
  end
end

local function changeDirection(direction)
  if direction == "forward" then
    turtle.forward()
    return "back"
  else
    turtle.back()
    return "forward"
  end
end

local function surface(length, width, action)
  direction = "forward"
  for i=1, width do
    layBlockRow(length, action, direction)
    turtle.turnLeft()
    turtle.forward()
    turtle.turnRight()
    direction = changeDirection(direction)
  end
  turtle.turnRight()
  move("forward", width)
  turtle.turnLeft()
  if ((width % 2) == 1) then
    move("back", length+1)
  end
end

local function placeWalls( length, width, height )
  for i=1, height do
    turtle.up()
    for j=1, 4 do
      if ((j % 2) == 0) then
        distance = width
      else
        distance = length
      end
      layBlockRow(distance, "place", "forward")
      turtle.turnLeft()
    end
  end
  turtle.back()
  move("down", height)
end 

function makeFloor(length, width)
  surface(length, width, "dig")
end

function makeWalls(length, width, height)
  placeWalls(length, width, height)
end

function makeCeiling(length, width, height)
  move("up", height+1)
  surface(length, width, "place")
  move("down", height+1)
end

function makeDoor(width)
  turtle.turnLeft()
  move("forward", width/2)
  turtle.turnRight()
  turtle.up()
  turtle.dig()
  turtle.down()
  turtle.dig()
  turtle.select(16)
  turtle.place()
  turtle.turnRight()
  move("forward", width/2)
  turtle.turnLeft()
  turtle.select(1)
end

function makeHouse(length, width, height)
  makeFloor(length, width)
  makeWalls(length, width, height)
  makeCeiling(length+1, width+1, height)
  makeDoor(width)
end

function moveTurtle(length, width, height)
	move("up", height)
	move("forward", length)
	turtle.turnLeft()
	move("forward", width)
	turtle.turnRight()
end
