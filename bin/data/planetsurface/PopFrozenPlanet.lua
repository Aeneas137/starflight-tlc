-- Populate Frozen Planet Script

--[[
	Globals exported from the engine:

	* PLANETSIZE  : one of "SMALL"/"MEDIUM"/"LARGE"/"HUGE"
	* TEMPERATURE : "SUBARCTIC"/"ARCTIC"/"TEMPERATE"/"TROPICAL"/"SEARING"/"INFERNO"
	* GRAVITY     : "NEGLIGIBLE"/"VERY LOW"/"LOW"/"OPTIMAL"/"VERY HEAVY"/"CRUSHING"
	* ATMOSPHERE  : "NONE"/"TRACEGASES"/"BREATHABLE"/"ACIDIC"/"TOXIC"/"FIRESTORM"
--]]

L_Debug("PopFrozenPlanet.lua script loading")
L_Debug("size: " .. PLANETSIZE .. ", temp: " .. TEMPERATURE .. ", grav: " .. GRAVITY .. ", atmos: " .. ATMOSPHERE)

L_LoadScript("data/planetsurface/basicLifeForm.lua")
L_LoadScript("data/planetsurface/mineral.lua")
L_LoadScript("data/planetsurface/artifact.lua")
L_LoadScript("data/planetsurface/ruin.lua")


HasLife = ( TEMPERATURE == "ARCTIC" and ATMOSPHERE ~= "NONE" )

--lifeForm = { ItemID, ScriptPath, ScriptName, InitImagetoLoad, InitAngleOffset, InitScale, InitFaceAngle, InitColHalfWidth, InitColHalfHeight,
--				InitObjectType, InitPortraitName, InitPortraitImage }

lifeForms = {}

-- 57 - Plant Bird
lifeForm = { 57, "data/planetsurface/basicLifeForm.lua", "basicLifeForm", "data/planetsurface/P_Plant_Small.tga", 0, 1, 0, 15, 15, 0, "", "" }
lifeForms[0] = lifeForm 

-- 63 - Hive Plant
lifeForm = { 63, "data/planetsurface/basicLifeForm.lua", "basicLifeForm", "data/planetsurface/P_Plant_Small.tga", 0, 1, 0, 15, 15, 0, "", "" }
lifeForms[1] = lifeForm 

-- 70 - Humanoid Hopper			
lifeForm = { 70, "data/planetsurface/basicLifeForm.lua", "basicLifeForm", "data/planetsurface/C_2Leg_Large.tga", 0, 1, 0, 17, 17, 0, "", "" }
lifeForms[2] = lifeForm

-- 74 - Psychic Blaster			
lifeForm = { 74, "data/planetsurface/basicLifeForm.lua", "basicLifeForm", "data/planetsurface/C_Swift_Galists.tga", 0, 1, 0, 11, 11, 0, "", "" }
lifeForms[3] = lifeForm

-- 77 - Wandering Chandelier
lifeForm = { 77, "data/planetsurface/basicLifeForm.lua", "basicLifeForm", "data/planetsurface/P_Tree_Small.tga", 0, 1, 0, 17, 17, 0, "", "" }
lifeForms[4] = lifeForm 

-- 112 - Humming Rock
lifeForm = { 112, "data/planetsurface/basicLifeForm.lua", "basicLifeForm", "data/planetsurface/ore_sprite.tga", 0, 1, 0, 22, 22, 0, "", "" }
lifeForms[5] = lifeForm 

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
-- 51 - Berisin
-- 54 - Endurium

minerals = {30, 31, 32, 33, 34, 35, 37, 38, 39, 40, 41, 51, 54}

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
	



