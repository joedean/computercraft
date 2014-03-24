-- Make House Script Using API --
os.loadAPI("house")

local function createHouse(length, width, height)
  house.createFloor(length, width)
  house.createWalls(length, width, height)
  house.createCeiling(length, width, height)
  house.createDoor()
end

createHouse(4,4,4)