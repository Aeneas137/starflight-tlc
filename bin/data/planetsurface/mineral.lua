-- MINERAL SCRIPT FILE

L_Debug("mineral.lua script loading")

loadrange = 64


function mineralInitialize( )

-- the Damage property here is used to specify the cubic meters of ore at the deposit

	id = L_GetItemID()
	
	L_Debug("  mineralInitialize: ItemID = " .. tostring(id) )
	

	--cheaper ores are more numerous
	if (id <= 40) then
		L_LoadImage("data/planetsurface/ore_sprite.tga")
		L_SetDamage(math.random(1, 4))
		
	--rare ores are less numerous
	elseif (id <= 54) then
		L_LoadImage("data/planetsurface/ore_sprite.tga")
		L_SetDamage(math.random(1, 3))
		
	--endurium uses it's own image
	elseif (id == 54) then --endurium
		L_LoadImage("data/planetsurface/endurium_sprite.tga")
		L_SetDamage(math.random(1, 2))
	end

	L_SetColHalfWidth(19)
	L_SetColHalfHeight(19)

	L_SetObjectType(1)
	L_SetAlpha(true)

end

function mineralUpdate( )
end

function mineralTimedUpdate( )
	L_Draw()
end

function mineralGetActions()
	
	scanned = L_IsScanned()

	if (scanned) then
		L_SetActions("Mine")
	else
		L_SetActions()
	end

end


function mineralOnEvent()

	--event should be instantiated by C++ with the OnEvent function call

	if (event == 0) then --Mine
		
		x1,y1 = L_GetPosition()
		x2,y2 = L_GetActiveVesselPosition()
		distance = CheckDistance( x1, y1, x2, y2)
		if (distance < loadrange) then
			damage = L_GetDamage() --I'm using damage as a way to hold the number of ore this deposit has

			if ( damage ~= 0 ) then
				if (L_CheckInventorySpace(1)) then
					
					L_CreateTimer("                    Extracting",100)
					L_PostMessage(0, 255, 0,"You begin to extract minerals from the deposit")
					L_StopSound("mining")
					L_PlayLoopingSound("mining")
				else
					L_PostMessage(0, 0, 255,"There is no free space in the hold!")
				end
			end
		else
			L_PostMessage(0, 0, 255,"You are not close enough to mine from the mineral deposit")
		end

	elseif (event == 70196) then   --0x0ddba11
		
		x1,y1 = L_GetPosition()
		x2,y2 = L_GetActiveVesselPosition()
		distance = CheckDistance( x1, y1, x2, y2)

		if (distance < loadrange) then
			
			--damage = cubic meters of ore 
			damage = L_GetDamage() 
			
			--extract 1 unit at a time
			amount = 1 -- damage * .1
			
			--"damage" = total cubic meters
			damage = damage - amount
			L_AddItemtoCargo(amount, L_GetItemID())
			L_SetDamage(damage)
			L_PostMessage(0, 255, 0,"You succesfully extracted " .. amount .. " " .. L_GetName())
			
			if (damage == 0) then
				L_PostMessage(0, 100, 225,"This mineral deposit is now depleted")
				L_DeleteSelf()
			end
		else
			L_PostMessage(0, 0, 255,"You are not close enough to extract minerals from the desposit")
		end

	end	
end


function mineralScan()

	message = "SCANNER READOUT"
--	L_PostMessage(b, g, r, text)
	L_PostMessage(255, 255, 0, message)

	message = "Name: " .. L_GetName()
	L_PostMessage(message)

	message = "Worth: " .. L_GetValue() .. " MU per ore"
	L_PostMessage(message)

	message = "Amount Present: " .. L_GetDamage() .. " ore"
	L_PostMessage(message)

	if ( L_IsShipRepairMetal() ) then
		if ( not(L_IsBlackMarketItem()) ) then
			message = "This mineral is useful to repair ships"
		else
			message = "This mineral is useful to repair ships and fetches a high price on the black market"
		end
	elseif ( L_GetItemID() == 54 ) then -- id #54 is endurium
		message = "This is a highly valuable fuel resource"
	else
		if ( L_IsBlackMarketItem() ) then
			message = "This mineral fetches a high price on the black market"
		else
			message = "You have no use for this mineral but others value it"
		end
	end

	L_PostMessage(message)

	mineralGetActions()
	--L_ShowPortrait("mineral") 
end


function mineralCollisionOccurred()

	--I couldn't of collided with anything! I don't move!!?!?!?!
end
