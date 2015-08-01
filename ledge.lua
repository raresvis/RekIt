ledge = {}

function ledge.load()
	ledge.height = 40
	ledge.padding = 3 * ledge.height

	ledge.timer = 0
	ledge.timerMin = 1
	ledge.timerMax = 1.7
	ledge.timerLimit = math.random(ledge.timerMin, ledge.timerMax)
	ledge.overlapTimeProportion = 0.9
	ledge.screenPaddingProportion = 0

	ledge.speed = 200
end

function ledge.spawn(x, y, width)
	table.insert(ledge, {x = x, y = y, width = width, height = ledge.height})
end

function ledge.draw()
	for i, v in ipairs(ledge) do
		--love.graphics.setColor(0, 150, 0)
		love.graphics.setColor(51, 51, 255)
		love.graphics.rectangle('fill', v.x, v.y, v.width, v.height)
	end

	--love.graphics.setColor(0, 255, 0, 255)
	--love.graphics.print(screenWidth, 10, 200)
end

function ledge.move(dt)
	for i, v in ipairs(ledge) do
		v.x = v.x - ledge.speed * dt
	end
end

function ledge.generate(dt)
	ledge.timer = ledge.timer + dt
	if ledge.timer > ledge.timerLimit then
		vertical_position = math.random(ledge.screenPaddingProportion * screenHeight, ( 1 - ledge.screenPaddingProportion ) * screenHeight - ledge.height)

		ok = 1

		for i, v in ipairs(ledge) do
			distance = math.abs(vertical_position - v.y)

			if distance < v.height + ledge.padding then
				ledge.timer = ledge.overlapTimeProportion * ledge.timerLimit
				ok = 0
				break
			end
		end

		if ok == 1 then
			for i, v in ipairs(enemy) do
				distance = math.abs(vertical_position - v.y)

				max_height = math.max(v.height, ledge.height)

				if distance < max_height + ledge.padding then
					ledge.timer = ledge.overlapTimeProportion * ledge.timerLimit
					ok = 0
					break
				end
			end

			if ok == 1 then
				ledge.spawn(screenWidth, vertical_position, 300)

				ledge.timer = 0
				ledge.timerLimit = math.random(ledge.timerMin, ledge.timerMax)
			end
		end
	end
end


function ledge.collision()
	for i, v in ipairs(ledge) do
		--Collision with the ball
		--if ((ball.x + ball.radius > v.x and ball.x + ball.radius < v.x + v.width) or (ball.x - ball.radius > v.x and ball.x - ball.radius < v.x + v.width)) and
		--	((ball.y - ball.radius > v.y and ball.y - ball.radius < v.y + v.height) or (ball.y + ball.radius > v.y and ball.y + ball.radius < v.y + v.height)) then
		--		ball.y = v.y - ball.radius
		--		ball.yvel = 0
		--end

		--On the left of the ledge
		if (ball.x + ball.radius > v.x and ball.x + ball.radius < v.x + v.width) and (ball.y > v.y and ball.y < v.y + v.height) then
			ball.x = v.x - ball.radius
			ball.xvel = ball.collisionSpeed
		end
		--On the right of the ledge
		if (ball.x - ball.radius > v.x and ball.x - ball.radius < v.x + v.width) and (ball.y > v.y and ball.y < v.y + v.height) then
			--do nothing
			ball.x = v.x + v.width + ball.radius
		end
		--Below the ledge
		if (ball.y - ball.radius > v.y and ball.y - ball.radius < v.y + v.height) and (ball.x > v.x and ball.x < v.x + v.width) then
			ball.y = v.y + v.height + ball.radius
			ball.yvel = 0
		end
		--On the ledge
		if (ball.y + ball.radius > v.y and ball.y + ball.radius < v.y + v.height) and (ball.x > v.x and ball.x < v.x + v.width) then
			ball.y = v.y - ball.radius
			ball.yvel = 0
		end

		--UNDEFINED REGIONS(pitagora?!)

		distance_Ox = ball.x - v.x
		distance_Oy = ball.y - v.y

		--Upper left corner of the ledge
		if ball.radius ^ 2 > distance_Ox ^ 2 + distance_Oy ^ 2 then
			--Upper half of 4th quadrant
			if math.abs(distance_Ox) > math.abs(distance_Oy) then
				ball.x = v.x - ball.radius
				ball.xvel = ball.collisionSpeed
			--Lower half of the 4th quadrant
			else
				ball.y = v.y - ball.radius
				ball.yvel = 0
			end
		end

		--Upper right corner of the ledge
		if ball.radius ^ 2 > (distance_Ox - v.width) ^ 2 + distance_Oy ^ 2 then
			--Upper half of the 3rd quadrant
			if math.abs(distance_Ox - v.width) > math.abs(distance_Oy) then
				--do nothing
				ball.yvel = 0
			--Lower half of the 3rd quadrant
			else
				ball.yvel = 0
			end
		end

		--Lower left corner of the ledge
		if ball.radius ^ 2 > distance_Ox ^ 2 + (distance_Oy - v.height) ^ 2 then
			--Upper half of the first quadrant
			if math.abs(distance_Ox) < math.abs(distance_Oy - v.height) then
				ball.y = v.y + v.height + ball.radius
				ball.yvel = 0
				ball.xvel = ball.collisionSpeed
			--Lower half of the first quadrant
			else
				ball.x = v.x - ball.radius
				ball.xvel = ball.collisionSpeed
			end
		end

		--Lower right corner of the ledge
		if ball.radius ^ 2 > (distance_Ox - v.width) ^ 2 + (distance_Oy - v.height) ^ 2 then
			--Upper half of the second quadrant
			if math.abs(distance_Ox - v.width) < math.abs(distance_Oy - v.height) then
				ball.y = v.y + v.height + ball.radius
				ball.yvel = 0
			--Lower half of the second quadrant
			else
				ball.yvel = 0
			end
		end

		--delete ledge if it exits the screen
		if v.x + v.width < 0 then
			table.remove(ledge, i)
		end
	end
end

--Parent Functions

function DRAW_LEDGE()
	ledge.draw()
end


function UPDATE_LEDGE(dt)
	ledge.generate(dt)
	ledge.move(dt)
	ledge.collision()
end
