local composer = require("composer")
local scene = composer.newScene()
local widget = require("widget")
local json = require("json")
local globalVars = require "globalVars"
local bigType = 1
local carRadio,goodsRadio

local GGData = require "GGData"

local box = GGData:new("user")



local nameField
local passField


function scene:create( event )
	local sceneGroup = self.view

	local width = display.contentWidth
	local height = display.contentHeight

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


local options = 
{
    --parent = textGroup,
    text = "鲜 速 达",     
    x = 0,
    y = 8,
    height = 64,
    width = width,     --required for multi-line and alignment
    font = native.systemFontBold,   
    fontSize = 16,
    align = "center"  --new alignment parameter
}

	local nav = display.newText(options)
	nav:setFillColor(0.878,0.945,0.957)
	nav.anchorX = 0
	nav.anchorY = 0
	sceneGroup:insert(nav)

	local function handleRegister( event )
		if ("ended" == event.phase) then 
			
			local name = nameField.text
			local pass = passField.text
			if (name  == "" or pass == "") then
				native.showAlert( "注意", "输入框不能为空" , { "好的" } )
			else
				local body = "phone=" .. name .. "&key=" .. "be143bcb88d5b9c56a82c6fd7c99f28a"
				network.request("http://apis.juhe.cn/mobile/get?" .. body,"GET",valide)
				native.setActivityIndicator( true )
			end
		end
	end

	local function handleLogin( event )
		if ("ended" == event.phase) then
			local name = nameField.text
			local pass = passField.text
			if (name  == "" or pass == "") then
				native.showAlert( "注意", "输入框不能为空" , { "好的" } )
			else
				local body = "user_name=" ..name .."&user_password=" .. pass 
				network.request("http://freshly.duapp.com/login.php?" .. body,"GET",login)
				native.setActivityIndicator( true )
			end
		end
	end

	local function handleSkip( event )
		if ("ended" == event.phase) then 
			globalVars.isShow = false
			box:set("status","skip")
			box:save()
			composer.gotoScene( "profile" )
			globalVars.isLogin = false
		end
	end

	local goods = display.newText("货 主",width/2/2,40,native.systemFont,18)
	goods.x = width/2/2/2
	goods.y = 64 + 20
	goods:setFillColor(0.310,0.549,0.659)
	sceneGroup:insert(goods)
--
	local car = display.newText("车 主",width/2/2,40,native.systemFont,18)
	car.x = width/2/2/2 + width/2
	car.y = 64 + 20
	car:setFillColor(0.310,0.549,0.659)
	sceneGroup:insert(car)

	local radioGroup = display.newGroup()
	goodsRadio = widget.newSwitch
	{
    	left = width/2/2,
    	top = 48 + 20,
    	style = "radio",
    	id = "one",
    	initialSwitchState = true,
    	onPress = onSwitchPress
	}
	radioGroup:insert( goodsRadio )

	carRadio = widget.newSwitch
	{
    	left = width/2+width/2/2,
    	top = 48 + 20,
    	style = "radio",
    	id = "two",
    	onPress = onSwitchPress
	}
	radioGroup:insert( carRadio )


	local name = display.newText("号码",width/5,56,native.systemFont,18)
	name.x = width/5/2
	name.y = height/4+28 + 20
	name:setFillColor(0.310,0.549,0.659)
	sceneGroup:insert(name)

	nameField = native.newTextField(width/5*3,height/4+28 + 20,width/5*4-12,32)
	name.inputType = "number"
	sceneGroup:insert(nameField)

	local pass = display.newText("密码",width/5,56,native.systemFont,18)
	pass.x = width/5/2
	pass.y = height/4+28+56 + 20
	pass:setFillColor(0.310,0.549,0.659)
	sceneGroup:insert(pass)

	passField = native.newTextField(width/5*3,height/4+28+56 + 20,width/5*4-12,32)
	sceneGroup:insert(passField)
	passField.isSecure = true

	local login = widget.newButton(
	 {
		width = width / 3,
		height = 100,
		label = "登 陆",
		textOnly = true,
		labelColor = { default={ 0, 0, 0 }, over={ 0, 0, 0, 0.5 } },
		onEvent = handleLogin
	 })
	login.x = 30
	login.y = height/4 + 56*2.5 + 20
	login.anchorX = 0
	login.anchorY = 0
	sceneGroup:insert(login)

	local register = widget.newButton(
	{
		width = width / 3,
		height = 100,
		label = "注 册",
		textOnly = true,
		labelColor = { default={ 0, 0, 0 }, over={ 0, 0, 0, 0.5 } },
		onEvent = handleRegister
	})
	register.x = width / 2
	register.y = height/4 + 56*2.5 + 20
	register.anchorY = 0
	sceneGroup:insert(register)

	local skip = widget.newButton(
	{
		width = width / 3,
		height = 100,
		label = "跳 过",
		textOnly = true,
		labelColor = { default={ 0, 0, 0 }, over={ 0, 0, 0, 0.5 } },
		onEvent = handleSkip
	})
	skip.x = width -30
	skip.y = height/4 + 56*2.5 + 20
	skip.anchorX = 1
	skip.anchorY = 0
	sceneGroup:insert(skip)




	


end

function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase

	if phase == "will" then
		globalVars.tabBar.isVisible = false
		nameField.isVisible = true
		passField.isVisible = true
		carRadio.isVisible = true
		goodsRadio.isVisible = true
	elseif phase == "did" then
		globalVars.isLogin = true
		globalVars.isShow = true
	end
end

function scene:hide( event )
	local sceneGroup = self.view
	local phase = event.phase

	if phase == "will" then
		nameField.isVisible = false
		passField.isVisible = false
		carRadio.isVisible = false
		goodsRadio.isVisible = false
	elseif phase == "did" then

	end
end

function scene:destroy( event )
	local sceneGroup = self.view
end

--some useful functions

function login( event )
	if (event.isError) then
		native.setActivityIndicator( false )
		native.showAlert( "注意", "网络有问题" , { "好的" } )
	else 
		local result = json.decode(event.response)
		local code = result["code"]
		native.setActivityIndicator( false )
		if (code == "car") then 
			globalVars.isShow = false
			box:set("status","login")
			box:set("phone",nameField.text)
			box:set("role","carUser")
			box:save()
			composer.gotoScene( "profile" )
			globalVars.isLogin = false
		elseif (code == "goods") then
			globalVars.isShow = false
			box:set("status","login")
			box:set("phone",nameField.text)
			box:set("role","goodsUser")
			box:save()
			composer.gotoScene( "profile" )
			globalVars.isLogin = false
		else
			native.showAlert( "注意", "您还没注册或密码错误" , { "好的" } )
			nameField.text = ""
			passField.text = ""
		end
	end
end

function register( event )
	if (event.isError) then
		native.setActivityIndicator( false )
		native.showAlert( "注意", "网络有问题" , { "好的" } )
	else 
		local result = json.decode(event.response)
		local code = result["code"]
		native.setActivityIndicator( false )
		if (code == "goods") then 
			globalVars.isShow = false
			box:set("status","login")
			box:set("phone",nameField.text)
			box:set("role","goodsUser")
			box:save()
			composer.gotoScene( "profile" )
			globalVars.isLogin = false
		elseif (code == "car") then
			globalVars.isShow = false
			box:set("status","login")
			box:set("phone",nameField.text)
			box:set("role","carUser")
			box:save()
			composer.gotoScene( "profile" )
			globalVars.isLogin = false
		elseif (code == "forbiddenGoods") then
			native.showAlert( "注意", "您已是郑明公司车主，无法成为货主" , { "好的" } )
			nameField.text = ""
			passField.text = ""
		elseif (code == "forbiddenCar") then
			native.showAlert( "注意", "您暂时还未假如郑明公司，无法成为车主" , { "好的" } )
			nameField.text = ""
			passField.text = ""
		elseif (code == "repeat") then
			native.showAlert( "注意", "号码已经注册，请登录" , { "好的" } )
			nameField.text = ""
			passField.text = ""
		else
			native.showAlert( "注意", "您还没注册或密码错误" , { "好的" } )
			nameField.text = ""
			passField.text = ""
		end
	end
end

function valide( event )
	if (event.isError) then
		native.setActivityIndicator( false )
		native.showAlert( "注意", "网络有问题" , { "好的" } )
	else 
		local result = json.decode(event.response)
		if (result["resultcode"] == "200") then
			local name = nameField.text
			local pass = passField.text
			local body = "user_name=" ..name .."&user_password=" .. pass .. "&user_kind=" .. bigType
			network.request("http://freshly.duapp.com/register.php?" .. body,"GET",register)
		else
			native.showAlert( "注意", "您填写的号码有错误" , { "好的" } )
			nameField.text = ""
			passField.text = ""
		end
		
	end
end

function onSwitchPress( event )
    local switch = event.target
    if (switch.id == "one") then
    	bigType = 1
    else
    	bigType = 2
    end
end


scene:addEventListener("create",scene)
scene:addEventListener("show",scene)
scene:addEventListener("hide",scene)
scene:addEventListener("destroy",scene)

return scene