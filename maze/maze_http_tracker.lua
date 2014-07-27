-- turtle utility functions --
DIRS = { "U", "R", "D", "L" }
moveDir = "U"

local function httpPost(url)
  local response = http.post(url)
end

local function broadcast(direction)
  local domain = "10.0.0.19"
  local port = "8000"
  local url = "http://" .. domain .. ":" .. port .. "/move/" .. direction
  httpPost(url)
end

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
    broadcast(moveDir)
    if (i % 5) == 0 then
      placeGlowStone()
    end
  end
end

local function currentDirIndex()
  local currentIndex = 0
  for i=1, 4 do
    if DIRS[i] == moveDir then
      currentIndex = i
    end
  end
  return currentIndex
end


local function calculateDirection(turnCount)
  local currentIndex = currentDirIndex()
  if currentIndex == 1 then
    resultIndex = turnCount + currentIndex
    if resultIndex == 5 then
      resultIndex = 1
    end
  else
    resultIndex = (turnCount + currentIndex) % 4
    if resultIndex == 0 then
      resultIndex = 1
    end
  end
  print("currentIndex = " .. currentIndex)
  print("resultIndex = " .. resultIndex)
  print("turncount = " .. turnCount)
  return DIRS[resultIndex]
end

local function turnRandomDirection()
  turnCount = math.random(1, 4)
  for i=1, turnCount do
    turtle.turnRight()
  end
  moveDir = calculateDirection(turnCount)
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
