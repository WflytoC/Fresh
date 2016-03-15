local composer = require("composer")
local scene = composer.newScene()
local widget = require("widget")
local json = require("json")

local codes = require("company")
local globalVars = require "globalVars"


local startProvince,startCity,startStrict
local finishProvince,finishCity,finishStrict
local transType = 0

local  tableData = codes.goodTypes
local list

local startField,finishField,kindField,tonNumField

local width = display.contentWidth
local height = display.contentHeight

function scene:create( event )
	local sceneGroup = self.view


	local bg = display.newRect(0,0,display.contentWidth,display.contentHeight)
	bg.anchorX = 0
	bg.anchorY = 0
	bg:setFillColor(0.016,0.718,0.867)
	sceneGroup:insert(bg)


	

	local start = display.newText("装 点",width/5,40,native.systemFont,18)
	start.x = width/5/2
	start.y = 12 + 20
	sceneGroup:insert(start)

	startField = native.newTextField(width/5*3,12+20,width/5*4-12,28)
	sceneGroup:insert(startField)
	startField:addEventListener( "userInput", beginListener )

	local finish = display.newText("卸 点",width/5,40,native.systemFont,18)
	finish.x = width/5/2
	finish.y = 12 + 40 +20
	sceneGroup:insert(finish)

	finishField = native.newTextField(width/5*3,12+40+20,width/5*4-12,28)
	sceneGroup:insert(finishField)
	finishField:addEventListener( "userInput", finishListener )


	local kind = display.newText("种 类",width/5,40,native.systemFont,18)
	kind.x = width/5/2
	kind.y = 12 + 40 +40 +20
	sceneGroup:insert(kind)

	kindField = native.newTextField(width/5*3,12+40+40+20,width/5*4-12,28)
	sceneGroup:insert(kindField)
	kindField:addEventListener( "userInput", typeListener )

	local tonNum = display.newText("重量(kg)",width/2/2,40,native.systemFont,18)
	tonNum.x = width/2/2/2
	tonNum.y = 12 + 40 +40  +40 +20
	sceneGroup:insert(tonNum)

	tonNumField = native.newTextField(width/2/2+width/2/2/2,12+40+40+40+20,width/2/2-10,28)
	sceneGroup:insert(tonNumField)

	local carNum = display.newText("体积(L)",width/2/2,40,native.systemFont,18)
	carNum.x = width/2/2/2 + width/2
	carNum.y = 12 + 40 +40 +40 +20
	sceneGroup:insert(carNum)

	carNumField = native.newTextField(width/2+width/2/2+width/2/2/2,12+40+40+40+20,width/2/2-10,28)
	sceneGroup:insert(carNumField)

	local seekPrice = widget.newButton(
	{
		width = width / 3,
		height = 64,
		label = "查运价",
		fontSize = 24,
		textOnly = true,
		labelColor = {default={ 1, 1, 1 }, over={ 1,1,1 }},
		onEvent = queryPrice
	})
	seekPrice.x = width/3/3+width/3/2 
	seekPrice.y = 12 + 40 +40 +40 +40 +32
	sceneGroup:insert(seekPrice)

	local seekCar = widget.newButton(
	{
		width = width / 3,
		height = 64,
		label = "找 车",
		fontSize = 24,
		labelColor = {default={ 1, 1, 1 }, over={ 1,1,1 }},
		textOnly = true,
		onEvent = queryPackage
	})
	seekCar.x = width/3/3*2+width/3/2+width/3  
	seekCar.y = 12 + 40 +40 +40  +40 +32
	sceneGroup:insert(seekCar)

	list = widget.newTableView {
		top = height - 50 - 3*50,
		width = width,
		isBounceEnabled = false,
		height = 3 * 45 ,
		onRowRender = onRowRender,
		onRowTouch = onRowTouch,
		listener = scrollListener
	}
	list.isVisible = false
	showTableView()

end

function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase

	if phase == "will" then
		globalVars.tabBar.isVisible = true
		startField.isVisible = true
		finishField.isVisible = true
		kindField.isVisible = true
		tonNumField.isVisible = true
		carNumField.isVisible = true
		
	elseif phase == "did" then
		if (globalVars.judge) then
			if (globalVars.type == 0) then
				startField.text = globalVars.province .. globalVars.city .. globalVars.strict
				startProvince = globalVars.province
				startCity = globalVars.city
				startStrict = globalVars.strict
				globalVars.judge = false
			else
				finishField.text = globalVars.province .. globalVars.city .. globalVars.strict
				finishProvince = globalVars.province
				finishCity = globalVars.city
				finishStrict = globalVars.strict
				globalVars.judge = false
			end
		end
	end
	
end

function scene:hide( event )
	local sceneGroup = self.view
	local phase = event.phase

	if phase == "will" then
		startField.isVisible = false
		finishField.isVisible = false
		kindField.isVisible = false
		tonNumField.isVisible = false
		carNumField.isVisible = false
		list.isVisible = false
	elseif phase == "did" then

	end
end

function scene:destroy( event )
	local sceneGroup = self.view
end

function beginListener( event )

    if ( event.phase == "began" ) then
    	globalVars.origin = "seekCars"
    	globalVars.type = 0
    	list.isVisible = false
    	composer:gotoScene("showCities")
    	
    elseif ( event.phase == "ended" or event.phase == "submitted" ) then


    elseif ( event.phase == "editing" ) then

    end
end

function finishListener( event )

    if ( event.phase == "began" ) then
    	globalVars.origin = "seekCars"
    	globalVars.type = 1
    	list.isVisible = false
    	composer:gotoScene("showCities")
    	
    elseif ( event.phase == "ended" or event.phase == "submitted" ) then


    elseif ( event.phase == "editing" ) then

    end
end

function typeListener( event )

    if ( event.phase == "began" ) then
    	list.isVisible = true
    elseif ( event.phase == "ended" or event.phase == "submitted" ) then


    elseif ( event.phase == "editing" ) then

    end
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

function onRowTouch( event )
    if event.phase == "release" then
        
        local id = event.row.index
        kindField.text = tableData[id]
        transType = id
        list.isVisible = false
    end
    return true
end

function queryPackage(event)
	if ("ended" == event.phase) then 
		local weigh = tonNumField.text
		local volume = carNumField.text
		if (startField.text == "" or finishField.text == "" or transType == 0 or weigh == "" or volume == "" ) then
		native.showAlert( "注意", "内容不能为空" , { "好的" })
		else
		local headers = {}
            headers["Content-Type"] = "application/x-www-form-urlencoded"
			local params = {}
            params.headers = headers
            --http://freshly.duapp.com/seekSome.php?startProvince=四川&startCity=广元&startStrict=市中区&endProvince=江苏&endCity=泰州&endStrict=兴化市&weigh=30&volume=78&bigType=2&kind=1
			local body = "startProvince=" .. urlEncode(startProvince) .. "&startCity=" .. urlEncode(startCity) .. "&startStrict=" .. urlEncode(startStrict) .. "&endProvince=" .. urlEncode(finishProvince) .. "&endCity=" .. urlEncode(finishCity) .. "&endStrict=" .. urlEncode(finishStrict) ..  "&weigh=" .. tonumber(tonNumField.text) .. "&volume=" .. tonumber(carNumField.text) .. "&bigType=2" .. "&kind=" .. transType 
			network.request("http://freshly.duapp.com/seekSome.php?" .. body,"GET",seekSomeCars,params)
			native.setActivityIndicator( true )
		end
	end
end

function seekSomeCars( event )
	if (event.isError) then
		native.setActivityIndicator( false )
		native.showAlert( "注意", "网络有问题" , { "好的" } )
		
	else 
		local result = json.decode(event.response)
		local determine = result["code"]
		native.setActivityIndicator( false )
		if (determine == "no") then
			native.showAlert( "注意", "似乎发生了问题" , { "好的" } )
		elseif (determine == "none") then
			native.showAlert( "注意", "您要查找的不存在" , { "好的" } )
		else
			local options = {
    			effect = "fade",
    			time = 800,
    			params = result
			}
			globalVars.origin = "seekCars"
			globalVars.target = 2
			composer.gotoScene( "showSeeks", options )
		end
	end
end

function urlEncode( str )
    assert( type(str)=='string', "urlEncode: input not a string" )
    if (str) then
        str = string.gsub (str, "\n", "\r\n")
        str = string.gsub (str, "([^%w %-%_%.%~])",
            function (c) return string.format ("%%%02X", string.byte(c)) end)
        str = string.gsub (str, " ", "+")
    end
    return str
end


scene:addEventListener("create",scene)
scene:addEventListener("show",scene)
scene:addEventListener("hide",scene)
scene:addEventListener("destroy",scene)

return scene






