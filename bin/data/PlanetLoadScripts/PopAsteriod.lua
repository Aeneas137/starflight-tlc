-- 30 - Lead
-- 31 - Iron
-- 33 - Nickel
-- 34 - Copper
-- 35 - Zinc
-- 37 - Tin
-- 39 - Aluminum

minerals = {30, 31, 33, 34, 35, 37, 39}

TotalMinerals = 7

L_LoadScript("data\\mineral.lua")
numMineralTypes = math.random(5)


for i=0, numMineralTypes do

	MineralID = math.random(TotalMinerals)
	numMineral = math.random(10)
	for j=0, numMineral do
		--print( "Mineral " .. minerals[MineralID] )
		id = L_CreateNewPSObyItemID("mineral", minerals[MineralID])

	end
end	
