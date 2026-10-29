local minimapController = nil
local updateAccumulator = 0

-- Grab the minimap time widget so we can rewrite the stock 12h label.
local function getMinimapTimeText()
  if not minimapController then
    return nil
  end

  local root = minimapController:GetRootWidget()
  if not root then
    return nil
  end

  local location = root:GetWidget("location")
  if not location then
    return nil
  end

  local timeAndSMS = location:GetWidget("timeAndSMS")
  if not timeAndSMS then
    return nil
  end

  return timeAndSMS:GetWidget("timeText")
end

registerForEvent("onInit", function()
  -- Track the active minimap instance for later updates.
  local function captureMinimapController(controller)
    minimapController = controller
  end

  Observe("MinimapContainerController", "OnInitialize", captureMinimapController)
  Observe("MinimapContainerController", "OnPlayerAttach", function(controller)
    captureMinimapController(controller)
  end)
  Observe("MinimapContainerController", "OnPlayerDetach", function(controller)
    if controller == minimapController then
      minimapController = nil
    end
  end)
end)

registerForEvent("onUpdate", function(deltaTime)
  updateAccumulator = updateAccumulator + deltaTime
  if updateAccumulator < 1 then
    return
  end
  updateAccumulator = 0

  if not minimapController or not Game or type(Game.GetTimeSystem) ~= "function" then
    return
  end

  local timeSystem = Game.GetTimeSystem()
  if not timeSystem or type(timeSystem.GetGameTime) ~= "function" then
    return
  end

  local gameTime = timeSystem:GetGameTime()
  local timeText = getMinimapTimeText()
  if not gameTime or not timeText then
    return
  end

  local currentText = timeText:GetText()
  -- The minimap label can vary by locale or casing, so update the actual clock widget directly.
  if type(currentText) ~= "string" then
    return
  end

  local formattedTime = string.format("%02d:%02d", gameTime:Hours(), gameTime:Minutes())
  if currentText ~= formattedTime then
    timeText:SetText(formattedTime)
  end
end)
