-- PLANET SURFACE PLAYER SHIP FILE --

function PlayerShipInitialize( )

	prof = L_GetPlayerProfession()

	--PROFESSION_SCIENTIFIC = 1
	if (prof == 1) then
		L_LoadImage("data/planetsurface/ship_science.bmp")

	--PROFESSION_FREELANCE = 2
	elseif (prof == 2) then
		L_LoadImage("data/planetsurface/ship_freelance.bmp")

	--PROFESSION_MILITARY = 4 and is the default
	else 
		L_LoadImage("data/planetsurface/ship_military.bmp")
	end
			

	--Lua Example: L_SetAnimInfo(FrameWidth, FrameHeight, AnimColumns, TotalFrames, CurFrame) 

	L_SetAnimInfo(64, 64, 8, 8, 0)
	L_SetAngleOffset(90)

	width, height = L_GetScreenDim() 
	x,y = L_GetScrollerPosition() 
	
	L_SetPosition(x + width/2 - 32, y + height/2 - 128 - 32)

	L_SetScale(2)

	L_SetColHalfWidth(22)
	L_SetColHalfHeight(22)
	
	L_SetObjectType(-2)
end

function PlayerShipUpdate( )
end

function PlayerShipTimedUpdate( )

		maxscale = 2
		minscale = 1.9
		scale = L_GetScale()

		speed = L_GetSpeed()
		rot = 1
		angle = L_GetFaceAngle()
		turnRate = 2
		maxspeed = 24
		scalerot = 1
		
		counter1, counter2, counter3 = L_GetCounters()
		threshold1, threshold2, threshold3 = L_GetThresholds()

		counter1 = counter1 + 1
		if (counter1 == 3) then
			if (scale == maxscale) then
				threshold1 = scalerot * -1
			elseif (scale <= minscale) then
				threshold1 = scalerot
			end
			scale = scale + threshold1/100
			counter1 = 0
		end

		L_SetScale(scale)
		L_SetCounters(counter1, counter2, counter3)
		L_SetThresholds(threshold1, threshold2, threshold3)


		if (L_GetVesselMode() == 0 or L_GetVesselMode() == 2) then
			forwardThrust, reverseThrust, turnLeft, turnRight = L_GetPlayerNavVars()

			if (forwardThrust and speed < maxspeed) then
				speed = speed + rot

			elseif (reverseThrust and math.abs(speed) < maxspeed) then
				speed = speed - rot

			elseif (speed ~= 0) then
				speed = speed - ((rot/4) * (speed / math.abs(speed) ))
			end


			if (turnLeft) then
				angle = angle - turnRate
			end

			if (turnRight) then
				angle = angle + turnRate
			end

   			TrimAngle(angle)

			L_SetVelocity(math.cos(angle * 0.0174532925), math.sin(angle * 0.0174532925))
			L_SetSpeed(speed)
			L_SetFaceAngle(angle)
	
			L_Move()
		end
	
		L_Draw()

end

function PlayerShipCollisionOccurred()

	-- C++ will initialize a few variables when calling this function
	-- adjustment, otherPSOx, otherPSOy

	-- PlayerShip doesn't check for collision, unless it is on the ground
	if (L_GetVesselMode() == 1) then
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
	end
end

