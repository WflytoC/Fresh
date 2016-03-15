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
		label = "返回",
		textOnly = true,
		fontSize = 24,
		onEvent = backTo
	})
	back.x = width/4/2  
	back.y = 22
	sceneGroup:insert(back)

	titleInfo = display.newText("您的快递物流情况",width/2,44,native.systemFont,15)
	titleInfo.x = width/2
	titleInfo.y = 22
	sceneGroup:insert(titleInfo)

	

	list = widget.newTableView {
		top = 44,
		width = width,
		height = height - 44 - 50 ,
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

	if phase == "will" then
		globalVars.isShow = true 
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

		row.time = display.newText(params.time,width,12,native.systemFontBold,15)
		row.time.anchorY = 0
		row.time.anchorX = 0
		row.time:setFillColor(0.5)
		row.time.x = 2
		row.time.y = 2
		row:insert(row.time)

		row.context = display.newText(params.context,width,12,width,36,native.systemFontBold,15)
		row.context.anchorY = 0
		row.context.anchorX = 0
		row.context:setFillColor(0.5)
		row.context.x = 2
		row.context.y = 28
		row:insert(row.context)


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
			time = tableData[i]["time"],
			context = tableData[i]["context"]
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
		globalVars.isShow = false
		composer.gotoScene(globalVars.origin)
	end
end


scene:addEventListener("create",scene)
scene:addEventListener("show",scene)
scene:addEventListener("hide",scene)
scene:addEventListener("destroy",scene)

return scene