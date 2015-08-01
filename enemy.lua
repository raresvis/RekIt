enemy = {}

function enemy.load()
	enemy.timer = 0
	enemy.timerMin = 0.7
	enemy.timerMax = 2
	enemy.timerLimit = math.random(enemy.timerMin, enemy.timerMax)
	enemy.overlapTimeProportion = 0.9
	enemy.amount = 0

	enemy.width = 50
	enemy.height = 50

	enemy.screenPaddingProportion = 0

	enemy.speed = 300
	enemy.friction = 7.5

	enemy.health = 3

	enemy.colorChangeStep = 75
end

function enemy.spawn(x, y)
	table.insert(enemy, {x = x, y = y, xvel = 0, yvel = 0, health = enemy.health, width = enemy.width, height = enemy.height})
end


function enemy.draw()
	for i, v in ipairs(enemy) do
		love.graphics.setColor(0 + (enemy.health - v.health) * enemy.colorChangeStep, 0 + (enemy.health - v.health) * enemy.colorChangeStep, 0 + (enemy.health - v.health) * enemy.colorChangeStep)

		love.graphics.rectangle('fill', v.x, v.y, v.width, v.height)
	end
end


-- function enemy.physics(dt)
-- 	for i, v in ipairs(enemy) do
-- 		--v.x = v.x + v.xvel * dt
-- 		--v.y = v.y + v.yvel * dt
-- 		--v.yvel = v.yvel + gravity * dt
-- 		--v.xvel = v.xvel * (1 - math.min(dt * enemy.friction, 1))
-- 		--v.yvel = v.yvel * (1 - math.min(dt * enemy.friction, 1))
-- 	end
-- end


function enemy.move(dt)
	for i, v in ipairs(enemy) do
		v.x = v.x - enemy.speed * dt
	end
end


function enemy.generate(dt)
	enemy.timer = enemy.timer + dt

	if enemy.timer > enemy.timerLimit then
		vertical_position = math.random(enemy.screenPaddingProportion * screenHeight, (1 - enemy.screenPaddingProportion) * screenHeight - enemy.height)

		ok = 1

		--Verify overlapping between enemy and ledge
		for i, v in ipairs(ledge) do
			distance = math.abs(vertical_position - v.y)

			max_height = math.max(enemy.height, v.height)

			if distance < max_height then
				enemy.timer = enemy.overlapTimeProportion * enemy.timerLimit
				ok = 0
				break
			end
		end

		if ok == 1 then
			enemy.spawn(screenWidth, vertical_position)

			enemy.timerLimit = math.random(enemy.timerMin, enemy.timerMax)
			enemy.timer = 0
		end
	end
end


function enemy.collision()
	for i, v in ipairs(enemy) do
		for ia, va in ipairs(bullet) do
			--Collision with the bullet
			if va.x + va.width > v.x and va.x < v.x + v.width and va.y + va.height > v.y and va.y < v.y + v.height then
				v.health = v.health - 1

				table.remove(bullet, ia)

				if v.health == 0 then
					table.remove(enemy, i)

					ball.score = ball.score + 1 / 10 * ball.scoreMultiplier
				end
			end
		end

		-----------------------------------------------------------------------------------------

		--On the left of the enemy
		if (ball.x + ball.radius > v.x and ball.x + ball.radius < v.x + v.width) and (ball.y > v.y and ball.y < v.y + v.height) then
			ball.x = v.x - ball.radius
			ball.xvel = ball.collisionSpeed

			table.remove(enemy, i)

			if ball.invincible == false then
				ball.health = ball.health - 1

				if ball.health == 0 then
					gamestate = 'lost'
				end
			end
		end
		--On the right of the enemy
		if (ball.x - ball.radius > v.x and ball.x - ball.radius < v.x + v.width) and (ball.y > v.y and ball.y < v.y + v.height) then
			--do nothing
			ball.x = v.x + v.width + ball.radius

			table.remove(enemy, i)

			if ball.invincible == false then
				ball.health = ball.health - 1

				if ball.health == 0 then
					gamestate = 'lost'
				end
			end
		end
		--Below the enemy
		if (ball.y - ball.radius > v.y and ball.y - ball.radius < v.y + v.height) and (ball.x > v.x and ball.x < v.x + v.width) then
			ball.y = v.y + v.height + ball.radius
			ball.yvel = 0

			table.remove(enemy, i)

			if ball.invincible == false then
				ball.health = ball.health - 1

				if ball.health == 0 then
					gamestate = 'lost'
				end
			end
		end
		--On the enemy
		if (ball.y + ball.radius > v.y and ball.y + ball.radius < v.y + v.height) and (ball.x > v.x and ball.x < v.x + v.width) then
			ball.y = v.y - ball.radius
			ball.yvel = 0

			table.remove(enemy, i)

			if ball.invincible == false then
				ball.health = ball.health - 1

				if ball.health == 0 then
					gamestate = 'lost'
				end
			end
		end

		--UNDEFINED REGIONS(pitagora?!)

		distance_Ox = ball.x - v.x
		distance_Oy = ball.y - v.y

		--Upper left corner of the enemy
		if ball.radius ^ 2 > distance_Ox ^ 2 + distance_Oy ^ 2 then
			--Upper half of 4th quadrant
			if math.abs(distance_Ox) > math.abs(distance_Oy) then
				ball.x = v.x - ball.radius
				ball.xvel = ball.collisionSpeed

				table.remove(enemy, i)

				if ball.invincible == false then
					ball.health = ball.health - 1

					if ball.health == 0 then
						gamestate = 'lost'
					end
				end
			--Lower half of the 4th quadrant
			else
				ball.y = v.y - ball.radius
				ball.yvel = 0

				table.remove(enemy, i)

				if ball.invincible == false then
					ball.health = ball.health - 1

					if ball.health == 0 then
						gamestate = 'lost'
					end
				end
			end
		end

		--Upper right corner of the enemy
		if ball.radius ^ 2 > (distance_Ox - v.width) ^ 2 + distance_Oy ^ 2 then
			--Upper half of the 3rd quadrant
			if math.abs(distance_Ox - v.width) > math.abs(distance_Oy) then
				--do nothing
				ball.yvel = 0

				table.remove(enemy, i)

				if ball.invincible == false then
					ball.health = ball.health - 1

					if ball.health == 0 then
						gamestate = 'lost'
					end
				end
			--Lower half of the 3rd quadrant
			else
				ball.yvel = 0

				table.remove(enemy, i)

				if ball.invincible == false then
					ball.health = ball.health - 1

					if ball.health == 0 then
						gamestate = 'lost'
					end
				end
			end
		end

		--Lower left corner of the enemy
		if ball.radius ^ 2 > distance_Ox ^ 2 + (distance_Oy - v.height) ^ 2 then
			--Upper half of the first quadrant
			if math.abs(distance_Ox) < math.abs(distance_Oy - v.height) then
				ball.y = v.y + v.height + ball.radius
				ball.yvel = 0

				table.remove(enemy, i)

				if ball.invincible == false then
					ball.health = ball.health - 1

					if ball.health == 0 then
						gamestate = 'lost'
					end
				end
			--Lower half of the first quadrant
			else
				ball.x = v.x - ball.radius
				ball.xvel = ball.collisionSpeed

				table.remove(enemy, i)

				if ball.invincible == false then
					ball.health = ball.health - 1

					if ball.health == 0 then
						gamestate = 'lost'
					end
				end
			end
		end

		--Lower right corner of the enemy
		if ball.radius ^ 2 > (distance_Ox - v.width) ^ 2 + (distance_Oy - v.height) ^ 2 then
			--Upper half of the second quadrant
			if math.abs(distance_Ox - v.width) < math.abs(distance_Oy - v.height) then
				ball.y = v.y + v.height + ball.radius
				ball.yvel = 0

				table.remove(enemy, i)

				if ball.invincible == false then
					ball.health = ball.health - 1

					if ball.health == 0 then
						gamestate = 'lost'
					end
				end
			--Lower half of the second quadrant
			else
				ball.yvel = 0

				table.remove(enemy, i)

				if ball.invincible == false then
					ball.health = ball.health - 1

					if ball.health == 0 then
						gamestate = 'lost'
					end
				end
			end
		end

		-----------------------------------------------------------------------------------------

		-- --Collision with the ball
		-- if ((ball.x + ball.radius > v.x and ball.x + ball.radius < v.x + v.width) or (ball.x - ball.radius > v.x and ball.x - ball.radius < v.x + v.width)) and
		-- 	((ball.y - ball.radius > v.y and ball.y - ball.radius < v.y + v.height) or (ball.y + ball.radius > v.y and ball.y + ball.radius < v.y + v.height)) then
		-- 	--GetRekt
		-- end

		--Delete the enemy if he exists the screen
		if v.x + v.width < 0 then
			table.remove(enemy, i)
		end
	end
end


--Parent Functions
function DRAW_ENEMY()
	enemy.draw()
end


function UPDATE_ENEMY(dt)
	--enemy.physics(dt)
	enemy.move(dt)
	enemy.generate(dt)
	enemy.collision()
end
