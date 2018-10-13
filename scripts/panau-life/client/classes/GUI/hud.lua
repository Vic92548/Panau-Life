class("HUD")

function HUD:__init()
	self.HungerBar = ProgressBar.Create("HungerBar")
	self.HungerBar:SetVisible(true)
	self.HungerBar:SetValue(1)
	self.HungerBar:SetSizeRel( Vector2( 0.25, 0.04 ) )
    self.HungerBar:SetPositionRel( Vector2( 0.25, 0.96 ) )

    self.ThirstBar = ProgressBar.Create("ThirstBar")
	self.ThirstBar:SetVisible(true)
	self.ThirstBar:SetValue(1)
	self.ThirstBar:SetSizeRel( Vector2( 0.25, 0.04 ) )
    self.ThirstBar:SetPositionRel( Vector2( 0, 0.96 ) )

    self.ExpBar = ProgressBar.Create("ExpBar")
	self.ExpBar:SetVisible(true)
	self.ExpBar:SetValue(0)
	self.ExpBar:SetSizeRel( Vector2( 0.25, 0.04 ) )
    self.ExpBar:SetPositionRel( Vector2( 0.50, 0.96 ) )

    Events:Subscribe( "Render", self, self.Render )
end

function HUD:Render()
	if HudLoaded then
		self.HungerBar:SetValue(tonumber(User.user_hunger))
		if tonumber(User.user_hunger) > 0.8 then
			self.HungerBar:SetText("Aucune envie de manger")
		elseif tonumber(User.user_hunger) > 0.4 then
			self.HungerBar:SetText("Légère faim")
		else
			self.HungerBar:SetText("Mort de faim")
		end

		self.ThirstBar:SetValue(tonumber(User.user_thirst))
		if tonumber(User.user_thirst) > 0.8 then
			self.ThirstBar:SetText("Aucune envie de boire")
		elseif tonumber(User.user_thirst) > 0.4 then
			self.ThirstBar:SetText("Légère soif")
		else
			self.ThirstBar:SetText("Mort de soif")
		end
		self.ExpBar:SetText("0xp/500xp")
		HudLoaded = false
	end
end

PanauGUI.HUD = HUD()