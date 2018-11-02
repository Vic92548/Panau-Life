--local http = require("socket.http")
function PlayerGetAcces(args)
	print(args.player:GetName().." has been authenticated by Steam")



  local data = PanauLife.Database:query([[
    SELECT  user_steamid
    FROM    whitelisted
    WHERE   user_steamid = :steamid
    LIMIT   1
  ]], {
    [":steamid"] = args.player:GetSteamId().string
  })

  if not data then
    --args.player:Kick("You are not whitelisted to this server.")
  end

end

Events:Subscribe("PlayerAuthenticate", PlayerGetAcces)

function ServerFunction(args)
	-- Call the network event "Test" for this player. The argument is a string.
	Network:Send(args.player, "Test", "Hello, client!")
end
Events:Subscribe("ClientModuleLoad", ServerFunction)

Network:Subscribe("ClientDestroyedItem", function(item_name, ClientPlayer)
  DestroyPlayerItem(item_name,ClientPlayer)
end)

function DestroyPlayerItem(item_name,ClientPlayer)
  local JoinedItems = {}
  local new_items = {}
  local old_items = Users[ClientPlayer:GetSteamId().string].user_items:split("/")
  for i = 1,#old_items do
    local UnderItems = old_items[i]:split("*")
    if UnderItems[1] == item_name then
      new_items[UnderItems[1]] = tonumber(UnderItems[2]) - 1
      find = true
    else
      new_items[UnderItems[1]] = tonumber(UnderItems[2])
    end
  end
  local i = 0
  for k,v in pairs(new_items) do
    i = i + 1
    JoinedItems[i] = table.concat({k,new_items[k]}, "*")
  end
  Users[ClientPlayer:GetSteamId().string].user_items = table.concat(JoinedItems, "/")
end

local Tick = 0
function UpdatePlayers()
  if Tick >= 100 then
    for player in Server:GetPlayers() do
      local steamid = player:GetSteamId().string
      if Users[steamid] != nil then
        if Users[steamid].user_hunger <= 0 then
          player:Damage(1000)
          Users[steamid].user_hunger = 1
          Users[steamid].user_thirst = 1
        elseif Users[steamid].user_thirst <= 0 then
          player:Damage(1000)
          Users[steamid].user_hunger = 1
          Users[steamid].user_thirst = 1
        elseif Users[steamid].user_hunger >= 1 then
          Users[steamid].user_hunger = 1
        elseif Users[steamid].user_thirst >= 1 then
          Users[steamid].user_thirst = 1
        end
        Users[steamid].user_hunger = Users[steamid].user_hunger - 0.00004629
        Users[steamid].user_thirst = Users[steamid].user_thirst - 0.00006944
        Network:Send(player, "UpdateUser", Users[steamid])
      end
    end
    Tick = 0
  end
  Tick = Tick + 1
end

Events:Subscribe("PostTick", UpdatePlayers)


Network:Subscribe("ClientUseItem",function (sentMessage, player)
  local steamid = player:GetSteamId().string
  local ItemConfig = PanauLife.Config.UsableItems[sentMessage]
  Users[steamid].user_hunger = Users[steamid].user_hunger + ItemConfig.HungerValue
  Users[steamid].user_thirst = Users[steamid].user_thirst + ItemConfig.ThirstValue
  DestroyPlayerItem(sentMessage,player)
end)

Network:Subscribe("ClientBuyFoodInRestaurant",function (sentMessage, player)
  local steamid = player:GetSteamId().string
  Users[steamid].user_hunger = Users[steamid].user_hunger + PanauLife.Config.Restaurant_Items[sentMessage.Restaurant][sentMessage.Id].HungerValue
  Users[steamid].user_thirst = Users[steamid].user_thirst + PanauLife.Config.Restaurant_Items[sentMessage.Restaurant][sentMessage.Id].ThirstValue
  player:SetMoney(player:GetMoney() - PanauLife.Config.Restaurant_Items[sentMessage.Restaurant][sentMessage.Id].Prix)
end)

Network:Subscribe("ClientBuyColorInGarage",function (sentMessage, player)
  local colors = PanauLife.Config.Garage_Items[sentMessage.Garage][sentMessage.Id]
  player:GetVehicle():SetColors( Color(colors.Color1.r,colors.Color1.g,colors.Color1.b), Color(colors.Color2.r,colors.Color2.g,colors.Color2.b) )
  player:SetMoney(player:GetMoney() - PanauLife.Config.Garage_Items[sentMessage.Garage][sentMessage.Id].Prix)
end)

Network:Subscribe("ClientBuyCloth",function (sentMessage, player)
  player:SetModelId(PanauLife.Config.Cloth_Items[sentMessage.Garage][sentMessage.Id].Model)
  player:SetMoney(player:GetMoney() - PanauLife.Config.Cloth_Items[sentMessage.Garage][sentMessage.Id].Prix)
end)

Network:Subscribe("ClientGather",function (sentMessage, player)
  local steamid = player:GetSteamId().string
  local items = Users[steamid].user_items:split("/")
  local new_items = {}
  local find = false
  for i = 1,#items do
    local UnderItems = items[i]:split("*")
    if UnderItems[1] == sentMessage then
      new_items[UnderItems[1]] = tonumber(UnderItems[2]) + 1
      find = true
    else
      new_items[UnderItems[1]] = tonumber(UnderItems[2])
    end
  end
  if not find then
    new_items[sentMessage] = 1
  end
  local JoinedItems = {}
  local i = 0
  for k,v in pairs(new_items) do
    i = i + 1
    JoinedItems[i] = table.concat({k,new_items[k]}, "*")
  end
  Users[steamid].user_items = table.concat(JoinedItems, "/")
  Network:Send(player, "UpdateUser", Users[steamid])
end)

Network:Subscribe("ClientBuyCarInCarDealer",function (sentMessage, player)
  local car = PanauLife.Config.CarDealer_Items[sentMessage.CarDealer][sentMessage.Id]
  AddVeh(car.Model, player)
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
  player:SetMoney(player:GetMoney() - PanauLife.Config.CarDealer_Items[sentMessage.CarDealer][sentMessage.Id].Prix)
end)


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
    [":r"] = 180,
    [":g"] = 180,
    [":b"] = 180,
    [":r2"] = 5,
    [":g2"] = 5,
    [":b2"] = 5,
    [":yaw"] = 0,
    [":pitch"] = 0,
    [":roll"] = 0,
    [":items"] = "",
    [":locked"] = "true",
    [":capacity"] = tonumber(model)
  })
end