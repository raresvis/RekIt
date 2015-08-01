require "ball"
require "bullet"
require "enemy"
require "ledge"
require "lost"
require "menu"

function love.load()
  --love.window.setMode(900, 600, {resizable=true, vsync=false, minwidth=400, minheight=300})

  logo = love.graphics.newImage('RekItLogo.png')

  --love.graphics.setIcon()

  love.graphics.setBackgroundColor(117,219,250)

  screenWidth = love.graphics.getWidth()
  screenHeight = love.graphics.getHeight()

  fontSize = love.graphics.newFont(20)

  groundLevel = 600
  gravity = 1000

  --Initialize random seed
  math.randomseed(os.time())

  --Initialize game state
  gamestate = "menu"

  --Create Buttons for the menu
  love.graphics.setFont(fontSize)

  menu_button_spawn(screenWidth / 2, screenHeight / 2, "Rekt", "rekt")
  menu_button_spawn(screenWidth / 2, screenHeight / 2 + fontSize:getHeight(fontSize), "Really Rekt", "Rrekt")
  menu_button_spawn(screenWidth / 2, screenHeight / 2 + 2 * fontSize:getHeight(fontSize), "Tyrannosaurus Rekt", "Trekt")
  menu_button_spawn(screenWidth / 2, screenHeight / 2 + 3 * fontSize:getHeight(fontSize), "RageQuit", "quit")

  --Create Buttons for the lost gamestate
  lost_button_spawn(screenWidth / 2, screenHeight / 2, "Okay...", "ok")

  --Create the Ball
  ball.load()

  --Initialize enemy
  enemy.load()

  --Initialize ledge
  ledge.load()

  --Initialize bullet
  bullet.load()
end


function love.update(dt)
	if gamestate == "playing" then
		UPDATE_BALL(dt)
		UPDATE_BULLET(dt)
		UPDATE_ENEMY(dt)
		UPDATE_LEDGE(dt)
	end

	if gamestate == "menu" then
		mouseX = love.mouse.getX()
		mouseY = love.mouse.getY()

		menu_button_check()
	end

	if gamestate == "lost" then
		mouseX = love.mouse.getX()
		mouseY = love.mouse.getY()

		lost_button_check()
	end
end

function love.draw()
	if gamestate == "playing" then
		love.graphics.setBackgroundColor(117,219,250)
		DRAW_BALL()
		DRAW_BULLET()
		DRAW_ENEMY()
		DRAW_LEDGE()
	end

	if gamestate == "menu" then
		love.graphics.setBackgroundColor(51,153,255)
		menu_button_draw()
	end

	if gamestate == "lost" then
		love.graphics.setBackgroundColor(255,153,51)

		lost_button_draw()
	end
end


function love.keypressed(key)
	if gamestate == "playing" then
		ball.shoot(key)
	end

	if gamestate == "playing" and key == 'escape' then
		gamestate = "lost"
	end
end


function love.mousepressed(x, y)
	if gamestate == "menu" then
		menu_button_click(x, y)
	end

	if gamestate == "lost" then
		lost_button_click(x, y)
	end
end
