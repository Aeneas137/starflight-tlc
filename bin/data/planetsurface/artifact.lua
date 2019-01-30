-- ARTIFACT SCRIPT FILE
-- Note: the Damage property is used to specify the cubic meters of ore at the deposit

L_Debug("artifact.lua script loading")

loadrange = 120

function artifactInitialize( )
	id = L_GetItemID()
	L_Debug("  artifactInitialize: ItemID = " .. tostring(id) )
	--L_LoadImage("data/planetsurface/B_Tomb.tga")
	L_SetDamage(1) --set size to 1
	L_SetColHalfWidth(48)
	L_SetColHalfHeight(48)
	L_SetObjectType(2) -- 2 = artifact
	L_SetAlpha(true)
end

function artifactUpdate( )
end

function artifactTimedUpdate( )
	L_Draw()
end

function artifactGetActions()
	scanned = L_IsScanned()
	if (scanned) then
		L_SetActions("Study")
	else
		L_SetActions()
	end
end


function artifactOnEvent()
	--event should be instantiated by C++ with the OnEvent function call
	if (event == 0) then --Study

		x1,y1 = L_GetPosition()
		x2,y2 = L_GetActiveVesselPosition()
		distance = CheckDistance( x1, y1, x2, y2)
		if (distance < loadrange) then
			quantity = L_GetDamage() --I'm using damage as a way to hold the quantity remaining
			if ( quantity ~= 0 ) then
				L_CreateTimer("                 Studying...",100)
				L_PostMessage(0, 255, 0,"You begin to record the artifact")
				L_StopSound("scanning")
				L_PlayLoopingSound("scanning")
			end
		else
			L_PostMessage(0, 0, 255,"You are not close enough to the artifact")
		end

	elseif (event == 70196) then   --this is the timer event that occurs after the artifact has been studied/gathered
		x1,y1 = L_GetPosition()
		x2,y2 = L_GetActiveVesselPosition()
		distance = CheckDistance( x1, y1, x2, y2)
		if (distance < loadrange) then
			--damage property is used for quantity, this makes it so the artifact can't be picked up again right away
			L_SetDamage(0) 

			--add artifact to ship's cargo hold
			L_AddArtifactToCargo( L_GetItemID() )
			L_PostMessage(0, 255, 0,"You succesfully holo-recorded the " .. L_GetName() .. ".")

		else
			L_PostMessage(0, 0, 255,"Sir, please keep the TV stationary or the recording will fail.")
		end

	end	
end


function artifactScan()
	message = "SCANNER READOUT"
--	L_PostMessage(b, g, r, text)
	L_PostMessage(255, 255, 0, message)

	message = "Name: " .. L_GetName()
	L_PostMessage(message)

	message = "This is an extremely important and rare ARTIFACT!"
	L_PostMessage(message)

	artifactGetActions()
	--L_ShowPortrait("artifact") 
end


function artifactCollisionOccurred()
	L_Debug("artifactCollisionOccurred")
end
