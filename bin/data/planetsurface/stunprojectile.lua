-- stunprojectile SCRIPT FILE

function stunprojectileInitialize( )
	L_LoadImage("data/planetsurface/stun.tga")
	L_SetDamage(2)
	L_SetColHalfWidth(12)
	L_SetColHalfHeight(12)
	L_SetAlpha(true)
	L_SetHealth(60)
	L_SetSpeed(18)
	x,y = L_GetActiveVesselPosition()
	L_SetPosition(x,y)
	L_SetObjectType(2)
end

function stunprojectileUpdate( )
end

function stunprojectileTimedUpdate( )
	--Put homing code here
	health = L_GetHealth()
	if (health > 0) then
		health = health - 1
		L_SetHealth(health)
		L_Move()
		L_Draw()
	else
		L_DeleteSelf()
	end
end


function stunprojectileGetActions()
	--projectiles don't have actions! they just go BOOM!
end

function stunprojectileOnEvent()
	--event should be instantiated by C++ with the OnEvent function call
	--projectiles don't use OnEvent()
end

function stunprojectileScan()
end

function stunprojectileCollisionOccurred()

	-- C++ will initialize a few variables when calling this function
	-- adjustment, otherPSOx, otherPSOy, axis, otherPSOid, otherPSOtype 


	if (otherPSOid ~= -1 and otherPSOtype == 0) then
		--BOOM!

		damage = L_GetDamage()
		L_DeleteSelf()

		-- Now lets make the other PSO feel it
		L_LoadPSObyID(otherPSOid) -- this makes all the gets and sets talk to the other PSO
		

		health = L_GetHealth()

		if (health > 0) then
	
			health = health - damage 
			L_SetHealth(health)
			
			if (health <= 0) then
				L_KilledAnimal(L_GetItemID())
			end
		end

		count = L_GetStunCount()
		count = count + 1
		L_SetStunCount(count)
	end
end
