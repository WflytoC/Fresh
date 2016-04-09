local composer = require("composer")
local scene = composer.newScene()
local widget = require("widget")
local jsonData = require("jsonData")
local globalVars = require "globalVars"
local width = display.contentWidth
local height = display.contentHeight
local tableData = {}
local list
local flag
local back,titleInfo
 

function scene:create( event )
	local sceneGroup = self.view
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

	titleInfo = display.newText("选择城市列表",width/2,44,native.systemFont,16)
	titleInfo.anchorY = 0
	titleInfo.x = width/2
	titleInfo.y = 8
	sceneGroup:insert(titleInfo)

	tableData = jsonData.provinces

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

	if phase == "will" then
		globalVars.tabBar.isVisible = false
	elseif phase == "did" then
		flag = 1
		globalVars.judge = false
		globalVars.isShow = true
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
		row.title = display.newText(params.name,12,0,native.systemFontBold,24)
		row.title.anchorX = 0
		row.title:setFillColor(0)
		row.title.x = 6
		row.title.y = 22

		row:insert(row.title)
	end

	return true
end

function showTableView()
	for i = 1,#tableData do
		list:insertRow {
		rowHeight = 44,
		isCategory = false,
		rowColor = {0,0.5,0.5},
		lineColor = {0.90,0.90,0.90},
		params = {
			name = tableData[i]
		   }
		}
	end
end


function onRowTouch( event )
    if event.phase == "release" then
        local id = event.row.index
        if flag == 1 then
        	local provinceName = tableData[id]
        	tableData = {}
        	tableData = jsonData.cities[provinceName]
        	list:deleteAllRows()
        	showTableView()
        	flag = 2
        	globalVars.province = provinceName
        	
        elseif flag == 2 then
        	local cityName = tableData[id]
        	globalVars.city = cityName
        	tableData= {}
        	tableData = jsonData.stricts[cityName]
        	if (#tableData > 0) then
        	list:deleteAllRows()
        	showTableView()
        	flag = 3
        	else
        		globalVars.strict = ""
        		composer.gotoScene(globalVars.origin)
        		composer.removeScene("showCities")
        		flag = 1
        		globalVars.judge = true
        		globalVars.isShow = false 
        	end
        	
        elseif flag == 3 then
        	local strictName = tableData[id]
        	globalVars.strict = strictName
        	composer.gotoScene(globalVars.origin)
        	composer.removeScene("showCities")
        	flag = 1
        	globalVars.isShow = false 
        	globalVars.judge = true
        end
    end
    return true
end

function backTo( event )
	if ("ended" == event.phase) then
		composer.removeScene("showCities")
		composer.gotoScene(globalVars.origin)
		globalVars.isShow = false
	end
end


scene:addEventListener("create",scene)
scene:addEventListener("show",scene)
scene:addEventListener("hide",scene)
scene:addEventListener("destroy",scene)

return scene