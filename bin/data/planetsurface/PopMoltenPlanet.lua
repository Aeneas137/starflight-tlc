-- Populate Molten Planet Script

--[[
	Globals exported from the engine:

	* PLANETSIZE  : one of "SMALL"/"MEDIUM"/"LARGE"/"HUGE"
	* TEMPERATURE : "SUBARCTIC"/"ARCTIC"/"TEMPERATE"/"TROPICAL"/"SEARING"/"INFERNO"
	* GRAVITY     : "NEGLIGIBLE"/"VERY LOW"/"LOW"/"OPTIMAL"/"VERY HEAVY"/"CRUSHING"
	* ATMOSPHERE  : "NONE"/"TRACEGASES"/"BREATHABLE"/"ACIDIC"/"TOXIC"/"FIRESTORM"
--]]

L_Debug("PopMoltenPlanet.lua script loading")
L_Debug("size: " .. PLANETSIZE .. ", temp: " .. TEMPERATURE .. ", grav: " .. GRAVITY .. ", atmos: " .. ATMOSPHERE)

L_LoadScript("data/planetsurface/basicLifeForm.lua")
L_LoadScript("data/planetsurface/mineral.lua")
L_LoadScript("data/planetsurface/artifact.lua")
L_LoadScript("data/planetsurface/ruin.lua")

goodTemp  = TEMPERATURE ~= "INFERNO"
goodGrav  = GRAVITY ~= "NEGLIGIBLE" and GRAVITY ~= "CRUSHING"
goodAtmos = ATMOSPHERE == "TRACEGASES"
HasLife = goodTemp and goodGrav and goodAtmos

--lifeForm = { ItemID, ScriptPath, ScriptName, InitImagetoLoad, InitAngleOffset, InitScale, InitFaceAngle, InitColHalfWidth, InitColHalfHeight,
--				InitObjectType, InitPortraitName, InitPortraitImage }


lifeForms = {}

-- 73 - Hot Fungus
lifeForm = { 73, "data/planetsurface/basicLifeForm.lua", "basicLifeForm", "data/planetsurface/C_Spider_Giant.tga", 0, 1, 0, 19, 19, 0, "", "" }
lifeForms[0] = lifeForm

-- 76 - Parachute Spider
lifeForm = { 76, "data/planetsurface/basicLifeForm.lua", "basicLifeForm", "data/planetsurface/C_Starfish_Large.tga", 0, 1, 0, 15, 15, 0, "", "" }
lifeForms[1] = lifeForm 

-- 78 - Wheel Snake
lifeForm = { 78, "data/planetsurface/basicLifeForm.lua", "basicLifeForm", "data/planetsurface/C_Snake_Large.tga", 0, 1, 0, 9, 9, 0, "", "" }
lifeForms[2] = lifeForm 

-- 113 - DARK LIGHTING
lifeForm = { 113, "data/planetsurface/basicLifeForm.lua", "basicLifeForm", "data/planetsurface/Hypercube.tga", 0, 1, 0, 15, 15, 0, "", "" }
lifeForms[3] = lifeForm 

if HasLife then

	TotalLifeForms = table.getn(lifeForms)
	for LifeFormID = 0, TotalLifeForms do

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

		numLifeForm = 3 + math.random(2)
		for j=1, numLifeForm do
			id = L_CreateNewPSObyItemID(lifeForms[LifeFormID][3], lifeForms[LifeFormID][1])
		end
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
-- 54 - Endurium

minerals = {30, 31, 32, 33, 34, 35, 39, 41, 43, 45, 53, 54}

--iterate through the list of minerals
TotalMinerals = table.getn(minerals)

for i = 0, TotalMinerals do

	MineralID = math.random(TotalMinerals)

	--add random number of each mineral to planet surface
	numMineral = 1 + math.random(2)
	for j=1, numMineral do
		id = L_CreateNewPSObyItemID("mineral", minerals[MineralID])
	end
end



