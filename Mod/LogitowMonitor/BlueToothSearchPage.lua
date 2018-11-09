--[[
NPL.load("(gl)Mod/LogitowMonitor/BlueToothSearchPage.lua");
local BlueToothSearchPage = commonlib.gettable("MyCompany.Aries.Game.GUI.BlueToothSearchPage");
]]

local BlueToothSearchPage = commonlib.gettable("MyCompany.Aries.Game.GUI.BlueToothSearchPage");
local LogitowMonitor = commonlib.gettable("Mod.LogitowMonitor.LogitowMonitor");

local lesson_worlds = {
	{
		displayname = L"创意几何", 
		title = L"进入“创意几何”世界", 
		icon = "Mod/LogitowMonitor/textures/icon_world_min.png",
		tooltip = L"",
	},
	{
		displayname = L"更多应用", 
		title = L"查看更多应用网页", 
		icon = "Mod/LogitowMonitor/textures/icon_more_min.png",
		tooltip = L"",
	},
	{
		displayname = L"客户支持", 
		title = L"查看客户支持网页", 
		icon = "Mod/LogitowMonitor/textures/icon_sup_min.png",
		tooltip = L"",
	},
};

function BlueToothSearchPage.LessonWorldsDs(index)
	if(not index) then
		return #lesson_worlds
	else
		return BlueToothSearchPage.GetLessonByIndex(index);
	end
end

function BlueToothSearchPage.GetLessonByIndex(index)
	return lesson_worlds[index];
end

function BlueToothSearchPage.GetTootipByIndex(index)
	--return "page://script/apps/Aries/Creator/Game/Login/ParaWorldLessonTooltip.html?index="..tostring(index);
	return L"index:" .. index;
end

function BlueToothSearchPage.OnClickWorld(index)
	if(index == 1)then
		GameLogic.RunCommand("/loadworld https://git.keepwork.com/gitlab_rls_hetter1/world_base32_mn4wu2brge4a/repository/archive.zip");
	elseif(index == 2) then
		GameLogic.RunCommand("/open https://keepwork.com/official/bluetooth/index");
	elseif(index == 3) then
		GameLogic.RunCommand("/open https://keepwork.com/official/bluetooth/support");
	end
end


function BlueToothSearchPage.OnInit(isNarrow)
	BlueToothSearchPage.isNarrowMode = isNarrow;
	BlueToothSearchPage.page = document:GetPageCtrl();
end

function BlueToothSearchPage.OnClose()
	if BlueToothSearchPage.page then
		BlueToothSearchPage.page:CloseWindow();
		BlueToothSearchPage.page = nil;
	end	
end

function BlueToothSearchPage._ShowPageWide()
	local params = {
			url = "Mod/LogitowMonitor/BlueToothSearchPage_wide.html", 
			name = "PC.BlueToothSearchPage_wide", 
			isShowTitleBar = false,
			DestroyOnClose = true,
			bToggleShowHide=false, 
			style = CommonCtrl.WindowFrame.ContainerStyle,
			allowDrag = false,
			enable_esc_key = false,
			bShow = true,
			--isTopLevel = true,
			zorder = 999,
			click_through = false, 
			cancelShowAnimation = true,
			directPosition = true,
				align = "_fi",
				x = 0,
				y = 0,
				width = 0,
				height = 0,
			};
		
	System.App.Commands.Call("File.MCMLWindowFrame", params);
end


function BlueToothSearchPage._ShowPageNarrow()
	local params = {
			url = "Mod/LogitowMonitor/BlueToothSearchPage_narrow.html", 
			name = "PC.BlueToothSearchPage_narrow", 
			isShowTitleBar = false,
			DestroyOnClose = true,
			bToggleShowHide=false, 
			style = CommonCtrl.WindowFrame.ContainerStyle,
			allowDrag = true,
			enable_esc_key = false,
			bShow = true,
			--isTopLevel = true,
			zorder = 999,
			click_through = false, 
			cancelShowAnimation = true,
			directPosition = true,
				align = "_rt",
				x = -200,
				y = 0,
				width = 200,
				height = 200,
			};
		
	System.App.Commands.Call("File.MCMLWindowFrame", params);
end

BlueToothSearchPage.isNarrowMode = false;
function BlueToothSearchPage.OnShowPage()
	if not BlueToothSearchPage.page then
		if(BlueToothSearchPage.isNarrowMode) then
			BlueToothSearchPage._ShowPageNarrow()
		else	
			BlueToothSearchPage._ShowPageWide()
		end
	end	
	BlueToothSearchPage.SetBlueTips();	
end	

function BlueToothSearchPage.ChangeNarrowWide()
    BlueToothSearchPage.isNarrowMode = not BlueToothSearchPage.isNarrowMode;
	BlueToothSearchPage.OnClose();
	BlueToothSearchPage.OnShowPage();
end

function BlueToothSearchPage.SetBlueTips()
	local isBlueConnect = LogitowMonitor.isConnect;
	if BlueToothSearchPage.page then
		if isBlueConnect then
			if BlueToothSearchPage.searchTimer then
				BlueToothSearchPage.searchTimer:Change();
				BlueToothSearchPage.searchTimer = nil;
			end	
			
			
			local blv = math.floor(LogitowMonitor.blueBattery or 0);
			
			BlueToothSearchPage.page:SetValue("txt_battery", string.format("%d%%", blv));	
			BlueToothSearchPage.page:SetValue("progressbar_battery", blv);
			local mcmlNode = BlueToothSearchPage.page:GetNode("lense");
			mcmlNode:SetAttribute("visible", "false");
		else	
			BlueToothSearchPage.page:SetValue("txt_battery", "--");
			BlueToothSearchPage.page:SetValue("progressbar_battery", 0);
			--local mcmlNode = BlueToothSearchPage.page:GetNode("lense");
			--mcmlNode:SetAttribute("visible", "true");
			
			BlueToothSearchPage.doSearchAnim();
		end	
		BlueToothSearchPage.page:Refresh(0.01);
	end
end	

function BlueToothSearchPage.RefreshOnLoadWorldFinshed()
	if BlueToothSearchPage.page then
		BlueToothSearchPage.OnClose();
		BlueToothSearchPage.OnShowPage();
	else
		BlueToothSearchPage.OnShowPage();
	end
end

function BlueToothSearchPage.doSearchAnim()
	if(not BlueToothSearchPage.searchTimer) then
		if LogitowMonitor.isConnect then
			return;
		end
	
		BlueToothSearchPage.searchTimer = commonlib.Timer:new({callbackFunc = function(timer)
			if BlueToothSearchPage.page then
				local mcmlNode = BlueToothSearchPage.page:GetNode("lense");
				if mcmlNode then
					local visible = mcmlNode:GetAttributeWithCode("visible", nil, true);
					visible = tostring(visible);			
					if(visible and visible == "false")then
						mcmlNode:SetAttribute("visible", "true");
					else
						mcmlNode:SetAttribute("visible", "false");
					end	
					BlueToothSearchPage.page:Refresh(0.01);
				end
			end
		end})
		
		BlueToothSearchPage.searchTimer:Change(500, 500);
	end
end