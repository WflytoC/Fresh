local composer = require("composer")
local scene = composer.newScene()
local widget = require("widget")
local globalVars = require "globalVars"
local width = display.contentWidth
local height = display.contentHeight
local tableData = {}
local list
local back,titleInfo
 

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
		textOnly = true,
		fontSize = 18,
		labelColor = {default={ 1, 1, 1 }, over={ 1,1,1 }},
		onEvent = backTo
	})
	back.x = width/4/2  
	back.y = 22 -4
	sceneGroup:insert(back)

	titleInfo = display.newText("标题",width/2,44,native.systemFont,16)
	titleInfo.x = width/2
	titleInfo.anchorY = 0
	titleInfo.y = 8
	sceneGroup:insert(titleInfo)

	

	list = widget.newTableView {
		top = 38,
		width = width,
		height = height - 38 ,
		onRowRender = onRowRender,
		onRowTouch = onRowTouch,
		listener = scrollListener
	}

	sceneGroup:insert(list)
	showTableView() 
	
end

function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase
	globalVars.isShow = true
	if phase == "will" then
		globalVars.tabBar.isVisible = false
		if (globalVars.target == 4) then
			titleInfo.text = "您上传的车"
		elseif (globalVars.target == 3) then
			titleInfo.text = "您上传的货"
		end
	elseif phase == "did" then
		
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

function onRowRender(event) 
	local row = event.row
	local id = row.index
	local params = event.row.params

	if (event.row.params) then

		local place = "装点：" .. params.start .. "   卸点：" .. params.finish
		row.place = display.newText(place,width,12,native.systemFontBold,15)
		row.place.anchorY = 0
		row.place.anchorX = 0
		row.place:setFillColor(0.5)
		row.place.x = 2
		row.place.y = 2
		row:insert(row.place)

		local treasure = "重量：" .. params.weigh .. "   体积：" .. params.volume
		row.treasure = display.newText(treasure,width,12,native.systemFontBold,15)
		row.treasure.anchorY = 0
		row.treasure.anchorX = 0
		row.treasure:setFillColor(0.5)
		row.treasure.x = 2
		row.treasure.y = 18
		row:insert(row.treasure)

		local detail = "详情描述：" .. params.detail 
		row.detail = display.newText(detail,width,32,width,16,native.systemFontBold,15)
		row.detail.anchorY = 0
		row.detail.anchorX = 0
		row.detail:setFillColor(0.5)
		row.detail.x = 2
		row.detail.y = 36
		row:insert(row.detail)
	end

	return true
end

function showTableView()
	for i = 1,#tableData do
		list:insertRow {
		rowHeight = 72,
		isCategory = false,
		rowColor = {0,0.5,0.5},
		lineColor = {0.90,0.90,0.90},
		params = {
			start = tableData[i]["startProvince"] .. tableData[i]["startCity"] .. tableData[i]["startStrict"],
		    finish = tableData[i]["endProvince"] .. tableData[i]["endCity"] .. tableData[i]["endStrict"],
		   	weigh = tableData[i]["weigh"],
		   	volume = tableData[i]["volume"],
		   	detail = tableData[i]["detail"]
		   }
		}
	end
end


function onRowTouch( event )
    if event.phase == "release" then
        local id = event.row.index
        
    end
    return true
end

function backTo( event )
	if ("ended" == event.phase) then
		composer.gotoScene(globalVars.origin)
		globalVars.isShow = false
	end
end


scene:addEventListener("create",scene)
scene:addEventListener("show",scene)
scene:addEventListener("hide",scene)
scene:addEventListener("destroy",scene)

return scene