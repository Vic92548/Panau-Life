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

	local TextList = PanauGUI.WorldText:TextList()

	local x = 1
	while TextList[x] ~= nil do
		local Dist = Camera:GetPosition():Distance(TextList[x].Position)
		if Dist < TextList[x].Distance and Game:GetState() == GUIState.Game then
			local t = Transform3()
			t:Translate(Vector3(0, 0, 0))
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
