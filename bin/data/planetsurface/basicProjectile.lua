-- basicProjectile SCRIPT FILE

function basicProjectileInitialize( )
	C_LoadImage("data\\planetsurface\\stun.tga")
	C_SetDamage(2)
	C_SetHealth(60)
	C_SetColHalfWidth(12)
	C_SetColHalfHeight(12)
	C_SetAlpha(true)
	C_SetSpeed(14)
	C_SetObjectType(22)
end

function basicProjectileUpdate( )
end

function basicProjectileTimedUpdate( )

	health = C_GetHealth()

	if (health > 0) then
	
		health = health - 1
		C_SetHealth(health)

		C_Move()
		C_Draw()
	else
		C_SetAlive(false)
	end
end

function basicProjectileOnEvent()
	--event should be instantiated by C++ with the OnEvent function call
	--projectiles don't use OnEvent()
end


function basicProjectileScan()
end


function basicProjectileCollisionOccurred()

	-- C++ will initialize a few variables when calling this function
	-- adjustment, otherCOx, otherCOy, axis, otherCOid, otherCOtype 

	threshold1, threshold2, threshold3 = C_GetThresholds() --We saved the parents id in threshold1

	if (otherCOid ~= 22 and (otherCOtype == 0 or otherCOtype == 23) and otherCOid ~= threshold1) then
		--BOOM!

		damage = C_GetDamage()
		C_SetAlive(false)

		-- Now lets make the other CO feel it
		C_LoadCObyID(otherCOid) -- this makes all the gets and sets talk to the other CO
		

		health = C_GetHealth()

		if (health > 0) then
	
			health = health - damage 
			C_SetHealth(health)
		end
	end
end
