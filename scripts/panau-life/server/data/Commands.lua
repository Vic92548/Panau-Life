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

  if ArgsList[1] == "/tp" and ArgsList[2] ~= nil and ArgsList[3] ~= nil and ArgsList[4] ~= nil then
      args.player:Teleport(Vector3(tonumber(ArgsList[2]),tonumber(ArgsList[3]),tonumber(ArgsList[4])),Angle(0,0,0))
    return false
  end

  if ArgsList[1] == "/veh" and ArgsList[2] ~= nil then
    PanauLife.Database:execute([[
      INSERT
      INTO    vehicles (vehicle_owner, vehicle_posx, vehicle_posy, vehicle_posz, vehicle_model)
      VALUES  (:owner, :posx, :posy, :posz, :model)
    ]], {
      [":owner"] = args.player:GetSteamId().string,
      [":posx"] = args.player:GetPosition().x,
      [":posy"] = args.player:GetPosition().x,
      [":posz"] = args.player:GetPosition().x,
      [":model"] = tonumber(ArgsList[2])
    })
    return false
  end

end

Events:Subscribe("PlayerChat", ChatText)
