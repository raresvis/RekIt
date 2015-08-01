ball = {}

function ball.load()
	--Position
	ball.generalPosition = screenWidth / 2

	ball.x = ball.generalPosition
	ball.y = 300

	--Velocity
	ball.xvel = 0
	ball.yvel = 0

	--Movement
	ball.friction = 0
	ball.speedLimit = 3000 --2250
	ball.upSpeed = -400
	ball.collisionSpeed = -600

	--Size
	ball.radius = 20

	--Power-ups
	ball.shooting = true
	ball.invincible = false

	--Status
	ball.initialHealth = 7
	ball.health = 7

	--Jump Timer
	ball.timerLimit = 0
	ball.timer = 0

	--Score
	ball.score = 0
	ball.scoreMultiplier = 1

	--Difficulty
	ball.difficulty = 'Rekt'
end


function ball.draw()
	--love.graphics.setColor(255, 0, 0)
	love.graphics.setColor(255, 255, 51)
	love.graphics.circle("fill", ball.x, ball.y, ball.radius, 50)

	score = ""

	score = score..math.ceil(ball.score)

	love.graphics.print(score, 10, 10)
end


function ball.physics(dt)
	ball.x = ball.x + ball.xvel * dt
	ball.y = ball.y + ball.yvel * dt

	ball.yvel = ball.yvel + gravity * dt

	if ball.x + ball.radius < ball.generalPosition then
		ball.xvel = ball.xvel + gravity * dt
	end
	
	ball.xvel = ball.xvel * (1 - math.min(dt * ball.friction, 1))
	ball.yvel = ball.yvel * (1 - math.min(dt * ball.friction, 1))
end


function ball.move(dt)
  --if love.keyboard.isDown('right') and ball.xvel < ball.speedLimit then
  --  ball.xvel = ball.xvel + ball.speedLimit * dt
  --end

  --if love.keyboard.isDown('left') and ball.xvel > -ball.speedLimit then
  --  ball.xvel = ball.xvel - ball.speedLimit * dt
  --end

  ball.timer = ball.timer + dt

  ball.score = ball.score + ball.scoreMultiplier * dt

  if love.keyboard.isDown('up') and ball.yvel > -ball.speedLimit and ball.timer >= ball.timerLimit then
    --ball.yvel = ball.yvel - ball.speedLimit * dt
	ball.yvel = ball.upSpeed
	ball.timer = 0
  end

  -- if love.keyboard.isDown('down') and ball.yvel < ball.speedLimit then
  --  ball.yvel = ball.yvel + ball.speedLimit * dt
  -- end
end


function ball.boundary()
  if ball.x - ball.radius < 0 then
    ball.x = ball.radius
	ball.xvel = 0
  end

  if ball.y - ball.radius < 0 then
    ball.y = ball.radius
	ball.yvel = 0
  end

  if ball.x + ball.radius > ball.generalPosition then
    ball.x = ball.generalPosition - ball.radius
	ball.xvel = 0
  end

  if ball.y + ball.radius > groundLevel then
    ball.y = groundLevel - ball.radius
	ball.yvel = 0
  end
end


function ball.shoot(key)
	if key == ' ' and ball.shooting == true then
		bullet.spawn(ball.x + ball.radius, ball.y)
	end
end


--Parent functions

function UPDATE_BALL(dt)
	ball.move(dt)
	ball.physics(dt)
	ball.boundary()
end


function DRAW_BALL(dt)
	ball.draw()
end
