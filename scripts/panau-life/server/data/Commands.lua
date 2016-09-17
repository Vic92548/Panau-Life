function ChatText(args)
  local ArgsList = args.text:split(" ")
  if args.text == "/p" then
      Chat:Send(args.player, "Position x :"..args.player:GetPosition().x.." / Position y : "..args.player:GetPosition().y.." / Position Z : "..args.player:GetPosition().z, Color(240,240,240))
    return false
  end

  if ArgsList[1] == "/build" then
      Chat:Send(args.player, "Position x :"..args.player:GetPosition().x.." / Position y : "..args.player:GetPosition().y.." / Position Z : "..args.player:GetPosition().z, Color(240,240,240))
    return false
  end

  if ArgsList[1] == "/model" and ArgsList[2] ~= nil then
      args.player:SetModelId(tonumber(ArgsList[2]))
    return false
  end
end

Events:Subscribe("PlayerChat", ChatText)
