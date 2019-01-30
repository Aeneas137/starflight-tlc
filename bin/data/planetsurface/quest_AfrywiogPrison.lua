-- AfrywiogPrison SCRIPT FILE



function AfrywiogPrisonInitialize( )

	L_LoadImage("data\\planetsurface\\B_Metropolis.tga")

	L_SetColHalfWidth(40)
	L_SetColHalfHeight(40)

	L_SetObjectType(10)

	L_SetName("Afrywiog Prison Colony")
	L_SetPosition(28000,28000)

	L_SetMinimapColor(16711680) -- Blue
	L_SetMinimapSize(2)

	L_SetAlpha(true)

	L_SetColHalfWidth(60)
	L_SetColHalfHeight(50)

end



function AfrywiogPrisonUpdate( )


end


function AfrywiogPrisonTimedUpdate( )


	L_Draw()
end


function AfrywiogPrisonGetActions()

	scanned = L_IsScanned()

	if (scanned) then
		L_SetActions("Visit") --Remember you want to list them in reverse order
	end

end

function AfrywiogPrisonOnEvent()

	--event should be instantiated by C++ with the OnEvent function call

	if (event == 0) then --Visit
		L_PostMessage(255, 0, 0,"The Afrywiog Prison Colony is not allowing visits at this time.")

	end
end

function AfrywiogPrisonScan()

	message = "SCANNER READOUT"
--	L_PostMessage(b, g, r, text)
	L_PostMessage(255, 255, 0, message)

	message = "Name: " .. L_GetName()
	L_PostMessage(message)

	message = "Description: Afrywiog was created in the year 4598 by Cystal to serve as a hellish inescapable prison for the world's most vile and infamous. Prisoners are allowed to leave the facility after serving over half their time if they so desire because the chances of independent survival in Diar-Mait are less than .05%. This ensures that the Harsh Mistress, as it is often called, is never full and the Brescin Fireling's always have something to play with."

	L_PostMessage(message)

	AfrywiogPrisonGetActions()
end

function AfrywiogPrisonCollisionOccurred()

	--I will never run into anyone since I don't move!


end