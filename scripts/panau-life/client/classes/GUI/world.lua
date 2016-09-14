message = "Default message"
function RenderMessage()
	Render:DrawText(Render.Size / 2, message, Color(255, 255, 255))
end
Events:Subscribe("Render", RenderMessage)

function ClientFunction(sentMessage)
	message = sentMessage
end
-- Subscribe ClientFunction to the network event "Test".
Network:Subscribe("Test", ClientFunction)
