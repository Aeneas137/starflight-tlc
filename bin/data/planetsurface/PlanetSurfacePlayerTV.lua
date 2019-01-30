-- PLANET SURFACE PLAYER TV FILE --

stunrange = 200
loadrange = 100


function PlayerTVInitialize( )
	
	L_LoadImage("data/planetsurface/Player_Rover.tga")

	L_SetAngleOffset(-90)

	L_SetColHalfWidth(19)
	L_SetColHalfHeight(19)

	L_SetObjectType(-1)
	L_SetHealth(100)
	L_SetCounters(0,0,100) --Counter3 is fuel

	L_SetAlpha(true)

	--Lua Example: L_SetAnimInfo(FrameWidth, FrameHeight, AnimColumns, TotalFrames, CurFrame) 

	L_SetAnimInfo(70, 70, 4, 4, 0)

	L_SetNewAnimation("walk", 0, 3, 2)
	L_SetActiveAnimation("walk")
	
end

function PlayerTVUpdate( )
end

function PlayerTVTimedUpdate( )
	
	speed = L_GetSpeed()
	rot = 1
	angle = L_GetFaceAngle()
	turnRate = 2
	maxspeed = 7

    counter1, counter2, counter3 = L_GetCounters()
	if (counter3 ~= 0 ) then
		forwardThrust, reverseThrust, turnLeft, turnRight = L_GetPlayerNavVars()
		--consume fuel (fuel = counter3) when moving
		if ( forwardThrust or reverseThrust ) then
			counter1 = counter1 + 1
			if (counter1 > 5) then
				counter1 = 0
				counter3 = counter3 - 1
				if (counter3 == 0) then
					L_TVOutofFuel()
					return
				end
			end
		end
		
		
		if (forwardThrust and speed < maxspeed) then
			speed = speed + rot

		--reverse goes half the speed of forward
		elseif (reverseThrust and math.abs(speed) < (maxspeed/2.0)  )  then
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

		--0.017.. radians = 1 degree
		L_SetVelocity(math.cos(angle * 0.0174532925), math.sin(angle * 0.0174532925))
		L_SetSpeed(speed)
		L_SetFaceAngle(angle)


		--if the TV is moving
		if (turnLeft or turnRight or speed ~=0) then
			L_Animate()
		end
		
	end

	--very important: counter3 is fuel
	L_SetCounters(counter1, counter2, counter3)
	
	L_Move()
	
	health = L_GetHealth()
	if (health <= 0) then
		L_PostMessage(0, 0, 255, "CAPTAIN! THE TERRAIN VEHICLE HAS BEEN DESTROYED!")
		L_SetAlive(false)
		L_TVDestroyed()
	else
		L_Draw()
	end

end

function PlayerTVStun()
	
	L_LoadPlayerTVasPSO()
	angle = L_GetFaceAngle()

	id = L_CreateNewPSO("stunprojectile") --This automatically loads this object
	
	x,y = L_GetActiveVesselPosition()
	L_SetPosition(x,y) 


	L_SetVelocity(math.cos(angle * 0.0174532925), math.sin(angle * 0.0174532925))
	
	L_PlaySound("stunner")
end


function PlayerTVCollisionOccurred()

	-- C++ will initialize a few variables when calling this function
	-- adjustment, otherPSOx, otherPSOy

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

		L_SetSpeed(0)
	end
end
