DEFAULT_ZOOM = 60
MAX_FLOOR_UP = 0
MAX_FLOOR_DOWN = 15

navigating = false
minimapWidget = nil
minimapButton = nil
minimapWindow = nil

--[[
  Known Issue (TODO):
  If you move the minimap compass directions and
  you change floor it will not update the minimap.
]]
function init()
  connect(mapWidget, { onMouseMove = function() 
                                      local pos = mapWidget:getCameraPosition()
                                      if pos ~= nil then minimapWidget:setCameraPosition(pos) end
                                      end }
          )
  g_keyboard.bindKeyDown('Ctrl+M', toggle)

  minimapButton = TopMenu.addRightGameToggleButton('minimapButton', tr('Minimap') .. ' (Ctrl+M)', '/images/topbuttons/minimap', toggle)
  minimapButton:setOn(true)

  minimapWindow = g_ui.loadUI('minimap.otui', rootWidget:recursiveGetChildById('rightPanel'))
  minimapWindow:setContentMinimumHeight(64)
  minimapWindow:setContentMaximumHeight(256)

  minimapWidget = minimapWindow:recursiveGetChildById('minimap')
  g_mouse.bindAutoPress(minimapWidget, compassClick, nil, MouseMidButton)
  g_mouse.bindAutoPress(minimapWidget, compassClick, nil, MouseLeftButton)
  minimapWidget:setAutoViewMode(false)
  minimapWidget:setViewMode(1) -- mid view
  minimapWidget:setDrawMinimapColors(true)
  minimapWidget:setMultifloor(false)
  minimapWidget:setKeepAspectRatio(false)
  minimapWidget.onMouseWheel = onMinimapMouseWheel

  reset()
  minimapWindow:setup()
end

function terminate()
  disconnect(mapWidget, { onMouseMove = center })

  saveMap()
  g_keyboard.unbindKeyDown('Ctrl+M')

  minimapButton:destroy()
  minimapWindow:destroy()
end

function online()
  reset()
  loadMap()
end

function offline()
  saveMap()
end

function loadMap()
  local clientVersion = g_game.getClientVersion()
  local minimapFile = '/minimap_' .. clientVersion .. '.otcm'
  if g_resources.fileExists(minimapFile) then
    g_map.clean()
    g_map.loadOtcm(minimapFile)
  end
end

function saveMap()
  local clientVersion = g_game.getClientVersion()
  local minimapFile = '/minimap_' .. clientVersion .. '.otcm'
  g_map.saveOtcm(minimapFile)
end

function toggle()
  if minimapButton:isOn() then
    minimapWindow:close()
    minimapButton:setOn(false)
  else
    minimapWindow:open()
    minimapButton:setOn(true)
  end
end

function isClickInRange(position, fromPosition, toPosition)
  return (position.x >= fromPosition.x and position.y >= fromPosition.y and position.x <= toPosition.x and position.y <= toPosition.y)
end

function reset()
  minimapWidget:setZoom(DEFAULT_ZOOM)
end

function center()
  local firstTown = g_towns.getTown(1)
  if firstTown then
    syncOn(firstTown:getTemplePos())
  end
end

function syncOn(pos)
  minimapWidget:setCameraPosition(pos)
  mapWidget:setCameraPosition(pos)
end

function syncZoom(zoom)
  minimapWidget:setZoom(zoom)
  mapWidget:setZoom(zoom)
end

function compassClick(self, mousePos, mouseButton, elapsed)
  if elapsed < 300 then return end

  navigating = true
  local px = mousePos.x - self:getX()
  local py = mousePos.y - self:getY()
  local dx = px - self:getWidth()/2
  local dy = -(py - self:getHeight()/2)
  local radius = math.sqrt(dx*dx+dy*dy)
  local movex = 0
  local movey = 0
  dx = dx/radius
  dy = dy/radius

  if dx > 0.5 then movex = 1 end
  if dx < -0.5 then movex = -1 end
  if dy > 0.5 then movey = -1 end
  if dy < -0.5 then movey = 1 end

  local cameraPos = minimapWidget:getCameraPosition()
  local pos = {x = cameraPos.x + movex, y = cameraPos.y + movey, z = cameraPos.z}
  syncOn(pos)
end

function onButtonClick(id)
  if id == "zoomIn" then
    local zoom = math.max(minimapWidget:getMaxZoomIn(), minimapWidget:getZoom() - 15)
    syncZoom(zoom)
  elseif id == "zoomOut" then
    local zoom = math.min(minimapWidget:getMaxZoomOut(), minimapWidget:getZoom()+15)
    syncZoom(zoom)
  elseif id == "floorUp" then
    local pos = minimapWidget:getCameraPosition()
    pos.z = pos.z - 1
    if pos.z > MAX_FLOOR_UP then
      syncOn(pos)
    end
  elseif id == "floorDown" then
    local pos = minimapWidget:getCameraPosition()
    pos.z = pos.z + 1
    if pos.z < MAX_FLOOR_DOWN then
      syncOn(pos)
    end
  end
end

function onMinimapMouseWheel(self, mousePos, direction)
  if direction == MouseWheelUp then
    self:zoomIn()
  else
    self:zoomOut()
  end
end

function onMiniWindowClose()
  minimapButton:setOn(false)
end
