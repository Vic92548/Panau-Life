message = "Default message"

function DrawShadowedText( pos, text, colour, size, scale )
    if scale == nil then scale = 1.0 end
    if size == nil then size = TextSize.Default end

    local shadow_colour = Color( 0, 0, 0, colour.a )
    shadow_colour = shadow_colour * 0.4

    Render:DrawText( pos + Vector3( 1, 1, 2 ), text, shadow_colour, size, scale )
    Render:DrawText( pos, text, colour, size, scale )
end

function RenderMessage()
	
		--[[local distToSpawn = Camera:GetPosition():Distance(Vector3(7772.2, 201, 3759.5))
	if distToSpawn < 100 and Game:GetState() == GUIState.Game then
		
		---------- Welcome message ----------
		local t = Transform3()
		t:Translate(Vector3(7752.1, 205, 3751.3))
		t:Rotate(Angle(Camera:GetAngle().yaw+0.6,math.rad(180),0))
		Render:SetTransform(t)
		t:Scale(0.002)
		Render:SetTransform(t)
		
		local alpha = math.clamp((100-distToSpawn)*5, 0, 255)
		
		Render:DrawText(Vector3(250,50,10), "Welcome to", Color(0,0,0, alpha/2.5), 300)
		Render:DrawText(Vector3(230,30,0), "Welcome to", Color(255,255,255, alpha), 300)
		Render:DrawText(Vector3(300,320,10), "Panau-Life", Color(0,0,0, alpha/2.5), 300)
		Render:DrawText(Vector3(280,300,0), "Panau-Life", Color(255,127,0, alpha), 300)
		Render:DrawText(Vector3(300,590,10), "Server!", Color(0,0,0, alpha/2.5), 300)
		Render:DrawText(Vector3(280,570,0), "Server!", Color(255,255,255, alpha), 300)
		
		---------- Player list ----------
		t = Transform3()
		t:Translate(Vector3(7765.4, 205, 3735.8))
		t:Rotate(Angle(Camera:GetAngle().yaw-0.6,math.rad(180),math.rad(90)))
		t:Scale(0.002)
		
		Render:SetTransform(t)
		Render:DrawText(Vector3(-20,-430,10), "Current Players", Color(0,0,0, alpha/2.5), 300)
		Render:DrawText(Vector3(0,-450,0), "Current Players", Color(255,127,0, alpha), 300)
		
		t:Rotate(Angle(0,0,math.rad(90)))
		Render:SetTransform(t)
	end]]

	local TextList = PanauGUI.WorldText:TextList()

	local x = 1
	while TextList[x] ~= nil do
		local Dist = Camera:GetPosition():Distance(Vector3(7772.2, 201, 3759.5))
		if Dist < TextList[x].Distance and Game:GetState() == GUIState.Game then
			local t = Transform3()
			t:Translate(Vector3(7752.1, 205, 3751.3))
			t:Rotate(Angle(Camera:GetAngle().yaw+0.6,math.rad(TextList[x].Rotation),0))
			Render:SetTransform(t)
			t:Scale(0.002)
			Render:SetTransform(t)

			Render:DrawText(TextList[x].Position, TextList[x].DisplayName, TextList[x].Color, TextList[x].FontSize)
		end
		x = x +1
	end

end
Events:Subscribe("Render", RenderMessage)

function ClientFunction(sentMessage)
	message = sentMessage
end
-- Subscribe ClientFunction to the network event "Test".
Network:Subscribe("Test", ClientFunction)
