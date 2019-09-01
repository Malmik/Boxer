local ui = {
  m = {}, --menus
  t = {}, --tilesets
  b = {}, --buttons
  batch = {}
}

function ui.addtileset(name, quad_path, image_path)
  dofile(arg[1]..quad_path)

  ui.t[name] = {
    image = love.graphics.newImage(image_path),
    cords = cordinates,
    quad = {},
    bg = {}
  }

  --ui.t[name].image:setFilter("nearest", "nearest")

  local i
  while next(cordinates, i) ~= nil do
    ui.t[name].quad[next(cordinates, i)] = love.graphics.newQuad(cordinates[next(cordinates, i)].x, cordinates[next(cordinates, i)].y, cordinates[next(cordinates, i)].w, cordinates[next(cordinates, i)].h, ui.t[name].image:getDimensions())-- ,cordinates[next(cordinates, i)].sw, cordinates[next(cordinates, i)].sh)
    i = next(cordinates, i)
  end

  local canvas = love.graphics.newCanvas(1,1)
  canvas:renderTo(function() love.graphics.draw(ui.t[name].image, ui.t[name].quad.background, 0, 0) end)
  ui.t[name].bg.r, ui.t[name].bg.g, ui.t[name].bg.b, ui.t[name].bg.a = canvas:newImageData():getPixel(0, 0)

  cordinates = nil
end

function ui.add(name, tileset_name, w, h, x, y, sx, sy)
  ui.m[name] = {
    tileset = tileset_name,
    x = x or 0,
    y = y or 0,
    w = w or ui.t[tileset_name].cords.left_down.w + ui.t[tileset_name].cords.right_top.w,
    h = h or ui.t[tileset_name].cords.right_top.h + ui.t[tileset_name].cords.left_down.h,
    sx = sx or 1,
    sy = sy or 1,
  }

  local t = ui.m[name]

  ui.m[name] = {
    tileset = tileset_name,
    x = t.x,
    y = t.y,
    w = t.w,
    h = t.h,
    sx = t.sx,
    sy = t.sy,
    bgx = t.x + ui.t[tileset_name].cords.left_top.w,
    bgy = t.y + ui.t[tileset_name].cords.left_top.h,
    bgw = t.w - (ui.t[tileset_name].cords.left_down.w + ui.t[tileset_name].cords.right_top.w),
    bgh = t.h - (ui.t[tileset_name].cords.left_top.h + ui.t[tileset_name].cords.right_down.h),

    button = {},
    item = {},
    cache = {
      isSync = 1,
      oldx = t.x,
      oldy = t.y,
      upSTART = (t.x + ui.t[tileset_name].cords.left_top.w * t.sx) - 1,
      upEND = (t.x + t.w - ui.t[tileset_name].cords.right_top.w * t.sx) + 1,
      leftSTART = (t.y + ui.t[tileset_name].cords.left_top.h * t.sy) - 1,
      leftEND = (t.y + t.h - ui.t[tileset_name].cords.left_down.h * t.sy) + 1,
      rightSTART = (t.y + ui.t[tileset_name].cords.right_top.h * t.sy) - 1,
      rightEND = (t.y + t.h - ui.t[tileset_name].cords.right_down.h * t.sy) + 1,
      downSTART = (t.x + ui.t[tileset_name].cords.left_down.w * t.sx) - 1,
      downEND = (t.x + t.w - ui.t[tileset_name].cords.right_down.w * t.sx) + 1,
      rightTopX = t.x+t.w-ui.t[tileset_name].cords.right_top.w*t.sx,
      leftDownY = t.y+t.h-ui.t[tileset_name].cords.left_down.h*t.sy,
      rightDownX = t.x+t.w-ui.t[tileset_name].cords.right_down.w*t.sx,
      rightDownY = t.y+t.h-ui.t[tileset_name].cords.right_down.h*t.sy,
      rightX = t.x + t.w - (ui.t[tileset_name].cords.right_top.w) * t.sx,
      downY = t.y + t.h - (ui.t[tileset_name].cords.left_down.h) * t.sy
    }
  }
end

function ui.addbutton(name, tileset, normal, hover, click, x, y, menu, assign)
  if menu == nil then
    ui.b[name] = {
      quad {
        normal = ui.t[tileset].quad[normal],
        hover = ui.t[tileset].quad[hover],
        click = ui.t[tileset].quad[click],
      },
      x = x or 0,
      y = y or 0,
      w = ui.t[tileset].cords[normal].w,
      h = ui.t[tileset].cords[normal].h,
      state = "normal"
    }
  else
    ui.m[menu].button[name] = {
      quad = {
        normal = ui.t[tileset].quad[normal],
        hover = ui.t[tileset].quad[hover],
        click = ui.t[tileset].quad[click],
      },
      x = x or 0,
      y = y or 0,
      w = ui.t[tileset].cords[normal].w,
      h = ui.t[tileset].cords[normal].h,
      state = "normal",
      assign = assign or "none"
      --type  = ui.m[menu] == "frame" or == "ground",
    }
  end
end

function ui.update()
  for menuname, menu in pairs(ui.m) do
    if menu.cache.isSync == 0 then

      local oldx = menu.cache.oldx
      local oldy = menu.cache.oldy

      menu.cache = {
        oldx = menu.x,
        oldy = menu.y,
        isSync = 0,
        upSTART = (menu.x + ui.t[menu.tileset].cords.left_top.w * menu.sx) - 1,
        upEND = (menu.x + menu.w - ui.t[menu.tileset].cords.right_top.w * menu.sx) + 1,
        leftSTART = (menu.y + ui.t[menu.tileset].cords.left_top.h * menu.sy) - 1,
        leftEND = (menu.y + menu.h - ui.t[menu.tileset].cords.left_down.h * menu.sy) + 1,
        rightSTART = (menu.y + ui.t[menu.tileset].cords.right_top.h * menu.sy) - 1,
        rightEND = (menu.y + menu.h - ui.t[menu.tileset].cords.right_down.h * menu.sy) + 1,
        downSTART = (menu.x + ui.t[menu.tileset].cords.left_down.w * menu.sx) - 1,
        downEND = (menu.x + menu.w - ui.t[menu.tileset].cords.right_down.w * menu.sx) + 1,
        rightTopX = menu.x + menu.w - ui.t[menu.tileset].cords.right_top.w * menu.sx,
        leftDownY = menu.y + menu.h - ui.t[menu.tileset].cords.left_down.h * menu.sy,
        rightDownX = menu.x + menu.w - ui.t[menu.tileset].cords.right_down.w * menu.sx,
        rightDownY = menu.y + menu.h - ui.t[menu.tileset].cords.right_down.h * menu.sy,
        rightX = menu.x + menu.w - (ui.t[menu.tileset].cords.right_top.w) * menu.sx,
        downY = menu.y + menu.h - (ui.t[menu.tileset].cords.left_down.h) * menu.sy
      }

      menu.bgx = menu.x + ui.t[menu.tileset].cords.left_top.w * menu.sx
      menu.bgy = menu.y + ui.t[menu.tileset].cords.left_top.h * menu.sy
      menu.bgw = menu.w - (ui.t[menu.tileset].cords.left_down.w + ui.t[menu.tileset].cords.right_top.w) * menu.sx
      menu.bgh = menu.h - (ui.t[menu.tileset].cords.left_top.h + ui.t[menu.tileset].cords.right_down.h) * menu.sy
    end
    menu.cache.isSync = 1
    for k,v in pairs(menu.button) do
      v.x = v.x - menu.cache.oldx + menu.x
      v.y = v.y - menu.cache.oldy + menu.y

      if v.x > menu.bgw + menu.bgx - v.w then v.x = menu.bgw + menu.bgx - v.w * menu.sx end
      if v.x < menu.bgx then v.x = menu.bgx end
      if v.y > menu.bgh + menu.bgy - v.h then v.y = menu.bgh + menu.bgy - v.h end
      if v.y < menu.bgy then v.y = menu.bgy end

      if love.mouse.getX() < v.x + v.w * menu.sx and love.mouse.getX() > v.x and love.mouse.getY() < v.y + v.h * menu.sy and love.mouse.getY() > v.y then
        if love.mouse.isDown(1) then
          v.state = "click"
        else
          v.state = "hover"
        end
      else
        v.state = "normal"
      end
    end
  end
  interval = 1
end

function ui.state(button, menu)
  if menu == nil then
    return ui.b[button].state
  else
    return ui.m[menu].button[button].state
  end
end

function ui.draw(name, x, y, w, h, sx, sy)
  local menu = ui.m[name]

  if menu.w >= (ui.t[menu.tileset].cords.left_top.w + ui.t[menu.tileset].cords.right_down.w) and menu.h >= (ui.t[menu.tileset].cords.right_top.h + ui.t[menu.tileset].cords.left_down.h) then
---[[
    for i = menu.cache.upSTART, menu.cache.upEND, 1 do
      love.graphics.draw(ui.t[menu.tileset].image, ui.t[menu.tileset].quad.up, i, menu.y, nil, menu.sx, menu.sy)
    end
    for i = menu.cache.leftSTART, menu.cache.leftEND, 1 do
      love.graphics.draw(ui.t[menu.tileset].image, ui.t[menu.tileset].quad.left, menu.x, i, nil, menu.sx, menu.sy)
    end
    for i = menu.cache.rightSTART, menu.cache.rightEND, 1 do
      love.graphics.draw(ui.t[menu.tileset].image, ui.t[menu.tileset].quad.right, menu.cache.rightX, i, nil, menu.sx, menu.sy)
    end
    for i = menu.cache.downSTART, menu.cache.downEND, 1 do
      love.graphics.draw(ui.t[menu.tileset].image, ui.t[menu.tileset].quad.down, i, menu.cache.downY, nil, menu.sx, menu.sy)
    end
    ---[[
    love.graphics.draw(ui.t[menu.tileset].image, ui.t[menu.tileset].quad.left_top, menu.x, menu.y, nil, menu.sx, menu.sy)
    love.graphics.draw(ui.t[menu.tileset].image, ui.t[menu.tileset].quad.right_top, menu.cache.rightTopX, menu.y, nil, menu.sx, menu.sy)
    love.graphics.draw(ui.t[menu.tileset].image, ui.t[menu.tileset].quad.left_down, menu.x, menu.cache.leftDownY, nil, menu.sx, menu.sy)
    love.graphics.draw(ui.t[menu.tileset].image, ui.t[menu.tileset].quad.right_down, menu.cache.rightDownX, menu.cache.rightDownY, nil, menu.sx, menu.sy)
--]]
    love.graphics.setColor(ui.t[menu.tileset].bg.r, ui.t[menu.tileset].bg.g, ui.t[menu.tileset].bg.b, ui.t[menu.tileset].bg.a, nil, menu.sx, menu.sy)
    love.graphics.rectangle("fill", menu.bgx, menu.bgy, menu.bgw, menu.bgh)
    love.graphics.setColor(1,1,1,1)

    for k,v in pairs(menu.button) do
      love.graphics.draw(ui.t[menu.tileset].image, v.quad[v.state], v.x, v.y, nil, menu.sx, menu.sy)
    end
  end

  if (menu.x ~= x and x) or  (menu.y ~= y and y) or (menu.w ~= w and w) or (menu.h ~= h and h) or (menu.sx ~= sx and sx) or (menu.sy ~= sy and sx) then
    menu.cache.oldx = menu.x
    menu.cache.oldy = menu.y
    menu.x = x or menu.x
    menu.y = y or menu.y
    menu.w = w or menu.w
    menu.h = h or menu.h
    menu.sx = sx or menu.sx
    menu.sy = sy or menu.sy
    menu.cache.isSync = 0
  end
end

return ui
