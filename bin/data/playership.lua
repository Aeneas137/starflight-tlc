-- Script file for handling player's ship

--these were replaced with generic engine class properties shared by all ships
--maximum_velocity = 4.0
--forward_thrust = 0.08
--reverse_thrust = 0.2
--lateral_thrust = 0.05
--turn_rate = 2.0

-- constants used to apply braking
stop_threshold = 0.05
brake_value = 0.01

-- velocity_x and velocity_y are set by caller

function applybraking()
    speed = math.sqrt(velocity_x*velocity_x + velocity_y*velocity_y)
    dir = math.atan2(velocity_y,velocity_x)
    if math.abs(speed) < stop_threshold then
		speed = 0.0
    else
        if speed > 0 then
            speed = speed - brake_value
        else
            speed = speed + brake_value
        end
    end
    velocity_x = speed * math.cos(dir)
    velocity_y = speed * math.sin(dir)
end

function limitvelocity()
    if velocity_x > maximum_velocity then
        velocity_x = maximum_velocity
    end
    if velocity_x < -maximum_velocity then
        velocity_x = -maximum_velocity
    end
    if velocity_y > maximum_velocity then
        velocity_y = maximum_velocity
    end
    if velocity_y < -maximum_velocity then
        velocity_y = -maximum_velocity
    end
end
