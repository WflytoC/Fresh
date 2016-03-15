local composer = require("composer")
local scene = composer.newScene()
local widget = require("widget")
local globalVars = require "globalVars"
local width = display.contentWidth
local height = display.contentHeight
local GGData = require "GGData"

local box = GGData:new("user")
 

function scene:create( event )
	local sceneGroup = self.view
	local bg = display.newRect(0,0,width,height)
	bg.anchorX = 0
	bg.anchorY = 0
	bg:setFillColor(0,0.5,0.5)
	sceneGroup:insert(bg)

	local bgImage = display.newImage("Default.png")
	bgImage.anchorX = 0
	bgImage.anchorY = 0
	sceneGroup:insert(bgImage)

	
end

function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase

	if phase == "will" then
		
	elseif phase == "did" then
		globalVars.tabBar.isVisible = false
		timer.performWithDelay( 2000, listener )
	end
end

function scene:hide( event )
	local sceneGroup = self.view
	local phase = event.phase

	if phase == "will" then

	elseif phase == "did" then

	end
end

function scene:destroy( event )
	local sceneGroup = self.view
end

 function listener( event )
    if (not box.status or box.status == "needAgain") then
		local options = {
    		isModal = true,
    		effect = "fade",
    		time = 400
		}
	composer.gotoScene("loginRegister")
else
	composer.gotoScene("seekCars")
end
  end


scene:addEventListener("create",scene)
scene:addEventListener("show",scene)
scene:addEventListener("hide",scene)
scene:addEventListener("destroy",scene)

return scene