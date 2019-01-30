-- Metneb Factory SCRIPT FILE



function MetnebFactoryInitialize( )

	L_LoadImage("data\\planetsurface\\B_Factory.tga")

	L_SetColHalfWidth(40)
	L_SetColHalfHeight(40)

	L_SetObjectType(10)

	L_SetAlpha(true)

	L_SetName("Metneb Factory")
	L_SetPosition(16000,2500)
	
	L_SetMinimapColor(16711680) -- Blue
	L_SetMinimapSize(2)
end



function MetnebFactoryUpdate( )

	
end


function MetnebFactoryTimedUpdate( )


	L_Draw()
end


function MetnebFactoryGetActions()
	
	scanned = L_IsScanned()

	if (scanned) then
		L_SetActions("Visit") --Remember you want to list them in reverse order
	end

end

function MetnebFactoryOnEvent()

	--event should be instantiated by C++ with the OnEvent function call

	if (event == 0) then --Visit
		L_PostMessage(255, 0, 0,"The Metneb Factory is not allowing visits at this time.")

	end	
end

function MetnebFactoryScan()

	message = "SCANNER READOUT"
--	L_PostMessage(b, g, r, text)
	L_PostMessage(255, 255, 0, message)

	message = "Name: " .. L_GetName()
	L_PostMessage(message)
	
	message = "Description: The Metneb Factory of Ciuin is a processing facility that takes in many raw materials and creates a plethora of different items for Myrrdan. From Interstellar Ship Plating to Domestic Refrigeration Containers, Metneb creates everyday items and top of the line products daily at this facility."
	L_PostMessage(message)

	MetnebFactoryGetActions()
end

function MetnebFactoryCollisionOccurred()

	--I will never run into anyone since I don't move!

	
end