-- DereonMine SCRIPT FILE



function DereonMineInitialize( )

	L_LoadImage("data\\planetsurface\\B_Mine.tga")

	L_SetColHalfWidth(40)
	L_SetColHalfHeight(40)

	L_SetObjectType(10)

	L_SetName("Dereon Mining Facility")
	L_SetPosition(20000,16000)
	
	L_SetMinimapColor(16711680) -- Blue
	L_SetMinimapSize(2)
	
	L_SetAlpha(true)
	
	L_SetColHalfWidth(60)
	L_SetColHalfHeight(50)

end



function DereonMineUpdate( )

	
end


function DereonMineTimedUpdate( )


	L_Draw()
end


function DereonMineGetActions()
	
	scanned = L_IsScanned()

	if (scanned) then
		L_SetActions("Visit") --Remember you want to list them in reverse order
	end

end

function DereonMineOnEvent()

	--event should be instantiated by C++ with the OnEvent function call

	if (event == 0) then --Visit
		L_PostMessage(255, 0, 0,"The Dereon Mining Facility is not allowing visits at this time.")

	end	
end

function DereonMineScan()

	message = "SCANNER READOUT"
--	L_PostMessage(b, g, r, text)
	L_PostMessage(255, 255, 0, message)

	message = "Name: " .. L_GetName()
	L_PostMessage(message)
	
	message = "Description: The Dereon Mining Facility is owned by a resource tycoon on Myrrdan. It was created to utilize the vast amounts of metals available on the asteroid. It has since been growing in size as the profit margin continues to reach new heights."
	L_PostMessage(message)

	DereonMineGetActions()
end

function DereonMineCollisionOccurred()

	--I will never run into anyone since I don't move!

	
end