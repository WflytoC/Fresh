local composer = require("composer")
local scene = composer.newScene()
local widget = require("widget")
local GGData = require "GGData"
local jsonData = require ("jsonData")
local json = require("json")
local codes = require("company")
local globalVars = require "globalVars"

local startProvince,startCity,startStrict
local finishProvince,finishCity,finishStrict
local transType = 0
local box = GGData:new("user")

local  tableData = codes.goodTypes
local list

local startField,finishField,kindField,detailField,containField

local width = display.contentWidth
local height = display.contentHeight

function scene:create( event )
	local sceneGroup = self.view
	local info = jsonData.info
	local data = json.decode(info)
	print("count = " .. #jsonData.stricts["东城区"])
	--print("name" .. data[3]["name"])

	local bg = display.newRect(0,0,display.contentWidth,display.contentHeight)
	bg.anchorX = 0
	bg.anchorY = 0
	bg:setFillColor(0.878,0.945,0.957)
	sceneGroup:insert(bg)

	if (not box.status) then
		local options = {
    		isModal = true,
    		effect = "fade",
    		time = 400
		}
		composer.showOverlay( "loginRegister", options )
	end

	local start = display.newText("装 点",width/5,40,native.systemFont,18)
	start.x = width/5/2
	start.y = 12 + 20+20
	start:setFillColor(0.310,0.549,0.659)
	sceneGroup:insert(start)

	startField = native.newTextField(width/5*3,12+20+20,width/5*4-12,28)
	sceneGroup:insert(startField)
	startField:addEventListener( "userInput", beginListener )

	local finish = display.newText("卸 点",width/5,40,native.systemFont,18)
	finish.x = width/5/2
	finish.y = 12 + 40 +20+20
	finish:setFillColor(0.310,0.549,0.659)
	sceneGroup:insert(finish)

	finishField = native.newTextField(width/5*3,12+40+20+20,width/5*4-12,28)
	sceneGroup:insert(finishField)
		finishField:addEventListener( "userInput", finishListener )


	local kind = display.newText("种 类",width/5,40,native.systemFont,18)
	kind.x = width/5/2
	kind.y = 12 + 40 +40 +20+20
	kind:setFillColor(0.310,0.549,0.659)
	sceneGroup:insert(kind)

	kindField = native.newTextField(width/5*3,12+40+40+20+20,width/5*4-12,28)
	sceneGroup:insert(kindField)
	kindField:addEventListener( "userInput", typeListener )



	local detail = display.newText("重量(kg)",width/5,40,native.systemFont,18)
	detail.x = width/5/2
	detail.y = 12 + 40 +40 +40 +20+20
	detail:setFillColor(0.310,0.549,0.659)
	sceneGroup:insert(detail)

	detailField = native.newTextField(width/5*3,12+40+40+40+20+20,width/5*4-12,28)
	sceneGroup:insert(detailField)

	local contain = display.newText("体积(L)",width/5,40,native.systemFont,18)
	contain.x = width/5/2
	contain.y = 12 + 40 +40 +40 +40 +20+20
	contain:setFillColor(0.310,0.549,0.659)
	sceneGroup:insert(contain)

	containField = native.newTextField(width/5*3,12+40+40+40+40+20+20,width/5*4-12,28)
	sceneGroup:insert(containField)

	

	local seekGood = widget.newButton(
	{
		width = width / 3,
		height = 64,
		label = "找 货",
		fontSize = 24,
		textOnly = true,
		labelColor = {default={ 0, 0, 0 }, over={ 1,1,1 }},
		onEvent = queryPackage
	})
	seekGood.x = width/2
	seekGood.y = 12 + 40 +40 +40 +40 +40 +32+20+10
	sceneGroup:insert(seekGood)

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
		detailField.isVisible = true
		containField.isVisible = true
		list.isVisible = false
		
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
		detailField.isVisible = false
		containField.isVisible = false
		list.isVisible = false
	elseif phase == "did" then

	end
end

function scene:destroy( event )
	local sceneGroup = self.view
end

function beginListener( event )

    if ( event.phase == "began" ) then
    	globalVars.origin = "seekGoods"
    	globalVars.type = 0
    	list.isVisible = false
    	composer:gotoScene("showCities")
    	
    elseif ( event.phase == "ended" or event.phase == "submitted" ) then


    elseif ( event.phase == "editing" ) then

    end
end

function finishListener( event )

    if ( event.phase == "began" ) then
    	globalVars.origin = "seekGoods"
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
		local volume = containField.text
		local weigh =  detailField.text
		if (startField.text == "" or finishField.text == "" or transType == 0 or weigh == "" or volume == "") then
		native.showAlert( "注意", "内容不为空" , { "好的" })
		else
			local headers = {}
            headers["Content-Type"] = "application/x-www-form-urlencoded"
			local params = {}
            params.headers = headers
			local body = "startProvince=" .. urlEncode(startProvince) .. "&startCity=" .. urlEncode(startCity) .. "&startStrict=" .. urlEncode(startStrict) .. "&endProvince=" .. urlEncode(finishProvince) .. "&endCity=" .. urlEncode(finishCity) .. "&endStrict=" .. urlEncode(finishStrict) ..  "&weigh=" .. tonumber(detailField.text) .. "&volume=" .. tonumber(containField.text) .. "&bigType=1" .. "&kind=" .. transType 
			network.request("http://freshly.duapp.com/seekSome.php?" .. body,"GET",seekSomeGoods,params)
			native.setActivityIndicator( true )
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

function seekSomeGoods( event )
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
			globalVars.target = 1
			globalVars.origin = "seekGoods"
			composer.gotoScene( "showSeeks", options )
		end
	end
end


scene:addEventListener("create",scene)
scene:addEventListener("show",scene)
scene:addEventListener("hide",scene)
scene:addEventListener("destroy",scene)

return scene






