MenuButton = {}

function menu_button_spawn(x, y, text, id)
	table.insert(MenuButton, {x = x - fontSize:getWidth(text) / 2, y = y - fontSize:getHeight(text) / 2, text = text, id = id, mouseover = false})
end


function menu_button_draw()
	for i, v in ipairs(MenuButton) do
		if v.mouseover == false then
			love.graphics.setColor(0, 0, 0)
		end
		if v.mouseover == true then
		love.graphics.setColor(0, 255, 255)
		end

		--love.graphics.setFont(fontSize)
		love.graphics.print(v.text, v.x, v.y)
	end
end


function refresh_world()
	ball.load()

	for i, v in ipairs(enemy) do
		table.remove(enemy, i)
		enemy[i] = nil
	end
	-- --two delete operations were necessary because
	-- --the first one would leave an element unremoved
	-- for i = 1, #enemy do
	-- 	table.remove(enemy, i)
	-- end

	enemy.load()

	for i, v in ipairs(ledge) do
		table.remove(ledge, i)
		ledge[i] = nil
	end
	-- --same thing as above
	-- for i = 1, #ledge do
	-- 	table.remove(ledge, i)
	-- end

	ledge.load()

	for i, v in ipairs(bullet) do
		table.remove(bullet, i)
		bullet[i] = nil
	end
	--same thing as above
	-- for i = 1, #bullet do
	-- 	table.remove(bullet, i)
	-- 	bullet[i] = nil
	-- end

	bullet.load()
end


function menu_button_click(x, y)
	for i, v in ipairs(MenuButton) do
		if x > v.x and x < v.x + fontSize:getWidth(v.text) and y > v.y and y < v.y + fontSize:getHeight(v.text) then
			if v.id == "rekt" then
				refresh_world()

				ball.generalPosition = screenWidth / 2

				--enemy.speed = 300
				--ledge.speed = 200

				ball.difficulty = 'Rekt'

				gamestate = "playing"
			end
			if v.id == "Rrekt" then
				refresh_world()

				ball.generalPosition = screenWidth / 4

				enemy.speed = 450
				ledge.speed = 200

				ball.scoreMultiplier = 2

				ball.difficulty = 'Really Rekt'

				ball.initialHealth = 5
				ball.health = 5

				enemy.timerMin = 0.5
				enemy.timerMax = 1.5

				ledge.timerMin = 0.7
				ledge.timerMax = 1.4

				gamestate = "playing"
			end
			if v.id == "Trekt" then
				refresh_world()

				ball.generalPosition = screenWidth / 8

				enemy.speed = 600
				ledge.speed = 500

				ball.scoreMultiplier = 3

				ball.difficulty = 'Tyrannosaurus Rekt'

				ball.initialHealth = 3
				ball.health = 3

				enemy.timerMin = 0.4
				enemy.timerMax = 1

				ledge.timerMin = 0.5
				ledge.timerMax = 1.3

				gamestate = "playing"
			end
			if v.id == "quit" then
				love.event.push("quit")
			end
		end
	end
end


function menu_button_check()
	for i, v in ipairs(MenuButton) do
		if mouseX > v.x and mouseX < v.x + fontSize:getWidth(v.text)  and mouseY > v.y and mouseY < v.y + fontSize:getHeight(v.text) then
			v.mouseover = true
		else
			v.mouseover = false
		end
	end
end