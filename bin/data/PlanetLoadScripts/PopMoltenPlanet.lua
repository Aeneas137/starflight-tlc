-- Populate Molten Planet Script


--lifeForm = { ItemID, ScriptPath, ScriptName, InitImagetoLoad, InitAngleOffset, InitScale, InitFaceAngle, InitColHalfWidth, InitColHalfHeight,
--				InitObjectType, InitPortraitName, InitPortraitImage }


lifeForms = {}

-- 111 - Brescin Fireling			
lifeForm = { 111, "data\\basicLifeForm.lua", "basicLifeForm", "data//C_2Leg_Fuzz.tga", 0, 1, 0, 17, 17, 0, "", "" }
lifeForms[0] = lifeForm

-- 108 - Stinging Cone			
lifeForm = { 108, "data\\basicLifeForm.lua", "basicLifeForm", "data//C_Slug_Giant.tga", 0, 1, 0, 17, 17, 0, "", "" }
lifeForms[1] = lifeForm

-- 93 - Milmataur			
lifeForm = { 93, "data\\basicLifeForm.lua", "basicLifeForm", "data//C_2Leg_Fuzz.tga", 0, 1, 0, 17, 17, 0, "", "" }
lifeForms[2] = lifeForm

-- 79 - Glowing Spinner			
lifeForm = { 79, "data\\basicLifeForm.lua", "basicLifeForm", "data//C_Spider_Giant.tga", 0, 1, 0, 19, 19, 0, "", "" }
lifeForms[3] = lifeForm

-- 70 - Humanoid Hopper			
lifeForm = { 70, "data\\basicLifeForm.lua", "basicLifeForm", "data//C_2Leg_Yellow.tga", 0, 1, 0, 19, 19, 0, "", "" }
lifeForms[4] = lifeForm

-- 67 - Pulsating Gummy			
lifeForm = { 67, "data\\basicLifeForm.lua", "basicLifeForm", "data//C_Starfish_Large.tga", 0, 1, 0, 15, 15, 0, "", "" }
lifeForms[5] = lifeForm

TotalLifeForms = 6

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
-- 53 - Quorsitanium

minerals = {30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 53}

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


