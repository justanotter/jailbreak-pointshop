surface.CreateFont('PS_Heading', { font = 'coolvetica', size = 64 })
surface.CreateFont('PS_Heading2', { font = 'coolvetica', size = 24 })
surface.CreateFont('PS_Heading3', { font = 'coolvetica', size = 19 })

local PANEL = {}

function PANEL:Init()
	self:SetSize(1024, 768)
	self:SetPos((ScrW() / 2) - (self:GetWide() / 2), (ScrH() / 2) - (self:GetTall() / 2))
	
	-- close button
	local closeButton = vgui.Create('DButton', self)
	closeButton:SetFont('marlett')
	closeButton:SetText('r')
	closeButton:SetColor(Color(255, 255, 255))
	closeButton:SetSize(15, 15)
	closeButton:SetDrawBackground(false)
	closeButton:SetPos(self:GetWide() - 25, 10)
	closeButton.DoClick = function()
		PS:ToggleMenu()
	end
	
	local tabs = vgui.Create('DPropertySheet', self)
	
	tabs:DockMargin(10, 80, 10, 10)
	tabs:Dock(FILL)
	
	tabs:SetSize(self:GetWide() - 60, self:GetTall() - 150)
	tabs:SetPos((self:GetWide() / 2) - (tabs:GetWide() / 2), 120)
	
	-- items
	for _, CATEGORY in pairs(PS.Categories) do
		local ShopCategoryTab = vgui.Create('DPanel')
		
		local DScrollPanel = vgui.Create('DScrollPanel', ShopCategoryTab)
		DScrollPanel:Dock(FILL)
		
		local ShopCategoryTabLayout = vgui.Create('DIconLayout', DScrollPanel)
		ShopCategoryTabLayout:Dock(FILL)
		ShopCategoryTabLayout:SetBorder(10)
		ShopCategoryTabLayout:SetSpaceX(10)
		ShopCategoryTabLayout:SetSpaceY(10)
		
		DScrollPanel:AddItem(ShopCategoryTabLayout)
		
		for _, ITEM in pairs(PS.Items) do
			
			if ITEM.Category == CATEGORY.Name then
				local model = vgui.Create('DPointShopItem')
				model:SetData(ITEM)
				model:SetSize(126, 126)
				
				ShopCategoryTabLayout:Add(model)
			end
		end
		
		tabs:AddSheet(CATEGORY.Name, ShopCategoryTab, 'icon16/' .. CATEGORY.Icon .. '.png', false, false, '')
	end
	
	if not LocalPlayer():IsAdmin() then return end
	
	-- admin tab
	local AdminTab = vgui.Create('DPanel')
	
	local ClientsList = vgui.Create('DListView', AdminTab)
	ClientsList:DockMargin(10, 10, 10, 10)
	ClientsList:Dock(FILL)
	
	ClientsList:SetMultiSelect(false)
	ClientsList:AddColumn('ID'):SetFixedWidth(100)
	ClientsList:AddColumn('Name')
	ClientsList:AddColumn('Points'):SetFixedWidth(60)
	ClientsList:AddColumn('Items'):SetFixedWidth(60)
	
	ClientsList.OnClickLine = function(parent, line, selected)
		local ply = player.GetByUniqueID(line:GetValue(1))
		
		local menu = DermaMenu()
		
		menu:AddOption('Set Points...', function()
			Derma_StringRequest(
				"Set Points for " .. ply:GetName(),
				"Set points to...",
				"",
				function(str)
					if not str or not tonumber(str) then return end
					
					net.Start('PS_SetPoints')
						net.WriteEntity(ply)
						net.WriteInt(tonumber(str), 32)
					net.SendToServer()
				end
			)
		end)
		
		menu:AddOption('Give Points...', function()
			Derma_StringRequest(
				"Give Points to " .. ply:GetName(),
				"Give points...",
				"",
				function(str)
					if not str or not tonumber(str) then return end
					
					net.Start('PS_GivePoints')
						net.WriteEntity(ply)
						net.WriteInt(tonumber(str), 32)
					net.SendToServer()
				end
			)
		end)
		
		menu:AddOption('Take Points...', function()
			Derma_StringRequest(
				"Take Points from " .. ply:GetName(),
				"Take points...",
				"",
				function(str)
					if not str or not tonumber(str) then return end
					
					net.Start('PS_TakePoints')
						net.WriteEntity(ply)
						net.WriteInt(tonumber(str), 32)
					net.SendToServer()
				end
			)
		end)
		
		menu:Open()
	end
	
	self.ClientsList = ClientsList
	
	tabs:AddSheet('Admin', AdminTab, 'icon16/shield.png', false, false, '')
end

function PANEL:Think()
	if self.ClientsList then
		local lines = self.ClientsList:GetLines()
		
		for _, ply in pairs(player.GetAll()) do
			local found = false
			
			for _, line in pairs(lines) do
				if line.Player == ply then
					found = true
				end
			end
			
			if not found then
				self.ClientsList:AddLine(ply:UniqueID(), ply:GetName(), ply:PS_GetPoints(), table.Count(ply:PS_GetItems())).Player = ply
			end
		end
		
		for i, line in pairs(lines) do
			if IsValid(line.Player) then
				local ply = line.Player
				
				line:SetValue(2, ply:GetName())
				line:SetValue(3, ply:PS_GetPoints())
				line:SetValue(4, table.Count(ply:PS_GetItems()))
			else
				self.ClientsList:RemoveLine(i)
			end
		end
	end
end

function PANEL:Paint()
	Derma_DrawBackgroundBlur(self)
	
	draw.RoundedBox(10, 0, 0, self:GetWide(), self:GetTall(), Color(0, 0, 0, 150))
	
	draw.SimpleText('PointShop', 'PS_Heading', 20, 10, color_white)
	draw.SimpleText('by _Undefined', 'PS_Heading2', 275, 50, color_white)
	draw.SimpleText('You have ' .. LocalPlayer():PS_GetPoints() .. ' points', 'PS_Heading3', self:GetWide() - 10, 60, color_white, TEXT_ALIGN_RIGHT, TEXT_ALIGN_BOTTOM)
end

vgui.Register('DPointShopMenu', PANEL)