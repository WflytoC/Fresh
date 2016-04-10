local composer = require("composer")
local scene = composer.newScene()
local codes = require("company")
local widget = require("widget")
local json = require("json")
local globalVars = require "globalVars"

--c57cfccecfc4f74f
-- 320×222 

local companyField
local orderField
local  tableData = codes.companies
local list
local flag = -1
local webView
function scene:create( event )
	local sceneGroup = self.view

	local width = display.contentWidth
	local height = display.contentHeight

	local bg = display.newRect(0,0,width,height)
	bg.anchorX = 0
	bg.anchorY = 0
	bg:setFillColor(0.878,0.945,0.957)
	sceneGroup:insert(bg)

	local company = display.newText("公 司",width/5,56,native.systemFont,18)
	company.x = width/5/2
	company.y = height/12+28
	company:setFillColor(0.310,0.549,0.659)
	sceneGroup:insert(company)

	companyField = native.newTextField(width/5*3,height/12+28,width/5*4-12,32)
	sceneGroup:insert(companyField)
	companyField:addEventListener("userInput",textListener)

	local order = display.newText("单号",width/5,56,native.systemFont,18)
	order.x = width/5/2
	order.y = height/12+28+56
	order:setFillColor(0.310,0.549,0.659)
	sceneGroup:insert(order)

	orderField = native.newTextField(width/5*3,height/12+28+56,width/5*4-12,32)
	sceneGroup:insert(orderField)
	orderField.inputType = "number"
	orderField:addEventListener("userInput",orderListener)


	local query = widget.newButton(
	{
		width = width / 3,
		height = 100,
		label = "查 询",
		fontSize = 24,
		textOnly = true,
		labelColor = {default={ 0, 0, 0 }, over={ 1,1,1 }},
		onEvent = queryPackage
	})
	query.x = width / 2
	query.y = height/12+56+56+25
	sceneGroup:insert(query)

	webView = native.newWebView(width/2,height/12+56+56+60+(height - (height/12+56+56+50) - 60)/2,width-20,height - (height/12+56+56+50) - 80)
	webView.isVisible = false
	list = widget.newTableView {
		top = height/12+56+56+100,
		width = width,
		isBounceEnabled = false,
		height = 3 * 44 ,
		onRowRender = onRowRender,
		onRowTouch = onRowTouch,
		listener = scrollListener
	}
	list.isVisible = false
	showTableView()

	sceneGroup:insert(list)


	
end

function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase

	if phase == "will" then
		globalVars.tabBar.isVisible = true
		companyField.isVisible = true
		orderField.isVisible = true
	elseif phase == "did" then
		--http://www.kuaidi100.com/applyurl?key=[]&com=[]&nu=[]
		--local body = "id=" .. "c57cfccecfc4f74f" .. "&com=" .. "shentong" .. "&nu=" .. "227277756920" .. "&valicode=" .."".. "&show=0" .. "&muti=0" .. "&order=desc"
		local body = "key=" .. "c57cfccecfc4f74f" .. "&com=" .. "shentong" .. "&nu=" .. "227277756920"
		--network.request("http://www.kuaidi100.com/applyurl?" .. body,"GET",networkListener)
	end
end

function scene:hide( event )
	local sceneGroup = self.view
	local phase = event.phase

	if phase == "will" then
		webView.isVisible = false
		companyField.isVisible = false
		orderField.isVisible = false
	elseif phase == "did" then

	end
end

function scene:destroy( event )
	local sceneGroup = self.view
end

function networkListener( event )
	if (event.isError) then
		native.showAlert( "注意", "网络有问题" , { "好的" } )
	else
		print("Response: " .. event.response)
	end
end

function queryPackage( event )
	if ("ended" == event.phase) then 
		list.isVisible = false
		webView.isVisible = false
		if (companyField.text == "" or orderField.text == "") then
			native.showAlert( "注意", "输入框不能为空" , { "好的" } )
		else

			local comName = companyField.text
			local code = codes[comName]
			if (code == nil) then
				native.showAlert( "注意", "填写的物流公司不存在" , { "好的" })
				companyField.text = ""
				return true
			end

			if (flag == -1) then
				native.showAlert( "注意", "请选择一家物流公司" , { "好的" })
			elseif (flag == 0) then
				--html
				--http://www.kuaidi100.com/applyurl?key=[]&com=[]&nu=[] 
				local body = "key=" .. "c57cfccecfc4f74f" .. "&com=" .. code .. "&nu=" .. orderField.text
				network.request("http://www.kuaidi100.com/applyurl?" .. body,"GET",htmlRequest)
				native.setActivityIndicator( true )
			else
				--josn
				local body = "id=" .. "c57cfccecfc4f74f" .. "&com=" .. code .. "&nu=" .. orderField.text .. "&valicode=" .."".. "&show=0" .. "&muti=0" .. "&order=desc"
				network.request("http://api.kuaidi100.com/api?" .. body,"GET",jsonRequest)
				native.setActivityIndicator( true )
			end
		end
		companyField.text = ""
		orderField.text = ""
	end
end

function  textListener( event )

	if ( event.phase == "began" ) then
        list.isVisible = true
        webView.isVisible = false
    elseif ( event.phase == "ended" or event.phase == "submitted" ) then

    elseif ( event.phase == "editing" ) then
        list.isVisible = true
    end

end

function  orderListener( event )

	if ( event.phase == "began" ) then
        list.isVisible = false
        webView.isVisible = false
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
        local compName = tableData[id]
        local code = codes[compName]
        companyField.text = compName
        
        if (id < 8) then
        	flag = 0

        else
        	flag = 1

        end
    end
    return true
end

function htmlRequest( event )
	if (event.isError) then
		native.setActivityIndicator( false )
		native.showAlert( "注意", "网络有问题" , { "好的" } )
	else
		native.setActivityIndicator( false )
		webView:request( event.response )
		webView.isVisible = true
	end
end

function jsonRequest( event )
	if (event.isError) then
		native.setActivityIndicator( false )
		native.showAlert( "注意", "网络有问题" , { "好的" } )
	else
		local result = json.decode(event.response)
		local status = result["status"]
		print(event.response)
		print("")
		native.setActivityIndicator( false )
		if (status == 0) then
			native.showAlert( "注意", "物流单暂无结果" , { "好的" } )
		elseif (status == "1") then
			print("enter")
			local data = result["data"]
			local options = {
    			effect = "fade",
    			time = 800,
    			params = data
			}
			globalVars.origin = "queryPackage"
			composer.gotoScene( "showPackages", options )
		elseif (status == 2) then
			native.showAlert( "注意", "查询出现问题" , { "好的" } )
		end
	end
end

scene:addEventListener("create",scene)
scene:addEventListener("show",scene)
scene:addEventListener("hide",scene)
scene:addEventListener("destroy",scene)

return scene