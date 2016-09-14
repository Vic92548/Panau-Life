message = "Default message"
function RenderMessage()
	Render:DrawText(Vector3( -6550, 219, -3290 ), message, Color(255,255,255), 20)
end
Events:Subscribe("Render", RenderMessage)

function ClientFunction(sentMessage)
	message = sentMessage
end
-- Subscribe ClientFunction to the network event "Test".
Network:Subscribe("Test", ClientFunction)
