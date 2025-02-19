local composer = require("composer")
local scene = composer.newScene()
local widget = require("widget")
local GGData = require "GGData"
local json = require("json")
local globalVars = require "globalVars"
local webView

local box
local width = display.contentWidth
local height = display.contentHeight
local tableData = {}
local list
local user,bigType
local back

function scene:create( event )
	local sceneGroup = self.view
	tableData = event.params
	
	local bg = display.newRect(0,0,width,height)
	bg.anchorX = 0
	bg.anchorY = 0
	bg:setFillColor(0,0.5,0.5)
	sceneGroup:insert(bg)

	back  = widget.newButton(
	{
		width = width/4,
		height = 44,
		label = "< 返回",
		fontSize = 18,
		textOnly = true,
		labelColor = {default={ 1, 1, 1 }, over={ 1,1,1 }},
		onEvent = backTo
	})
	back.x = width/4/2  
	back.y = 22 -4
	sceneGroup:insert(back)

	titleInfo = display.newText("导航定位",width/2,44,native.systemFont,16)
	titleInfo.anchorY = 0
	titleInfo.x = width/2
	titleInfo.y = 8
	sceneGroup:insert(titleInfo)

	webView = native.newWebView( 0, 38, width, height - 38)
	webView.anchorY = 0 
	webView.anchorX = 0
	sceneGroup:insert(webView)




end

function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase
	if phase == "will" then
		webView.isVisible = true
		globalVars.tabBar.isVisible = false
	elseif phase == "did" then
	Runtime:addEventListener( "location", locationHandler )

	end
end

function scene:hide( event )
	local sceneGroup = self.view
	local phase = event.phase

	if phase == "will" then

		webView.isVisible = false
		Runtime:removeEventListener( "location", locationHandler )
	elseif phase == "did" then

	end
end

function scene:destroy( event )
	local sceneGroup = self.view
	webView.isVisible = false
end



function locationHandler(event)
	if (event.errorCode) then

		native.showAlert( "注意", "定位发生错误" , { "知道啦" } )
	else 
		local latitude = event.latitude
		local longitude = event.longitude
		


			local params =  "http://apis.map.qq.com/tools/poimarker?type=0&marker=coord:" .. latitude .. "," .. longitude .. ";title:我在这里;addr:您找得目标用红色针头标注"


			for i = 1,#tableData do

				local lat = tableData[i]["latitude"]
				local log = tableData[i]["longitude"]
				
				params = params .. "|coord:" .. lat .. "," .. log .. ";title:目标;addr:目标" 

			end

			params = params .. "&key=N22BZ-NJVWQ-M4K5D-GCMJS-T7XQ7-ZEBMY&referer=鲜速达"
			print(params)
			webView:request(params)
			
	end

	Runtime:removeEventListener( "location", locationHandler )

end




scene:addEventListener("create",scene)
scene:addEventListener("show",scene)
scene:addEventListener("hide",scene)
scene:addEventListener("destroy",scene)
--Runtime:addEventListener( "location", locationHandler )


return scene