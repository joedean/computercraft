-- All lines starting with '--' are comments and ignored by the
-- computer.

----------------------
-- GLOBAL VARIABLES --
----------------------

-- Information about where to POST turtle movement
local DOMAIN = "10.0.0.19"
local PORT = "8000"

-- Defines the dimentions of the maze
local MAX_HALL_LENGTH = 10
local MIN_TUNNEL_COUNT = 20
local DEPTH = 3

-- Directions array used for orientation
--   "U" = Up     : Array index = 1
--   "R" = Right  : Array index = 2
--   "D" = Down   : Array index = 3
--   "L" = Left   : Array index = 4
DIRECTIONS = { "U", "R", "D", "L" }

-- Turtles current directional orientation.  Starts facing Up.
direction_index = 1

------------------------------
-- TURTLE UTILITY FUNCTIONS --
------------------------------

-- Posts the provided url to a web page using the HTTP protocol.
-- Used by the broadcast function to send turtle movement to a web page.
local function httpPost(url)
  local response = http.post(url)
end

-- Broadcast turtle movement to specified web page
local function broadcast(direction)
  local url = "http://" .. DOMAIN .. ":" .. PORT .. "/move/" .. direction
  httpPost(url)
end

-- Turn turtle right and adjust direction to keep track of which
-- direction the turtle is facing
local function turnRight()
  turtle.turnRight()
  direction_index = direction_index + 1
  if direction_index > 4 then
    direction_index = direction_index - 4
  end
  return direction_index
end

-- Turn turtle left and adjust direction to keep track of which
-- direction the turtle is facing.
local function turnLeft()
  turtle.turnLeft()
  direction_index = direction_index - 1
  if direction_index < 1 then
    direction_index = direction_index + 4
  end
  return direction_index
end

-- Turtle backs up specified length
local function backUp(length)
  for i=1, length do
    turtle.back()
  end
end

-- Turtle digs forward specified length
local function digForward(length)
  for i=1, length do
    turtle.dig()
    turtle.forward()
  end
end

-- Dig foward one block and broadcast movement to web site
local function tunnelForward()
    turtle.digUp()
    digForward(1)
    broadcast(DIRECTIONS[direction_index])
end

-- Turtle digs up specified length
local function digUp(length)
  for i=1, length do
    turtle.digUp()
    turtle.up()
  end
end

-- Turtle digs down specified length
local function digDown(length)
  for i=1, length do
    turtle.digDown()
    turtle.down()
  end
end

---------------------
-- STAIR FUNCTIONS --
---------------------

-- digs down one stair
local function digDownStair()
  turtle.forward()
  digDown(1)
  digForward(2)
end

-- builds stairs going down
local function buildDownStairs(depth)
  for i=1, depth do
    digDownStair()
    backUp(3)
  end
end

-- dig up one stair
local function digUpStair()
  if turtle.detectUp() then
    digUp(1)
    turtle.digUp()
  else
    digUp(1)
  end
  digForward(1)
end

-- builds stairs going up
local function buildUpStairs(height)
  for i=1, height do
    digUpStair()
  end
end

--------------------
-- MAZE FUNCTIONS --
--------------------

-- Places glow stone
-- **Note** Requires glowstone to be placed in the last slot for the
-- turtle to use it.
local function placeGlowStone()
  local glowStoneSlot = 16
  local startingSlot = turtle.getSelectedSlot()
  turtle.digDown()
  turtle.select(glowStoneSlot)
  turtle.placeDown()
  turtle.select(startingSlot)
end

-- Create a tunnel of specified length.  Every 5th block place a glow
-- stone so you can see in the maze
local function tunnel(length)
  for i=1, length do
    tunnelForward()
    if (i % 5) == 0 then
      placeGlowStone()
    end
  end
end

-- Determine a random direction to turn the turtle to build the next
-- tunnel in the maze.
local function turnRandomDirection()
  turnCount = math.random(1, 4)
  for i=1, turnCount do
    turnRight()
  end
end

-- Build a hallway of random length that is no shorter than half the
-- specified maximum length and no greater than the maximum length.
local function buildHallway(maxLength)
  local halfLength = math.floor(maxLength/2)
  local length = math.random(halfLength, maxLength)
  tunnel(length)
end

-- Build tunnels give the maxLength of each tunnel and the mimum count
-- of tunnels in the maze.  The turtle continues to build tunnels
-- until it is in a position to build up stairs to exit the maze.
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

-- Uses the above function to build the maze
local function buildMaze(maxHallLength, minTunnelCount, depth)
  buildDownStairs(depth)
  buildTunnels(maxHallLength, minTunnelCount)
  buildUpStairs(depth)
end

--------------------------
-- MAIN PART OF PROGRAM --
--------------------------

-- Builds the maze
buildMaze(MAX_HALL_LENGTH, MIN_TUNNEL_COUNT, DEPTH)
