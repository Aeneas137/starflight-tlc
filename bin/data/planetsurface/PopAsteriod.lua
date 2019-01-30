
L_Debug("PopAsteroid.lua script loading")

L_LoadScript("data/planetsurface/basicLifeForm.lua")
L_LoadScript("data/planetsurface/mineral.lua")
L_LoadScript("data/planetsurface/artifact.lua")
L_LoadScript("data/planetsurface/ruin.lua")


-- 30 - Lead
-- 31 - Iron
-- 33 - Nickel
-- 34 - Copper
-- 35 - Zinc
-- 37 - Tin
-- 39 - Aluminum

minerals = {30, 31, 33, 34, 35, 37, 39}

--iterate through the list of minerals
TotalMinerals = table.getn(minerals)
for MineralID = 0, TotalMinerals do

	--add random number of each mineral to planet surface
	numMineral = 3 + math.random(2)
	for j=1, numMineral do
		id = L_CreateNewPSObyItemID("mineral", minerals[MineralID])
	end

end	
