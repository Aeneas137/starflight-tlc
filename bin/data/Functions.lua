-- Useful Functions --

TORADIANS = 0.0174532925
PI = 3.1415926535
math.randomseed( os.time() )

function CheckDistance( x1, y1, x2, y2)

	distance = math.sqrt( ((x2 - x1) * (x2 - x1)) + ((y2 - y1) * (y2 - y1)) )

	return distance
end


function AngleBetweenTwoPoints(x1, y1, x2, y2)

	angle = math.atan2(y2 - y1, x2 - x1) * 180/PI
	return angle
end

function TrimAngle(angle2)
	if (angle2 > 360) then
		angle2 = angle2 - 360
	elseif (angle2 < 0) then
		angle2 = 360 + angle2
	end
	return angle2
end

function clockwise(sourceX, sourceY, destinationX, destinationY, rotation)

	--Convert clockwise from up to C-clockwise from right
	rotInDegrees = rotation

	--Calculate x,y straight out from source x,y at a distance of 10
	P3x = sourceX + math.cos(rotInDegrees * TORADIANS)*500
	P3y = sourceY + math.sin((rotInDegrees * -1) * TORADIANS)*500

	--Calculate clockwise-ness
	edge1x = destinationX-sourceX
	edge1y = destinationY-sourceY
	edge2x = P3x-sourceX
	edge2y = P3y-sourceY

	if ((edge1x * edge2y - edge1y * edge2x) >= 0) then
		return true
	else 
		return false
	end
end


function shiftRotate(rotation)

	rotation = (rotation * -1) + 90
	if (rotation < 0) then
		rotation = rotation + 360
	end
	return rotation
end
