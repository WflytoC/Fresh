---种类：1、2、3分别表示三种


local composer = require("composer")
local scene = composer.newScene()
local widget = require("widget")
local GGData = require "GGData"
local json = require("json")
local globalVars = require "globalVars"
local codes = require("company")
local startProvince,startCity,startStrict
local finishProvince,finishCity,finishStrict
local transType = 0
local bigType = 2
local add
local back,titleInfo
local latitude,longitude


--列表数据源
local  tableData,otherData
--种类列表
local list,other

local box

local startField,finishField,kindField,detailBox,tonNumField,carNumField
local width = display.contentWidth
local height = display.contentHeight

function scene:create( event )

	print("scene:create")
	local sceneGroup = self.view

	local bg = display.newRect(0,0,display.contentWidth,display.contentHeight)
	bg.anchorX = 0
	bg.anchorY = 0
	bg:setFillColor(0.878,0.945,0.957)
	sceneGroup:insert(bg)

	local bar = display.newRect(0,0,width,38)
	bar.anchorX = 0
	bar.anchorY = 0
	bar:setFillColor(0,0.5,0.5)
	sceneGroup:insert(bar)


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
	back.y = 22-4
	sceneGroup:insert(back)

	titleInfo = display.newText("上传你的数据",width/2,44,native.systemFont,15)
	titleInfo.x = width/2
	titleInfo.anchorY = 0
	titleInfo.y = 8
	sceneGroup:insert(titleInfo)

	local start = display.newText("装 点",width/5,40,native.systemFont,18)
	start.x = width/5/2
	start.y = 12 + 20 + 28+ 20
	start:setFillColor(0.310,0.549,0.659)
	sceneGroup:insert(start)

	startField = native.newTextField(width/5*3,12+20+ 28+ 20,width/5*4-12,28)
	sceneGroup:insert(startField)
	startField:addEventListener( "userInput", beginListener )

	local finish = display.newText("卸 点",width/5,40,native.systemFont,18)
	finish.x = width/5/2
	finish.y = 12 + 40 +20+ 28+ 20
	finish:setFillColor(0.310,0.549,0.659)
	sceneGroup:insert(finish)

	finishField = native.newTextField(width/5*3,12+40+20+ 28+ 20,width/5*4-12,28)
	sceneGroup:insert(finishField)
	finishField:addEventListener( "userInput", finishListener )

	local kind = display.newText("种 类",width/5,40,native.systemFont,18)
	kind.x = width/5/2
	kind.y = 12 + 40 +40 +20+ 28+ 20
	kind:setFillColor(0.310,0.549,0.659)
	sceneGroup:insert(kind)

	kindField = native.newTextField(width/5*3,12+40+40+20+ 28+ 20,width/5*4-12,28)
	sceneGroup:insert(kindField)
	kindField:addEventListener( "userInput", typeListener )


	local detail = display.newText("详 情",width/5,40,native.systemFont,18)
	detail.x = width/5/2
	detail.y = 12 + 40 +40 +40 +40+20+ 28+ 20
	detail:setFillColor(0.310,0.549,0.659)
	sceneGroup:insert(detail)

	detailBox = native.newTextBox(width/5*3,12+40+40+40+40+20+20+ 28+ 20,width/5*4-12,56)
	detailBox.isEditable = true
	sceneGroup:insert(detailBox)


	local tonNum = display.newText("重量(kg)",width/2/2,40,native.systemFont,18)
	tonNum.x = width/2/2/2
	tonNum.y = 12 + 40 +40 +40 +20+ 28+ 20
	tonNum:setFillColor(0.310,0.549,0.659)
	sceneGroup:insert(tonNum)

	tonNumField = native.newTextField(width/2/2+width/2/2/2,12+40+40+40+20+ 28+ 20,width/2/2-10,28)
	sceneGroup:insert(tonNumField)

	local carNum = display.newText("体积(L)",width/2/2,40,native.systemFont,18)
	carNum.x = width/2/2/2 + width/2
	carNum.y = 12 + 40 +40 +40  +20+ 28+ 20
	carNum:setFillColor(0.310,0.549,0.659)
	sceneGroup:insert(carNum)

	carNumField = native.newTextField(width/2+width/2/2+width/2/2/2,12+40+40+40+20+ 28+ 20,width/2/2-10,28)
	sceneGroup:insert(carNumField)

	local btnTitle
	if (bigType == 1) then
		btnTitle = "添加货物"
	else
		btnTitle = "添加车辆"
	end



	add = widget.newButton(
	{
		width = width / 3,
		height = 64,
		label = btnTitle,
		fontSize = 24,
		textOnly = true,
		labelColor = {default={ 0, 0, 0 }, over={ 1,1,1 }},
		onEvent = addItem
	})
	add.x = width/2
	add.y = 12+40+40+40+40+20+20+32+64
	sceneGroup:insert(add)

	list = widget.newTableView {
		top = 12+40+40+40+40+20+20+32+64+28,
		width = width,
		isBounceEnabled = false,
		height = 3 * 28 ,
		onRowRender = onRowRender,
		onRowTouch = onRowTouch,
		listener = scrollListener
	}
	list.isVisible = false

	other = widget.newTableView {
		top = 12+40+40+40+40+20+20+32+64+28,
		width = width,
		isBounceEnabled = false,
		height = 3 * 28 ,
		onRowRender = onRowRender,
		onRowTouch = onRowTouchOther,
		listener = scrollListener
	}
	other.isVisible = false

	tableData = codes.goodTypes
	otherData = codes.foodTypes

	box = GGData:new("user")
		local role 
		if (box.role == "carUser") then
			add:setLabel( "添加车辆" )
			bigType = 1
		else
			add:setLabel( "添加货物" )
			bigType = 2
		end
		showTableView()
		showTableViewOther()
		sceneGroup:insert(list)
		sceneGroup:insert(other)


end

function scene:show( event )
	print("scene:show")
	local sceneGroup = self.view
	local phase = event.phase
	globalVars.isShow = true
		

	if phase == "will" then
		globalVars.tabBar.isVisible = false
		startField.isVisible = true
		finishField.isVisible = true
		kindField.isVisible = true
		detailBox.isVisible = true
		carNumField.isVisible = true
		tonNumField.isVisible = true

		


	

		
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
		detailBox.isVisible = false
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
    	composer:gotoScene("showCities")
    	globalVars.origin = "addInfo"
    	globalVars.type = 0
    	list.isVisible = false
    elseif ( event.phase == "ended" or event.phase == "submitted" ) then


    elseif ( event.phase == "editing" ) then

    end
end

function finishListener( event )

    if ( event.phase == "began" ) then
    	list.isVisible = false
    	composer:gotoScene("showCities")
    	globalVars.origin = "addInfo"
    	globalVars.type = 1
    elseif ( event.phase == "ended" or event.phase == "submitted" ) then


    elseif ( event.phase == "editing" ) then

    end
end

function typeListener( event )

    if ( event.phase == "began" ) then
    	box = GGData:new("user")
		if (box.role == "carUser") then
			add:setLabel( "添加车辆" )
			bigType = 1
			list.isVisible = true
			other.isVisible = false
		else
			add:setLabel( "添加货物" )
			bigType = 2
			other.isVisible = true
			list.isVisible = false
		end

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

function showTableViewOther()

	for i = 1,#otherData do
		other:insertRow {
		rowHeight = 44,
		isCategory = false,
		rowColor = {0,0.5,0.5},
		lineColor = {0.90,0.90,0.90},
		params = {
			name = otherData[i]
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
        transType = (id - 1)%3 + 1
        list.isVisible = false
    end
    return true
end

function onRowTouchOther( event )
    if event.phase == "release" then
        
        local id = event.row.index
        kindField.text = otherData[id]
        transType = (id - 1)%3 + 1
        other.isVisible = false
    end
    return true
end

function addItem(event)
	if ("ended" == event.phase) then 
		local weigh = tonNumField.text
		local volume = carNumField.text
		local detail =  detailBox.text
		if (startProvince.text == "" or finishProvince.text == "" or transType == 0 or weigh == "" or volume == ""  or detail == "") then
		native.showAlert( "注意", "内容不能为空" , { "好的" })
		else
			local headers = {}
            headers["Content-Type"] = "application/x-www-form-urlencoded"
			local params = {}
            params.headers = headers
			local body = "user_name=" .. box.phone .. "&startProvince=" .. urlEncode(startProvince) .. "&startCity=" .. urlEncode(startCity) .. "&startStrict=" .. urlEncode(startStrict) .. "&endProvince=" .. urlEncode(finishProvince) .. "&endCity=" .. urlEncode(finishCity) .. "&endStrict=" .. urlEncode(finishStrict) .. "&detail=" .. urlEncode(detailBox.text) .. "&weigh=" .. tonumber(tonNumField.text) .. "&volume=" .. tonumber(carNumField.text) .. "&bigType=" .. tonumber(bigType)  .. "&kind=" .. transType .. "&latitude=" .. tonumber(latitude) .. "&longitude=" .. tonumber(longitude)
			local url = string.gsub(body," ","")
			network.request("http://freshly.duapp.com/addInfos.php?" .. url,"GET",addInfos,params)
			native.setActivityIndicator( true )
		end
	end
end

function addInfos( event )
	Runtime:removeEventListener( "location", locationHandler )
	if (event.isError) then
		native.setActivityIndicator( false )
		native.showAlert( "注意", "网络有问题" , { "好的" } )
	else 
		native.setActivityIndicator( false )
		local result = json.decode(event.response)
		local code = result["code"]
		if (code == "ok") then 
			startField.text = ""
			finishField.text = ""
			kindField.text = ""
			detailBox.text = ""
			tonNumField.text = ""
			carNumField.text = ""
			native.showAlert( "注意", "添加成功" , { "好的" } )
			composer.gotoScene("profile")
			globalVars.isShow = false
			composer.removeScene( "addInfos" )
		else
			native.showAlert( "注意", "添加信息失败" , { "好的" } )
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

function backTo( event )
	if ("ended" == event.phase) then
		composer.gotoScene("profile")
		globalVars.isShow = false
		Runtime:removeEventListener( "location", locationHandler )
	end
end

function locationHandler(event)

	if (event.errorCode) then
		native.showAlert( "注意", "定位发生错误" , { "知道啦" } )
	else 
		latitude = event.latitude
		longitude = event.longitude
	end
end 


scene:addEventListener("create",scene)
scene:addEventListener("show",scene)
scene:addEventListener("hide",scene)
scene:addEventListener("destroy",scene)
Runtime:addEventListener( "location", locationHandler )


return scene






