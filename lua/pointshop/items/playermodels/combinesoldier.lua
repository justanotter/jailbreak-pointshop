ITEM.Name = 'Combine Soldier'
ITEM.Price = 250
ITEM.Model = 'models/player/combine_soldier.mdl'
ITEM.Team = 2

function ITEM:OnEquip(ply, modifications)
	timer.Simple(1, function()
		ply._guardmodel = self.Model
		if ply:Team() == self.Team then
			ply:SetModel(self.Model)
		end 
	end)
end

function ITEM:OnHolster(ply)
	ply._guardmodel = nil
	if ply:Team() == self.Team then
		setmodel()
	end
end

function ITEM:PlayerSetModel(ply)
	ply._guardmodel = self.Model
	if ply:Team() == self.Team then
		ply:SetModel(self.Model)
	end
end

--copied from prisoners.lua
local prisonerModels = {

-- Black models (we add these a few times, so it increases the chance of a player being black, which makes the atmosphere of the game more "criminal")
	Model("models/player/Group01/female_03.mdl"),
	Model("models/player/Group01/female_05.mdl"),
	Model("models/player/Group01/male_01.mdl"),
	Model("models/player/Group01/male_03.mdl"),
	Model("models/player/Group01/female_03.mdl"),
	Model("models/player/Group01/female_05.mdl"),
	Model("models/player/Group01/male_01.mdl"),
	Model("models/player/Group01/male_03.mdl"),
	Model("models/player/Group01/female_03.mdl"),
	Model("models/player/Group01/female_05.mdl"),
	Model("models/player/Group01/male_01.mdl"),
	Model("models/player/Group01/male_03.mdl"),
	Model("models/player/Group01/female_03.mdl"),
	Model("models/player/Group01/female_05.mdl"),
	Model("models/player/Group01/male_01.mdl"),
	Model("models/player/Group01/male_03.mdl"),
	Model("models/player/Group01/female_03.mdl"),
	Model("models/player/Group01/female_05.mdl"),
	Model("models/player/Group01/male_01.mdl"),
	Model("models/player/Group01/male_03.mdl"),
	Model("models/player/Group01/female_03.mdl"),
	Model("models/player/Group01/female_05.mdl"),
	Model("models/player/Group01/male_01.mdl"),
	Model("models/player/Group01/male_03.mdl"),
	Model("models/player/Group01/female_03.mdl"),
	Model("models/player/Group01/female_05.mdl"),
	Model("models/player/Group01/male_01.mdl"),
	Model("models/player/Group01/male_03.mdl"),
	Model("models/player/Group01/female_03.mdl"),
	Model("models/player/Group01/female_05.mdl"),
	Model("models/player/Group01/male_01.mdl"),
	Model("models/player/Group01/male_03.mdl"),
	Model("models/player/Group01/female_03.mdl"),
	Model("models/player/Group01/female_05.mdl"),
	Model("models/player/Group01/male_01.mdl"),
	Model("models/player/Group01/male_03.mdl"),
	Model("models/player/Group01/female_03.mdl"),
	Model("models/player/Group01/female_05.mdl"),
	Model("models/player/Group01/male_01.mdl"),
	Model("models/player/Group01/male_03.mdl"),
	Model("models/player/Group01/female_03.mdl"),
	Model("models/player/Group01/female_05.mdl"),
	Model("models/player/Group01/male_01.mdl"),
	Model("models/player/Group01/male_03.mdl"),
	Model("models/player/Group01/female_03.mdl"),
	Model("models/player/Group01/female_05.mdl"),
	Model("models/player/Group01/male_01.mdl"),
	Model("models/player/Group01/male_03.mdl"),

-- Normal 'white' models
	Model("models/player/Group01/female_02.mdl"),
	Model("models/player/Group01/female_01.mdl"),
	Model("models/player/Group01/female_04.mdl"),
	Model("models/player/Group01/female_06.mdl"),
	Model("models/player/Group01/male_02.mdl"),
	Model("models/player/Group01/male_04.mdl"),
	Model("models/player/Group01/male_05.mdl"),
	Model("models/player/Group01/male_06.mdl"),
	Model("models/player/Group01/male_07.mdl"),
	Model("models/player/Group01/male_08.mdl"),
	Model("models/player/Group01/male_09.mdl"),
}
function setmodel()
	print(self.Player._guardmodel)
	if self.Player._guardmodel then
		self.Player:SetModel(self.Player._guardmodel)
	else
		self.Player:SetModel( string.lower(table.Random(prisonerModels)) )
	end
end