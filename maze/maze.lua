-- turtle utility functions --
local function backUp(length)
  for i=1, length do
    turtle.back()
  end
end

local function digForward(length)
  for i=1, length do
    turtle.dig()
    turtle.forward()
  end
end

local function digUp(length)
  for i=1, length do
    turtle.digUp()
    turtle.up()
  end
end

local function digDown(length)
  for i=1, length do
    turtle.digDown()
    turtle.down()
  end
end

-- stair functions --
local function digDownStair()
  turtle.forward()
  digDown(1)
  digForward(2)
end

local function buildDownStairs(depth)
  for i=1, depth do
    digDownStair()
    backUp(3)
  end
end

local function digUpStair()
  if not turtle.detectUp() then
    turtle.up()
    turtle.digUp()
  else
    digUp(1)
  end
  digForward(1)
end

local function buildUpStairs(height)
  for i=1, height do
    digUpStair()
  end
end

-- maze functions --
local function placeGlowStone()
  local glowStoneSlot = 16
  local startingSlot = turtle.getSelectedSlot()
  turtle.digDown()
  turtle.select(glowStoneSlot)
  turtle.placeDown()
  turtle.select(startingSlot)
end

local function tunnel(length)
  for i=1, length do
    turtle.digUp()
    digForward(1)
    if (i % 5) == 0 then
      placeGlowStone()
    end
  end
end

local function turnRandomDirection()
  turnCount = math.random(1, 4)
  for i=1, turnCount do
    turtle.turnRight()
  end
end

local function buildHallway(maxLength)
  local halfLength = math.floor(maxLength/2)
  local length = math.random(halfLength, maxLength)
  tunnel(length)
end

local function buildTunnels(maxLength, minCount)
  for i=1, minCount do
    buildHallway(maxLength)
    turnRandomDirection()
  end
  while not turtle.detect() do
    buildHallway(maxLength)
    turnRandomDirection()
  end
end

local function buildMaze(maxHallLength, minTunnelCount, depth)
  buildDownStairs(depth)
  buildTunnels(maxHallLength, minTunnelCount)
  buildUpStairs(depth)
end

maxHallLength = 10
minTunnelCount = 20
depth = 3

buildMaze(maxHallLength, minTunnelCount, depth)
