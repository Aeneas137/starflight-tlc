-- RUIN SCRIPT FILE

L_Debug("ruin.lua script loading")

--Note: RUINS are not picked up, only examined!

loadrange = 120

function ruinInitialize( )
	id = L_GetItemID()
	L_Debug("  ruinInitialize: ItemID = " .. tostring(id) )
	--L_LoadImage("data/planetsurface/B_Tomb.tga")
	L_SetDamage(1) --set size to 1
	L_SetColHalfWidth(48)
	L_SetColHalfHeight(48)
	L_SetObjectType(3) -- 3 = ruin
	L_SetAlpha(true)
end

function ruinUpdate( )
end

function ruinTimedUpdate( )
	L_Draw()
end

function ruinGetActions()
	scanned = L_IsScanned()
	if (scanned) then
		L_SetActions("Study")
	else
		L_SetActions()
	end
end


function ruinOnEvent()
	--event should be instantiated by C++ with the OnEvent function call
	if (event == 0) then --Study
		
		x1,y1 = L_GetPosition()
		x2,y2 = L_GetActiveVesselPosition()
		distance = CheckDistance( x1, y1, x2, y2)
		if (distance < loadrange) then
			L_CreateTimer("                    Studying...",100)
			L_PostMessage(0, 255, 0,"You begin to study the ruin")
			L_StopSound("scanning")
			L_PlayLoopingSound("scanning")
		else
			L_PostMessage(0, 0, 255,"You are not close enough to the ruin")
		end
		
	elseif (event == 70196) then   --0x0ddba11 (cute) this happens when timer runs out
		x1,y1 = L_GetPosition()
		x2,y2 = L_GetActiveVesselPosition()
		distance = CheckDistance( x1, y1, x2, y2)
		if (distance < loadrange) then
		
			--note: ruins are not picked up, only examined so a message can be displayed
		
			--display ruin message
			L_PostMessage(0, 255, 0,"You have finished studying the " .. L_GetName() .. ".")
			desc = L_GetDescription()
			L_PostMessage(200,200,0, desc)
			
		else
			L_PostMessage(0, 0, 255,"You are too far away!")
		end
	end	
end


function ruinScan()
	message = "SCANNER READOUT"
	L_PostMessage(255, 255, 0, message)

	message = "Name: " .. L_GetName()
	L_PostMessage(message)

	message = "You have discovered a RUIN site!"
	L_PostMessage(message)

	ruinGetActions()
end


function ruinCollisionOccurred()
	L_Debug("artifactCollisionOccurred")
end
