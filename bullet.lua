bullet = {}

function bullet.load()
	bullet.width = 12
	bullet.height = 2
	bullet.speed = 500
end

function bullet.spawn(x, y)
	table.insert(bullet, {x = x, y = y, width = bullet.width, height = bullet.height})
end


function bullet.draw()
	for i, v in ipairs(bullet) do
		--love.graphics.setColor(0, 0, 255)
		love.graphics.setColor(255, 0, 0)
		love.graphics.rectangle('fill', v.x, v.y, bullet.width, bullet.height)
	end
end


function bullet.move(dt)
	for i, v in ipairs(bullet) do
		v.x = v.x + bullet.speed * dt

		if v.x > screenWidth then
			table.remove(bullet, i);
		end

	end
end

--Parent Functions

function DRAW_BULLET()
	bullet.draw()
end


function UPDATE_BULLET(dt)
	bullet.move(dt)
end
