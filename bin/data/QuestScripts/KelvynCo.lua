-- Kelvyn Co SCRIPT FILE


function KelvynCoGetActions()
	
	scanned = L_IsScanned()

	if (scanned) then
		L_SetActions("Deliver") --Remember you want to list them in reverse order
	end

end

function KelvynCoOnEvent()

	--event should be instantiated by C++ with the OnEvent function call

	if (event == 0) then --Visit
		L_PostMessage(255, 0, 0,"You deliver the Robots and Automatons. Return to the Starport for debriefing.")
		L_Interacted(0)
	end	
end

