local function moveRight()
  turtle.turnRight()
  turtle.forward()
  turtle.turnleft()
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
  turtle.fowrad()
  for i=1, width do
    turtle.placeDown()
    moveLeft()
  end
  turtle.back()
end

local function moveUpStair()
  turtle.up()
  turtle.forward()
end

local function placeStairs(width, height)
  for i=1, height do
    placeStairBase(width)
    placeStair(width)
    moveUpStair()
    placeStair(width)
  end
end

placeStairs(5, 5)
