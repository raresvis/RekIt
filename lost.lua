LostButton = {}

function lost_button_spawn(x, y, text, id)
	table.insert(LostButton, {x = x - fontSize:getWidth(text) / 2, y = y - fontSize:getHeight(text) / 2, text = text, id = id, mouseover = false})
end


function lost_button_draw()
	--declare new fontsize for the ''Get Rekt'' message
	LostFontSize = love.graphics.newFont(40)

	--set the font as default
	love.graphics.setFont(LostFontSize)

	--set a new color for the text
	love.graphics.setColor(255, 0, 0)

	--declare the message
	rekt = 'Get Rekt Son!!!'

	--display message
	love.graphics.print(rekt, screenWidth / 2 - fontSize:getWidth(rekt), screenHeight / 3 - fontSize:getHeight(rekt) / 2)

	--display score
	ScoreFontSize = love.graphics.newFont(20)

	love.graphics.setFont(ScoreFontSize)

	score = ""

	score = score..'Level: '..ball.difficulty..'      '..'Your score: '..math.ceil(ball.score)

	love.graphics.print(score, screenWidth / 2 - fontSize:getWidth(score) / 2, screenHeight / 2.3 - fontSize:getHeight(score) / 2)

	--reuse the old font size
	love.graphics.setFont(fontSize)

	for i, v in ipairs(LostButton) do
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


function lost_button_click(x, y)
	for i, v in ipairs(LostButton) do
		if x > v.x and x < v.x + fontSize:getWidth(v.text) and y > v.y and y < v.y + fontSize:getHeight(v.text) then
			if v.id == "ok" then
				gamestate = "menu"
				ball.score = 0
			end
		end
	end
end


function lost_button_check()
	for i, v in ipairs(LostButton) do
		if mouseX > v.x and mouseX < v.x + fontSize:getWidth(v.text)  and mouseY > v.y and mouseY < v.y + fontSize:getHeight(v.text) then
			v.mouseover = true
		else
			v.mouseover = false
		end
	end
end