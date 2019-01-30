-- Populate Oceanic Planet Script

L_Debug("PopOceanicPlanet.lua script loading")

L_LoadScript("data/planetsurface/basicLifeForm.lua")
L_LoadScript("data/planetsurface/mineral.lua")
L_LoadScript("data/planetsurface/artifact.lua")
L_LoadScript("data/planetsurface/ruin.lua")

		
--lifeForm = { ItemID, ScriptPath, ScriptName, InitImagetoLoad, InitAngleOffset, InitScale, InitFaceAngle, InitColHalfWidth, InitColHalfHeight, 
--				InitObjectType, InitPortraitName, InitPortraitImage }

lifeForms = {}


-- 55 - Pop Berry Plant
lifeForm = { 55, "data/planetsurface/basicLifeForm.lua", "basicLifeForm", "data/planetsurface/P_Bush_Law.tga", 0, 1, 0, 21, 21, 0, "", "" }
lifeForms[0] = lifeForm 

-- 58 - Rocket Melons
lifeForm = { 58, "data/planetsurface/basicLifeForm.lua", "basicLifeForm", "data/planetsurface/P_Bush_Law.tga", 0, 1, 0, 21, 21, 0, "", "" }
lifeForms[1] = lifeForm 

-- 62 - Sticky Fruit
lifeForm = { 62, "data/planetsurface/basicLifeForm.lua", "basicLifeForm", "data/planetsurface/P_Plant_Small.tga", 0, 1, 0, 15, 15, 0, "", "" }
lifeForms[2] = lifeForm 

-- 63 - Hive Plant
lifeForm = { 63, "data/planetsurface/basicLifeForm.lua", "basicLifeForm", "data/planetsurface/P_Plant_Small.tga", 0, 1, 0, 15, 15, 0, "", "" }
lifeForms[3] = lifeForm 

-- 64 - Scaly Blue Hopper
lifeForm = { 64, "data/planetsurface/basicLifeForm.lua", "basicLifeForm", "data/planetsurface/C_Plain_Vertruk.tga", 0, 1, 0, 15, 15, 0, "", "" }
lifeForms[4] = lifeForm 

-- 66 - Hill Rat
lifeForm = { 66, "data/planetsurface/basicLifeForm.lua", "basicLifeForm", "data/planetsurface/C_4Leg_Small.tga", 0, 1, 0, 13, 13, 0, "", "" }
lifeForms[5] = lifeForm 

-- 67 - Pulsating Gummy			
lifeForm = { 67, "data/planetsurface/basicLifeForm.lua", "basicLifeForm", "data/planetsurface/C_Sponge_Large.tga", 0, 1, 0, 17, 17, 0, "", "" }
lifeForms[6] = lifeForm

-- 68 - Spinning Crab			
lifeForm = { 68, "data/planetsurface/basicLifeForm.lua", "basicLifeForm", "data/planetsurface/C_2Leg_Small.tga", 0, 1, 0, 11, 11, 0, "", "" }
lifeForms[7] = lifeForm

-- 72 - Vacuum Slug
lifeForm = { 72, "data/planetsurface/basicLifeForm.lua", "basicLifeForm", "data/planetsurface/C_Slug_Giant.tga", 0, 1, 0, 17, 17, 0, "", "" }
lifeForms[8] = lifeForm 

-- 75 - Oily Spore Bush
lifeForm = { 75, "data/planetsurface/basicLifeForm.lua", "basicLifeForm", "data/planetsurface/P_Bush_Law.tga", 0, 1, 0, 21, 21, 0, "", "" }
lifeForms[9] = lifeForm 

-- 82 - Green Balloon
lifeForm = { 82, "data/planetsurface/basicLifeForm.lua", "basicLifeForm", "data/planetsurface/P_Tree_Small.tga", 0, 1, 0, 17, 17, 0, "", "" }
lifeForms[10] = lifeForm 

-- 83 - Poison Glider
lifeForm = { 83, "data/planetsurface/basicLifeForm.lua", "basicLifeForm", "data/planetsurface/C_Plain_Galists.tga", 0, 1, 0, 11, 11, 0, "", "" }
lifeForms[11] = lifeForm 

-- 85 - Nid Berry Bush
lifeForm = { 85, "data/planetsurface/basicLifeForm.lua", "basicLifeForm", "data/planetsurface/P_Plant_Small.tga", 0, 1, 0, 15, 15, 0, "", "" }
lifeForms[12] = lifeForm 

-- 87 - Expanding Hippo
lifeForm = { 87, "data/planetsurface/basicLifeForm.lua", "basicLifeForm", "data/planetsurface/C_Bird_Yellow.tga", 0, 1, 0, 17, 17, 0, "", "" }
lifeForms[13] = lifeForm 

-- 89 - Single Leaf
lifeForm = { 89, "data/planetsurface/basicLifeForm.lua", "basicLifeForm", "data/planetsurface/P_Tree_Large.tga", 0, 1, 0, 22, 22, 0, "", "" }
lifeForms[14] = lifeForm 

-- 90 - Yellow Hugger
lifeForm = { 90, "data/planetsurface/basicLifeForm.lua", "basicLifeForm", "data/planetsurface/C_2Leg_Yellow.tga", 0, 1, 0, 19, 19, 0, "", "" }
lifeForms[15] = lifeForm 

-- 92 - Fur Tree
lifeForm = { 92, "data/planetsurface/basicLifeForm.lua", "basicLifeForm", "data/planetsurface/P_Tree_Large.tga", 0, 1, 0, 22, 22, 0, "", "" }
lifeForms[16] = lifeForm 

-- 94 - Electric Balloon
lifeForm = { 94, "data/planetsurface/basicLifeForm.lua", "basicLifeForm", "data/planetsurface/C_Bat_Large.tga", 0, 1, 0, 9, 9, 0, "", "" }
lifeForms[17] = lifeForm 

-- 96 - Grey Anemone
lifeForm = { 96, "data/planetsurface/basicLifeForm.lua", "basicLifeForm", "data/planetsurface/C_4Leg_Small.tga", 0, 1, 0, 13, 13, 0, "", "" }
lifeForms[18] = lifeForm 

-- 98 - Green Blob
lifeForm = { 98, "data/planetsurface/basicLifeForm.lua", "basicLifeForm", "data/planetsurface/C_Slug_Giant.tga", 0, 1, 0, 17, 17, 0, "", "" }
lifeForms[19] = lifeForm 

-- 99 - Funnel Tree
lifeForm = { 99, "data/planetsurface/basicLifeForm.lua", "basicLifeForm", "data/planetsurface/P_Tree_Small.tga", 0, 1, 0, 17, 17, 0, "", "" }
lifeForms[20] = lifeForm 

-- 103 - Purple Screecher
lifeForm = { 103, "data/planetsurface/basicLifeForm.lua", "basicLifeForm", "data/planetsurface/C_Bird_Large.tga", 0, 1, 0, 16, 16, 0, "", "" }
lifeForms[21] = lifeForm 

-- 104 - Peacock Tree
lifeForm = { 104, "data/planetsurface/basicLifeForm.lua", "basicLifeForm", "data/planetsurface/P_Tree_Large.tga", 0, 1, 0, 22, 22, 0, "", "" }
lifeForms[22] = lifeForm 

-- 106 - Eight-Legged Rhino
lifeForm = { 106, "data/planetsurface/basicLifeForm.lua", "basicLifeForm", "data/planetsurface/C_2Leg_Fuzz.tga", 0, 1, 0, 17, 17, 0, "", "" }
lifeForms[23] = lifeForm 

-- 108 - Stinging Cone			
lifeForm = { 108, "data/planetsurface/basicLifeForm.lua", "basicLifeForm", "data/planetsurface/P_Tree_Small.tga", 0, 1, 0, 17, 17, 0, "", "" }
lifeForms[24] = lifeForm

-- 109 - Brass Harpooner			
lifeForm = { 109, "data/planetsurface/basicLifeForm.lua", "basicLifeForm", "data/planetsurface/C_Rodent_Huge.tga", 0, 1, 0, 18, 18, 0, "", "" }
lifeForms[25] = lifeForm



--
-- For oceanic planet, we want large variety of lifeforms but only a random subset added to the surface at a time
--
TotalLifeForms = table.getn(lifeForms)
for i=0, TotalLifeForms do

	--choose a random lifeform from the large list of available candidates
	LifeFormID = math.random(TotalLifeForms)
	
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
-- 47 - Gold
-- 48 - Platinum
-- 49 - Silicon
-- 50 - Rodnium
-- 54 - Endurium

minerals = {31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 54}

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




