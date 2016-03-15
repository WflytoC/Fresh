-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

-- show default status bar (iOS)
--display.setStatusBar( display.DefaultStatusBar )

-- include Corona's "widget" library
local widget = require "widget"
local composer = require "composer"
local globalVars = require "globalVars"
local GGData = require "GGData"
local box = GGData:new("user")
globalVars.isShow = false
globalVars.isLogin = false

display.setStatusBar( display.HiddenStatusBar )
-- event listeners for tab buttons:
local function onFirstView( event )
	if (not globalVars.isShow) then
	composer.gotoScene( "seekCars" )
	elseif (not globalVars.isLogin) then
		native.showAlert( "注意", "请按返回键退出当前页面" , { "好的" } )
	else
	native.showAlert( "注意", "请选择一种方式登录" , { "好的" } )	end
end

local function onSecondView( event )
	if (not globalVars.isShow) then
	composer.gotoScene( "seekGoods" )
	elseif (not globalVars.isLogin) then
		native.showAlert( "注意", "请按返回键退出当前页面" , { "好的" } )
	else
	native.showAlert( "注意", "请选择一种方式登录" , { "好的" } )
	end
end

local function onThirdView( event )
	if (not globalVars.isShow) then
	composer.gotoScene("queryPackage")
	elseif (not globalVars.isLogin) then
		native.showAlert( "注意", "请按返回键退出当前页面" , { "好的" } )
	else
	native.showAlert( "注意", "请选择一种方式登录" , { "好的" } )
	end
end

local function onForthView( event )
	if (not globalVars.isShow) then
	composer.gotoScene("profile")
	elseif (not globalVars.isLogin) then
		native.showAlert( "注意", "请按返回键退出当前页面" , { "好的" } )
	else
	native.showAlert( "注意", "请选择一种方式登录" , { "好的" } )
	end
end




-- create a tabBar widget with two buttons at the bottom of the screen

-- table to setup buttons
local tabButtons = {
	{ 
	label="找车", 
	defaultFile="icon1.png", 
	overFile="icon1-down.png", 
	width = 32, 
	height = 32, 
	onPress=onFirstView, 
	labelColor = { default={ 0.247, 0.737, 0.961}, over={ 0.0, 0.592, 0.314} },
	selected=true 
	},
	{ 
	label="找货", 
	defaultFile="icon2.png", 
	overFile="icon2-down.png", 
	width = 32, 
	height = 32, 
	labelColor = { default={ 0.247, 0.737, 0.961}, over={ 0.0, 0.592, 0.314} },
	onPress=onSecondView 
	},
	{ 
	label="物流", 
	defaultFile="icon1.png", 
	overFile="icon1-down.png", 
	width = 32, 
	height = 32, 
	labelColor = { default={ 0.247, 0.737, 0.961}, over={ 0.0, 0.592, 0.314 } },
	onPress=onThirdView  
	},
	{ 
	label="设置", 
	defaultFile="icon2.png", 
	overFile="icon2-down.png", 
	width = 32, 
	height = 32, 
	labelColor = { default={ 0.247, 0.737, 0.961 }, over={ 0.0, 0.592, 0.314} },
	onPress=onForthView  
	}
}

-- create the actual tabBar widget
globalVars.tabBar = widget.newTabBar{
	top = display.contentHeight - 50,	-- 50 is default height for tabBar widget
	buttons = tabButtons
	
}


globalVars.judge = false

composer.gotoScene("splash")




