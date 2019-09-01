local ui = require("menudrawer")

function love.load(arg)
  ui.addtileset("tileset", "/menuquads.lua", "Menu_Atlas.png")
  ui.add("menu", "tileset", 200, 100)

  keys = {}

  x, y, w, h, sx, sy = 0, 0, 200, 200, 1, 1
end

function love.update(dt)
  ui.update()

  if keys.z then -- Dirty implementation
    x = x + 1
  elseif keys.x then
    y = y + 1
  elseif keys.c then
    w = w + 1
  elseif keys.v then
    h = h + 1
  elseif keys.b then
    sx = sx + 0.01
    sy = sy + 0.01
  elseif keys.n then
    sx = sx - 0.01
    sy = sy - 0.01
  end
end


function love.keypressed(key, scancode, isrepeat)
  keys[key] = 1
end

function love.keyreleased(key)
  keys[key] = nil
end

function love.draw()
  ui.draw("menu", x, y, w, h, sx, sy)
end
