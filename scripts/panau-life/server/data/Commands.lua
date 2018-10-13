function ChatText(args)
  local ArgsList = args.text:split(" ")
  if args.text == "/p" then
      Chat:Send(args.player, "Position x :"..args.player:GetPosition().x.." / Position y : "..args.player:GetPosition().y.." / Position Z : "..args.player:GetPosition().z, Color(240,240,240))
    return false
  end

  if args.text == "/kill" then
      args.player:Damage(1000)
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

  if ArgsList[1] == "/color" then
      args.player:GetVehicle():SetColors( Color(tonumber(ArgsList[2]),tonumber(ArgsList[3]),tonumber(ArgsList[4])), Color(tonumber(ArgsList[5]),tonumber(ArgsList[6]),tonumber(ArgsList[7])) )
    return false
  end

  if ArgsList[1] == "/veh" and ArgsList[2] ~= nil then
    AddVeh(ArgsList[2], args.player)
    local data = PanauLife.Database:query([[
      SELECT  seq
      FROM    sqlite_sequence
      WHERE   name = :nm
    ]], {
      [":nm"] = "vehicles"
    })
    PanauLife.Vehicles:SetData(data.seq,PanauLife.Database:query([[
      SELECT  *
      FROM    vehicles
      WHERE   vehicle_id = :id
    ]], {
      [":id"] = data.seq
    }))
    PanauLife.Vehicles:Create(data.seq)
    return false
  end

  if ArgsList[1] == "/spawn" and ArgsList[2] ~= nil then
    local obj = Vehicle.Create(tonumber(ArgsList[2]), args.player:GetPosition(), Angle(0, 0, 0))
    Chat:Send(args.player, "Véhicule "..obj:GetId().." créé", Color(240,240,240))
    return false
  end

  if ArgsList[1] == "/build" and ArgsList[2] ~= nil and ArgsList[3] ~= nil and ArgsList[4] ~= nil and ArgsList[5] ~= nil and ArgsList[6] ~= nil and ArgsList[7] ~= nil and ArgsList[8] ~= nil then
    local data = {}
    data.building_name = ArgsList[2]
    data.building_type = ArgsList[3]
    data.building_posx = args.player:GetPosition().x
    data.building_posy = args.player:GetPosition().y
    data.building_posz = args.player:GetPosition().z
    data.building_radius = tonumber(ArgsList[4])
    data.building_state = 2
    data.building_height = tonumber(ArgsList[5])
    data.building_colorr = tonumber(ArgsList[6])
    data.building_colorg = tonumber(ArgsList[7])
    data.building_colorb = tonumber(ArgsList[8])
    PanauLife.Build:CreateBuilding(data)
    return false
  end

end

Events:Subscribe("PlayerChat", ChatText)

function AddVeh(model,player)
  PanauLife.Database:execute([[
    INSERT
    INTO    vehicles (vehicle_owner, vehicle_posx, vehicle_posy, vehicle_posz, vehicle_model, vehicle_colorr, vehicle_colorg, vehicle_colorb, vehicle_colorr2, vehicle_colorg2, vehicle_colorb2, vehicle_yaw, vehicle_pitch, vehicle_roll, vehicle_items, vehicle_locked, vehicle_capacity)
    VALUES  (:owner, :posx, :posy, :posz, :model, :r, :g, :b, :r2, :g2, :b2, :yaw, :pitch, :roll, :items, :locked, :capacity); SELECT last_insert_rowid() FROM vehicles
  ]], {
    [":owner"] = player:GetSteamId().string,
    [":posx"] = player:GetPosition().x,
    [":posy"] = player:GetPosition().y,
    [":posz"] = player:GetPosition().z,
    [":model"] = tonumber(model),
    [":r"] = 255,
    [":g"] = 255,
    [":b"] = 220,
    [":r2"] = 150,
    [":g2"] = 255,
    [":b2"] = 150,
    [":yaw"] = 0,
    [":pitch"] = 0,
    [":roll"] = 0,
    [":items"] = "",
    [":locked"] = "true",
    [":capacity"] = tonumber(model)
  })
end

function PlayerSuicide(sentMessage, player)
  player:Damage(1000)
end

Network:Subscribe("PlayerSuicide", PlayerSuicide)

function SendPlayerUpdate(sentMessage, player)
  Network:Send(player, "UpdateUser", player.data)
end

Network:Subscribe("NeedPlayerUpdate",SendPlayerUpdate)