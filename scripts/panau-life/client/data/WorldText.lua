class("WorldText")


	function WorldText:__init() end

	function WorldText:TextList()
		local DisplayTextList = {}

		-- DEBUT TEXT
		--[[local UNIQUE_NAME = {}
		table.insert(DisplayTextList, UNIQUE_NAME)
		UNIQUE_NAME.Position = Vector3(250,50,10)
		UNIQUE_NAME.Distance = 100
		local Dist = Camera:GetPosition():Distance(UNIQUE_NAME.Position)
		UNIQUE_NAME.DisplayName = "Bienvenue sur Panau"
		UNIQUE_NAME.alpha = math.clamp((Dist - UNIQUE_NAME.Distance)*5, 0, 255)
		UNIQUE_NAME.Color = Color(0,0,0, 255/2.5)
		UNIQUE_NAME.FontSize = 300
		UNIQUE_NAME.Rotation = 180]]

		local text1 = {}
		table.insert(DisplayTextList, text1)
		text1.Position = Vector3(7752.1, 210, 3751.3)
		text1.Distance = 100
		text1.DisplayName = "Bienvenue sur Panau"
		text1.Color = { 255, 0, 0}
		text1.FontSize = 300
		text1.Rotation = 180

		local text2 = {}
		table.insert(DisplayTextList, text2)
		text2.Position = Vector3(7769.9, 209, 3783)
		text2.Distance = 45
		text2.DisplayName = "Chez Bernard - Restaurant"
		text2.Color = { 255, 255, 0}
		text2.FontSize = 300
		text2.Rotation = 180


		-- Fin
		return DisplayTextList
	end

PanauGUI.WorldText = WorldText()
