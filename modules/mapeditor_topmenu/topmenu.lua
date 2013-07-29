-- private variables
local topMenu
local leftButtonsPanel
local rightButtonsPanel
local leftGameButtonsPanel
local rightGameButtonsPanel

-- private functions
local function addButton(id, description, icon, callback, panel, toggle, front)
  local class
  if toggle then
    class = 'TopToggleButton'
  else
    class = 'TopButton'
  end

  local button = panel:getChildById(id)
  if not button then
    button = g_ui.createWidget(class)
    if front then
      panel:insertChild(1, button)
    else
      panel:addChild(button)
    end
  end
  button:setId(id)
  button:setTooltip(description)
  button:setIcon(resolvepath(icon, 3))
  button.onMouseRelease = function(widget, mousePos, mouseButton)
    if widget:containsPoint(mousePos) and mouseButton ~= MouseMiddleButton then
      callback()
      return true
    end
  end
  return button
end

-- public functions
function init()
  connect(g_game, { onGameStart = online,
                    onGameEnd = offline })
  connect(g_app, { onFps = updateFps })

  topMenu = g_ui.displayUI('topmenu')

  leftButtonsPanel = topMenu:getChildById('leftButtonsPanel')
  rightButtonsPanel = topMenu:getChildById('rightButtonsPanel')
  leftGameButtonsPanel = topMenu:getChildById('leftGameButtonsPanel')
  rightGameButtonsPanel = topMenu:getChildById('rightGameButtonsPanel')
  fpsLabel = topMenu:getChildById('fpsLabel')

  if g_game.isOnline() then
    online()
  end
end

function terminate()
  disconnect(g_game, { onGameStart = online,
                       onGameEnd = offline })
  disconnect(g_app, { onFps = updateFps })

  topMenu:destroy()
end

function online()
  showGameButtons()
end

function offline()
  hideGameButtons()
end

function updateFps(fps)
  text = 'FPS: ' .. fps
  fpsLabel:setText(text)
end

function setFpsVisible(enable)
  fpsLabel:setVisible(enable)
end

function addLeftButton(id, description, icon, callback, front)
  return addButton(id, description, icon, callback, leftButtonsPanel, false, front)
end

function addLeftToggleButton(id, description, icon, callback, front)
  return addButton(id, description, icon, callback, leftButtonsPanel, true, front)
end

function addRightButton(id, description, icon, callback, front)
  return addButton(id, description, icon, callback, rightButtonsPanel, false, front)
end

function addRightToggleButton(id, description, icon, callback, front)
  return addButton(id, description, icon, callback, rightButtonsPanel, true, front)
end

function addLeftGameButton(id, description, icon, callback, front)
  return addButton(id, description, icon, callback, leftGameButtonsPanel, false, front)
end

function addLeftGameToggleButton(id, description, icon, callback, front)
  return addButton(id, description, icon, callback, leftGameButtonsPanel, true, front)
end

function addRightGameButton(id, description, icon, callback, front)
  return addButton(id, description, icon, callback, rightGameButtonsPanel, false, front)
end

function addRightGameToggleButton(id, description, icon, callback, front)
  return addButton(id, description, icon, callback, rightGameButtonsPanel, true, front)
end

function showGameButtons()
  leftGameButtonsPanel:show()
  rightGameButtonsPanel:show()
end

function hideGameButtons()
  leftGameButtonsPanel:hide()
  rightGameButtonsPanel:hide()
end

function getButton(id)
  return topMenu:recursiveGetChildById(id)
end

function getTopMenu()
  return topMenu
end