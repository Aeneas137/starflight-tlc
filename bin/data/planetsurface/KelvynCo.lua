-- Kelvyn Co SCRIPT FILE



function KelvynCoInitialize( )

	L_LoadImage("data\\planetsurface\\B_Research.tga")

	L_SetColHalfWidth(40)
	L_SetColHalfHeight(40)

	L_SetObjectType(10)

	L_SetName("Kelvyn Co. Research Outpost")
	L_SetPosition(6000,16000)
	
	L_SetMinimapColor(16711680) -- Blue
	L_SetMinimapSize(2)
	
	L_SetAlpha(true)
	
	L_SetColHalfWidth(60)
	L_SetColHalfHeight(50)

end



function KelvynCoUpdate( )

	
end


function KelvynCoTimedUpdate( )


	L_Draw()
end


function KelvynCoGetActions()
	
	scanned = L_IsScanned()

	if (scanned) then
		L_SetActions("Visit") --Remember you want to list them in reverse order
	end

end

function KelvynCoOnEvent()

	--event should be instantiated by C++ with the OnEvent function call

	if (event == 0) then --Visit
		L_PostMessage(255, 0, 0,"The Kelvyn Company Research Outpost is not allowing visits at this time.")

	end	
end

function KelvynCoScan()

	message = "SCANNER READOUT"
--	L_PostMessage(b, g, r, text)
	L_PostMessage(255, 255, 0, message)

	message = "Name: " .. L_GetName()
	L_PostMessage(message)
	
	message = "Description: The Kelvyn Company Research Outpost on Islay was the first extra-terrestrial commercial structure built by Myrrdanian hands in the year 4594. This place is home to many of Myrrdan's brightest scientists whom work at the cutting edge of our technology."
	L_PostMessage(message)

	KelvynCoGetActions()
end

function KelvynCoCollisionOccurred()

	--I will never run into anyone since I don't move!

	
end