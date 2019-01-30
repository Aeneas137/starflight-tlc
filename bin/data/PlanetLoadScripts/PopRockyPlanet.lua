-- Populate Rocky Planet Script


--lifeForm = { ItemID, ScriptPath, ScriptName, InitImagetoLoad, InitAngleOffset, InitScale, InitFaceAngle, InitColHalfWidth, InitColHalfHeight,
--				InitObjectType, InitPortraitName, InitPortraitImage }

lifeForms = {}

-- 113 - Dark Lightning			
lifeForm = { 113, "data\\basicLifeForm.lua", "basicLifeForm", "data//C_4Leg_Large.tga", 0, 1, 0, 16, 16, 0, "", "" }
lifeForms[0] = lifeForm

-- 112 - Humming Rock			
lifeForm = { 112, "data\\basicLifeForm.lua", "basicLifeForm", "data//P_Crystal_Small.tga", 0, 1, 0, 15, 15, 0, "", "" }
lifeForms[1] = lifeForm

-- 107 - Radit Slug			
lifeForm = { 107, "data\\basicLifeForm.lua", "basicLifeForm", "data//C_Slug_Giant.tga", 0, 1, 0, 17, 17, 0, "", "" }
lifeForms[2] = lifeForm

-- 101 - Bestruggle			
lifeForm = { 101, "data\\basicLifeForm.lua", "basicLifeForm", "data//C_2Leg_Small.tga", 0, 1, 0, 11, 11, 0, "", "" }
lifeForms[3] = lifeForm

-- 94 - Electric Baloon			
lifeForm = { 94, "data\\basicLifeForm.lua", "basicLifeForm", "data//C_Sponge_Large.tga", 0, 1, 0, 17, 17, 0, "", "" }
lifeForms[4] = lifeForm

-- 90 - Yellow Hugger			
lifeForm = { 90, "data\\basicLifeForm.lua", "basicLifeForm", "data//C_2Leg_Large.tga", 0, 1, 0, 17, 17, 0, "", "" }
lifeForms[5] = lifeForm

-- 87 - Expanding Hippo			
lifeForm = { 87, "data\\basicLifeForm.lua", "basicLifeForm", "data//C_2Leg_Large.tga", 0, 1, 0, 17, 17, 0, "", "" }
lifeForms[5] = lifeForm

-- 74 - Psychic Blaster			
lifeForm = { 74, "data\\basicLifeForm.lua", "basicLifeForm", "data//C_Rodent_Huge.tga", 0, 1, 0, 18, 18, 0, "", "" }
lifeForms[6] = lifeForm

-- 69 - Black Acid Squirter			
lifeForm = { 69, "data\\basicLifeForm.lua", "basicLifeForm", "data//C_Starfish_Large.tga", 0, 1, 0, 15, 15, 0, "", "" }
lifeForms[7] = lifeForm

-- 59 - Vertruks			
lifeForm = { 59, "data\\basicLifeForm.lua", "basicLifeForm", "data//C_Plain_Vertruk.tga", 0, 1, 0, 13, 13, 0, "T_Plain_Vertruk", "data//T_Plain_Vertruk.tga" }
lifeForms[8] = lifeForm

TotalLifeForms = 10

L_LoadScript("data\\basicLifeForm.lua")
numLifeFormTypes = math.random(7)


for i=0, numLifeFormTypes do

	LifeFormID = math.random(TotalLifeForms)
	numLifeForm = math.random(10)

	--Load the script
	L_LoadScript(lifeForms[LifeFormID][2])

	-- fill up the init variables
	InitImagetoLoad = lifeForms[LifeFormID][4]
	InitAngleOffset = lifeForms[LifeFormID][5]
	InitScale = lifeForms[LifeFormID][6]
	InitFaceAngle = lifeForms[LifeFormID][7]
	InitColHalfWidth = lifeForms[LifeFormID][8]
	InitColHalfHeight = lifeForms[LifeFormID][9]
	InitObjectType = lifeForms[LifeFormID][10]
	InitPortraitName = lifeForms[LifeFormID][11]
	InitPortraitImage = lifeForms[LifeFormID][12]

	for j=0, numLifeForm do
		--print( "LifeForm " .. lifeForms[LifeFormID] )

		id = L_CreateNewPSObyItemID(lifeForms[LifeFormID][3], lifeForms[LifeFormID][1])

	end
end

	
-- 30 - Lead
-- 31 - Iron
-- 32 - Cobalt
-- 33 - Nickel
-- 34 - Copper
-- 35 - Zinc
-- 36 - Molybdenum
-- 37 - Tin
-- 38 - Magnesium
-- 39 - Aluminum
-- 40 - Titanium
-- 41 - Chromium
-- 42 - Antimony
-- 43 - Mercury
-- 44 - Promethium
-- 45 - Tungsten
-- 46 - Silver
-- 52 - Magnivum
	
minerals = {30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 52}

TotalMinerals = 18

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


	


