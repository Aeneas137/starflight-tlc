-- BASIC LIFEFORM SCRIPT FILE

L_Debug("basicLifeForm.lua script loading")

loadrange = 64


function basicLifeFormInitialize( )

	L_Debug("  basicLifeFormInitialize: ItemID = " .. tostring(L_GetItemID()) )
	L_Debug("    lifeform image = " .. InitImagetoLoad )

	L_LoadImage(InitImagetoLoad)

	L_SetAngleOffset(InitAngleOffset)
	L_SetScale(InitScale)
	L_SetFaceAngle(InitFaceAngle)

	L_SetColHalfWidth(InitColHalfWidth)
	L_SetColHalfHeight(InitColHalfHeight)

	--L_SetObjectType(InitObjectType)
	L_SetObjectType(0)
	
	if (InitPortraitName ~= "" and InitPortraitImage ~= "") then
		L_LoadPortrait(InitPortraitName, InitPortraitImage)
	end
	
	L_SetMaxHealth(L_GetItemSize() * 5)
	L_SetHealth(L_GetMaxHealth())
	
	L_SetAlpha(true)
	
end


function basicLifeFormUpdate( )
end


function basicLifeFormTimedUpdate( )

	WanderWait = 40

	count = L_GetStunCount()
	size = L_GetItemSize()

	if (count < size + 1) then

		speed = L_GetSpeed()
		if (speed > 0) then

			counter1, counter2, counter3 = L_GetCounters()
			state = L_GetState()
			if (state == -1) then
				x1,y1 = L_GetPosition()
				x2,y2 = L_GetActiveVesselPosition()

				angle = AngleBetweenTwoPoints(x1, y1, x2, y2)
				angle = angle + 180

				TrimAngle(angle)
				L_SetFaceAngle(angle)

				-- 1 degree = 0.0174532925 radians
				L_SetVelocity(math.cos(angle * 0.0174532925), math.sin(angle * 0.0174532925))

				distance = CheckDistance( x1, y1, x2, y2)
				if (distance > 300) then
					L_SetState(0)
				end

			elseif (state == 0) then

				x1,y1 = L_GetPosition()

				if (L_GetVesselMode() > 0) then
					x2,y2 = L_GetPlayerTVPosition()
				else
				    x2,y2 = L_GetPlayerShipPosition()
				end

				distance = CheckDistance( x1, y1, x2, y2)


				danger = L_GetDanger()
				if (danger == 0 and distance < 300) then

						L_SetState(-1)

				elseif (danger >= 1 and distance < 300 ) then

					if (L_GetVesselMode() ~= 0 and L_PlayerTVisAlive()) then

						threshold1, threshold2, threshold3 = L_GetThresholds()
						L_SetThresholds(x,y,threshold3)
						if (danger == 1) then

							L_SetState(1)
						elseif (danger > 1) then

							speed = L_GetSpeed()
							L_SetSpeed(speed * 1.1)
							L_SetState(2)
						end
					end
				else

					counter1 = counter1 + 1
					if (counter1 == WanderWait) then

						angle = math.random(360)
						L_SetVelocity(math.cos(angle * 0.0174532925), math.sin(angle * 0.0174532925))
						counter1 = 0
						L_SetFaceAngle(angle)
					end

					L_SetCounters(counter1, counter2, counter3)

				end

			elseif (state == 1 or state == 2) then

				x1,y1 = L_GetPosition()
				x2,y2 = L_GetPlayerTVPosition()

				angle = AngleBetweenTwoPoints(x1, y1, x2, y2)
				L_SetFaceAngle( angle )
				
				L_SetVelocity(math.cos(angle * TORADIANS), math.sin(angle * TORADIANS))

				threshold1, threshold2, threshold3 = L_GetThresholds() --threshold1 and 2 are the position of the state change
				distance = CheckDistance( x1, y1, threshold1, threshold2)

				if (distance > 300 or not(L_PlayerTVisAlive()) or L_GetVesselMode() == 0) then

					if (state == 1) then
						L_SetSpeed(L_GetSpeed())
					else
						L_SetSpeed(L_GetSpeed()/1.1)
					end
					L_SetState(0)
				end
			end

			L_Move()
		end
	end


	threshold1, threshold2, threshold3 = L_GetThresholds()
	if (threshold3 > 0) then
		threshold3 = threshold3 - 1
	end
	L_SetThresholds(threshold1,threshold2,threshold3)

	health = L_GetHealth()
	if (health <= 0) then
		L_PostMessage(0, 0, 255, "The " .. L_GetName() .. " Died")
		L_DeleteSelf()
	else
		L_Draw()
	end
end


function basicLifeFormGetActions()

	scanned = L_IsScanned()

	if (scanned) then
		if (L_GetSpeed() == 0) then
		    L_SetActions("Gather","Stun") --Remember you want to list them in reverse order
		else
		    L_SetActions("Capture","Stun") --Remember you want to list them in reverse order
		end
	else
		L_SetActions("Stun")
	end

end

function basicLifeFormOnEvent()

	--event should be instantiated by C++ with the OnEvent function call

	if (event == 0) then --Stun
		myID = L_GetID()
		PlayerTVStun()
		L_LoadPSObyID(myID)

		state = L_GetState()
		if (state == 0) then
			danger = L_GetDanger()
			if ( danger == 0 ) then
				L_SetState(-1)

			elseif ( danger == 1 ) then

				L_SetState(1)
				x,y = L_GetPosition()
				threshold1, threshold2, threshold3 = L_GetThresholds()
				L_SetThresholds(x,y,threshold3)

			elseif ( danger >= 2 ) then

				L_SetState(2)
				x,y = L_GetPosition()
				threshold1, threshold2, threshold3 = L_GetThresholds()
				L_SetThresholds(x,y,threshold3)
				speed = L_GetSpeed()
				L_SetSpeed(speed * 1.1)
			end
		end

	elseif (event == 1) then --Capturing

		if (L_GetSpeed() > 0) then
			x1,y1 = L_GetPosition()
			x2,y2 = L_GetActiveVesselPosition()
			distance = CheckDistance( x1, y1, x2, y2)

			if (distance < loadrange) then
				count = L_GetStunCount()
				size = L_GetItemSize()
				if (count >= size + 1) then
					if (L_CheckInventorySpace(1)) then
						L_CreateTimer("                    Capturing",100)
						L_PostMessage(255, 0, 0,"You begin to load the " .. L_GetName() .." into your Terrain Vehicle")
						L_StopSound("pickuplifeform")
						L_PlayLoopingSound("pickuplifeform")
					else
						L_PostMessage(0, 0, 255,"There is no free space in the hold!")
					end
				else
					L_PostMessage(255, 0, 0,"You must stun the lifeform before you can load it")
				end
			else
				L_PostMessage(255, 0, 0,"You are not close enough to load the " .. L_GetName())
			end
		else
			if (L_CheckInventorySpace(1)) then
				L_CreateTimer("                    Gathering",100)
				L_PostMessage(255, 0, 0,"You begin to load the " .. L_GetName() .." into your Terrain Vehicle")
				L_StopSound("pickuplifeform")
				L_PlayLoopingSound("pickuplifeform")
			else
				L_PostMessage(0, 0, 255,"There is no free space in the hold!")
			end
		end

	elseif (event == 70196) then   --0x0ddba11
		x1,y1 = L_GetPosition()
		x2,y2 = L_GetActiveVesselPosition()
		distance = CheckDistance( x1, y1, x2, y2)

		if (distance < loadrange) then
			L_PostMessage(255, 0, 0,"You load the " .. L_GetName() .." into your Terrain Vehicle")
			L_AddItemtoCargo(L_GetItemID())
			L_DeleteSelf()
		else
			L_PostMessage(255, 0, 0,"You are not close enough to load the " .. L_GetName())	
		end

	end	
end

function basicLifeFormScan()

	message = "SCANNER READOUT"
--	L_PostMessage(b, g, r, text)
	L_PostMessage(255, 255, 0, message)

	message = "Name: " .. L_GetName()
	L_PostMessage(message)

--	message = "Value: " .. L_GetValue() .. " MU"
--	L_PostMessage(message)

	speed = L_GetSpeed()
	if (speed == 0) then
		message = "Mobility: None"
	elseif (speed < 3) then
		message = "Mobility: Slow"
	else
		message = "Mobility: Fast"
	end
	L_PostMessage(message)


	danger = L_GetDanger()
	if (danger == 0) then
		message = "Danger: Harmless"
	elseif (danger == 1) then
		message = "Danger: Minimal"
	elseif (danger == 2) then
		message = "Danger: High"
	else
		message = "Danger: Extreme"
	end
	L_PostMessage(message)

	message = L_GetDescription()
	if (message) then L_PostMessage(message) end

	basicLifeFormGetActions()
	L_ShowPortrait("basicLifeForm") 
end

function basicLifeFormCollisionOccurred()

	-- C++ will initialize a few variables when calling this function
	-- adjustment, otherPSOx, otherPSOy, axis, otherPSOid

	LifeFormAttackRate = 20

	if (otherPSOtype ~= 2) then
		x,y = L_GetPosition()

		-- 0 = x axis, 1 = y axis
		if (axis == 0) then
		
			if (otherPSOx > x) then
				L_SetPosition(x - adjustment, y)
			else
				L_SetPosition(x + adjustment, y)
			end
		else

			if (otherPSOy > y) then
				L_SetPosition(x, y  - adjustment)
			else
				L_SetPosition(x, y  + adjustment)
			end
		end
		
		if (otherPSOtype == -1) then
			threshold1, threshold2, threshold3 = L_GetThresholds()
			
			if (threshold3 == 0) then
				danger = L_GetDanger()
				if (danger >= 1) then
					damage = L_GetDamage()
					L_AttackTV(damage)
					threshold3 = LifeFormAttackRate
					L_SetThresholds(threshold1,threshold2,threshold3)
				end
			end
		end
	end
end
