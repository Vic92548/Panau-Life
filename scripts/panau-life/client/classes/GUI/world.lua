message = "Default message"

function DrawShadowedText( pos, text, colour, size, scale )
    if scale == nil then scale = 1.0 end
    if size == nil then size = TextSize.Default end

    local shadow_colour = Color( 0, 0, 0, colour.a )
    shadow_colour = shadow_colour * 0.4

    Render:DrawText( pos + Vector3( 1, 1, 2 ), text, shadow_colour, size, scale )
    Render:DrawText( pos, text, colour, size, scale )
end

BuildingsList = {}

function RenderMessage()
	local TextList = PanauGUI.WorldText:TextList()

	local x = 1
	while TextList[x] ~= nil do
		local Dist = Camera:GetPosition():Distance(TextList[x].Position)
		if Dist < TextList[x].Distance and Game:GetState() == GUIState.Game then
			local t = Transform3()
			t:Translate(TextList[x].Position)
			t:Rotate(Angle(Camera:GetAngle().yaw,math.rad(TextList[x].Rotation),0))
			Render:SetTransform(t)
			t:Scale(0.002)
			Render:SetTransform(t)

			local alpha = math.clamp((TextList[x].Distance-Dist)*5, 0, 255)

			Render:DrawText(Vector3(20,50,10), TextList[x].DisplayName, Color(0,0,0, alpha/2.5), TextList[x].FontSize)
			Render:DrawText(Vector3(0,30,0), TextList[x].DisplayName, Color(TextList[x].Color[1],TextList[x].Color[2],TextList[x].Color[3], alpha), TextList[x].FontSize)
		end
		x = x +1
	end

	for Index, Value in pairs( BuildingsList ) do
		local Dist = Camera:GetPosition():Distance(Vector3(tonumber(BuildingsList[Index].building_posx),tonumber(BuildingsList[Index].building_posy),tonumber(BuildingsList[Index].building_posz)))
		if Dist < 200 and Game:GetState() == GUIState.Game then
			local t = Transform3()
      		t:Translate(Vector3(tonumber(BuildingsList[Index].building_posx),tonumber(BuildingsList[Index].building_posy),tonumber(BuildingsList[Index].building_posz)))
      		t:Rotate(Angle(Camera:GetAngle().yaw,math.rad(180),0))
      		Render:SetTransform(t)
      		t:Scale(0.002)
      		Render:SetTransform(t)

      		local alpha = math.clamp((200-Dist)*5, 0, 255)

      		Render:DrawText(Vector3(20,-2480,10), string.gsub(tostring(BuildingsList[Index].building_name),"_"," "), Color(0,0,0, alpha/2.5), 300)
			Render:DrawText(Vector3(0,-2500,0), string.gsub(tostring(BuildingsList[Index].building_name),"_"," "), Color(tonumber(BuildingsList[Index].building_colorr),tonumber(BuildingsList[Index].building_colorg),tonumber(BuildingsList[Index].building_colorb), alpha), 300)
		end
	end

end
Events:Subscribe("Render", RenderMessage)

function ClientFunction(sentMessage)
	message = sentMessage
end
-- Subscribe ClientFunction to the network event "Test".
Network:Subscribe("Test", ClientFunction)

function ClientBuildings(sentMessage)
	BuildingsList = sentMessage
	--print("Buldings arrived"..tostring(sentMessage[1].building_posy))
end
Network:Subscribe("Buldings", ClientBuildings)
