local function moveRight()
  turtle.turnRight()
  turtle.forward()
  turtle.turnLeft()
end

local function moveLeft()
  turtle.turnLeft()
  turtle.forward()
  turtle.turnRight()
end

local function placeStair(width)
  for i=1, width do
    turtle.place()
    moveRight()
  end
end

local function placeStairBase(width)
  turtle.forward()
  for i=1, width do
    moveLeft()
    turtle.placeDown()
  end
  turtle.back()
end

local function moveUpStair()
  turtle.up()
  turtle.forward()
end

local function placeStairs(width, height)
  for i=1, height do
    placeStair(width)
    moveUpStair()
    placeStairBase(width)
  end
end

placeStairs(5, 5)
