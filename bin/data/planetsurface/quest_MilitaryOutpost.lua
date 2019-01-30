-- MilitaryOutpost SCRIPT FILE



function MilitaryOutpostInitialize( )

	L_LoadImage("data\\planetsurface\\B_WeaponsPlacement.tga")

	L_SetColHalfWidth(40)
	L_SetColHalfHeight(40)

	L_SetObjectType(10)

	L_SetName("Military Outpost")
	L_SetPosition(2000,15000)

	L_SetMinimapColor(16711680) -- Blue
	L_SetMinimapSize(2)

	L_SetAlpha(true)

	L_SetColHalfWidth(60)
	L_SetColHalfHeight(50)

end



function MilitaryOutpostUpdate( )


end


function MilitaryOutpostTimedUpdate( )


	L_Draw()
end


function MilitaryOutpostGetActions()

	scanned = L_IsScanned()

	if (scanned) then
		L_SetActions("Visit") --Remember you want to list them in reverse order
	end

end

function MilitaryOutpostOnEvent()

	--event should be instantiated by C++ with the OnEvent function call

	if (event == 0) then --Visit
		L_PostMessage(255, 0, 0,"The Dereon Mining Facility is not allowing visits at this time.")

	end
end

function MilitaryOutpostScan()

	message = "SCANNER READOUT"
--	L_PostMessage(b, g, r, text)
	L_PostMessage(255, 255, 0, message)

	message = "Name: " .. L_GetName()
	L_PostMessage(message)

	message = "Description: The Military Outpost on was created in 4620 as a reliable storage facility for the cache of Interplanetary Ballistic Missiles soon to enter production. Since then it has also become a testing ground for new military technologies and tactics."
	L_PostMessage(message)

	MilitaryOutpostGetActions()
end

function MilitaryOutpostCollisionOccurred()

	--I will never run into anyone since I don't move!


end