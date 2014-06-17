local function digRow(length)
  for i=1, length do
    turtle.forward()
    turtle.digDown()
  end
end

local function turn(direction)
  if direction = "left" then
    turtle.turnLeft()
  elseif direction = "right" then
    turtle.turnRight()
  else
    print(direction.."is not a valid direction")
    return
  end
end

local function moveForward(distance)
  for i=1, distance do
    turtle.forward()
  end
end

local function moveBack(distance)
  for i=1, distance do
    turtle.back()
  end
end

local function digPool(length, width)
  for i=1, width do
    digRow(length)
    direction = "right"
    if( (i % 2) = 0 ) then
      direction = "left"
    end
    turn(direction) 
    turtle.forward()
    turn(direction)
    turtle.back()
  
    if (direction == "right") then
      moveForward(length + 1)
      turtle.turnRight()
      turtle.turnRight()
    end
    turtle.turnLeft()
    moveForward(width)
    turtle.turnRight()
  end
end

moveForward(6)
digPool(5,5)
moveForward(2)
turtle.placeDown()
moveBack(8)
   
