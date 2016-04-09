local composer = require("composer")
local scene = composer.newScene()
local widget = require("widget")
local GGData = require "GGData"
local json = require("json")
local globalVars = require "globalVars"

local box
local width = display.contentWidth
local height = display.contentHeight
local tableData
local list
local user,bigType

function scene:create( event )
	local sceneGroup = self.view

	local bg = display.newRect(0,0,width,height)
	bg.anchorX = 0
	bg.anchorY = 0
	bg:setFillColor(0.878,0.945,0.957)
	sceneGroup:insert(bg)

	local bar = display.newRect(0,0,width,38)
	bar.anchorX = 0
	bar.anchorY = 0
	bar:setFillColor(0.310,0.549,0.659)
	sceneGroup:insert(bar)

	local options = {
		text = "个人中心",
		x = 0 ,
		y = 8 ,
		width = width,
		height = 64,
		fontSize = 16,
		align = "center"
	}
	local nav = display.newText(options)
	nav:setFillColor(0.878,0.945,0.957)
	nav.anchorX = 0
	nav.anchorY = 0
	sceneGroup:insert(nav)

	local userOptions = {
		text = "status", 
		x = 0 ,
		y = 68 ,
		width = width,
		height = 58,
		fontSize = 18,
		align = "center"
	}
	user = display.newText(userOptions)
	user:setFillColor(0.804,0.612,0.608)
	user.anchorX = 0
	user.anchorY = 0
	
	sceneGroup:insert(user)

	--setup tableView
	tableData = {}
	tableData[1] = "我注册的车"
	tableData[2] = "我发布的货"
	tableData[3] = "添加货/车"
	tableData[4] = "退出/登陆"

	list = widget.newTableView {
		top = 120,
		width = width,
		height = 4 * 44 ,
		isLocked = true,
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
		globalVars.tabBar.isVisible = true
	elseif phase == "did" then
		box = GGData:new("user")
		local role 
		if (box.role == "carUser") then
			role = "车主"
			bigType = 2
		else
			role = "货主"
			bigType = 1
		end

		if (box.status == "login") then
		user.text = role .."：" .. box.phone
	else
		user.text = "您还未登陆"
	end
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
        if (id == 1) then
        	if (box.status == "login" and bigType == 2 ) then
        		local headers = {}
            	headers["Content-Type"] = "application/x-www-form-urlencoded"
				local params = {}
            	params.headers = headers
				local body = "user_name=" .. box.phone .. "&bigType=2" 
				network.request("http://freshly.duapp.com/queryItems.php?" .. body,"GET",seekSelfCars,params)
				native.setActivityIndicator( true )
			elseif (box.status == "login" and bigType == 1) then
				native.showAlert( "注意", "您是货主，无法查询这个" , { "好的" } )
			else
				native.showAlert( "注意", "您还未登陆" , { "好的" } )
			end

        elseif (id == 2) then
        	if (box.status == "login" and bigType == 1) then
        		local headers = {}
           	 	headers["Content-Type"] = "application/x-www-form-urlencoded"
				local params = {}
            	params.headers = headers
				local body = "user_name=" .. box.phone .. "&bigType=1" 
				network.request("http://freshly.duapp.com/queryItems.php?" .. body,"GET",seekSelfGoods,params)
        	 	native.setActivityIndicator( true )
        	 elseif (box.status == "login" and bigType == 2) then
        	 	native.showAlert( "注意", "您是车主，无法查询这个" , { "好的" } )
        	 else
        	 	native.showAlert( "注意", "您还未登陆" , { "好的" } )
        	 end
        elseif (id == 3) then
        	if ( box.status == "login") then
        		globalVars.origin = "profile"
				composer.gotoScene( "addInfo" )
			else
				native.showAlert( "注意", "请先登录再添加相关信息" , { "好的" } )
			end
        	
        elseif (id == 4) then
        	box:set("status","needAgain")
        	box:set("phone"," ")
        	box:save()
        	composer.gotoScene( "loginRegister" )
        end
    end
    return true
end

function seekSelfCars( event )
	if (event.isError) then
		native.setActivityIndicator( false )
		native.showAlert( "注意", "网络有问题" , { "好的" } )
	else 
		local result = json.decode(event.response)
		native.setActivityIndicator( false )
		local determine = result["code"]
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
			globalVars.target = 4
			globalVars.origin = "profile"
			composer.gotoScene( "selfInfo", options )
		end
	end
end

function seekSelfGoods( event )
	if (event.isError) then
		native.setActivityIndicator( false )
		native.showAlert( "注意", "网络有问题" , { "好的" } )
	else 
		local result = json.decode(event.response)
		native.setActivityIndicator( false )
		local determine = result["code"]
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
			globalVars.target = 3
			globalVars.origin = "profile"
			composer.gotoScene( "selfInfo", options )
		end
	end
end


scene:addEventListener("create",scene)
scene:addEventListener("show",scene)
scene:addEventListener("hide",scene)
scene:addEventListener("destroy",scene)

return scene