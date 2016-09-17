class("WorldText")


	function WorldText:__init() end

	function WorldText:TextList()
		local DisplayTextList = {}

		-- DEBUT TEXT
		local UNIQUE_NAME = {}
		table.insert(DisplayTextList, UNIQUE_NAME)
		UNIQUE_NAME.Position = Vector3(250,50,10)
		UNIQUE_NAME.Distance = 100
		local Dist = Camera:GetPosition():Distance(UNIQUE_NAME.Position)
		UNIQUE_NAME.DisplayName = "Bienvenue sur Panau"
		UNIQUE_NAME.alpha = math.clamp((Dist - UNIQUE_NAME.Distance)*5, 0, 255)
		UNIQUE_NAME.Color = Color(0,0,0, UNIQUE_NAME.alpha/2.5)
		UNIQUE_NAME.FontSize = 300
		UNIQUE_NAME.Rotation = 180

		local text1 = {}
		table.insert(DisplayTextList, text1)
		text1.Position = Vector3(230,30,0)
		text1.Distance = 100
		local Dist = Camera:GetPosition():Distance(text1.Position)
		text1.DisplayName = "Bienvenue sur Panau"
		text1.alpha = math.clamp((Dist - text1.Distance)*5, 0, 255)
		text1.Color = Color(255,255,255, text1.alpha)
		text1.FontSize = 300
		text1.Rotation = 180


		-- Fin
		return DisplayTextList
	end

PanauGUI.WorldText = WorldText()
