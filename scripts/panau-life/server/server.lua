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
   -- args.player:Kick("You are not whitelisted to this server.")
  end

end

Events:Subscribe("PlayerAuthenticate", PlayerGetAcces)

function ServerFunction(args)
	-- Call the network event "Test" for this player. The argument is a string.
	Network:Send(args.player, "Test", "Hello, client!")
end
Events:Subscribe("ClientModuleLoad", ServerFunction)

Network:Subscribe("ClientSendPlayerItems", function(items, ClientPlayer)
  Users[ClientPlayer:GetSteamId().string].user_items = items
end)

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
        Users[steamid].user_hunger = Users[steamid].user_hunger - 0.0004629
        Users[steamid].user_thirst = Users[steamid].user_thirst - 0.0006944
        Network:Send(player, "UpdateUser", Users[steamid])
      end
    end
    Tick = 0
  end
  Tick = Tick + 1
end

Events:Subscribe("PostTick", UpdatePlayers)


Network:Subscribe("ClientBuyFoodInRestaurant",function (sentMessage, player)
  local steamid = player:GetSteamId().string
  Users[steamid].user_hunger = Users[steamid].user_hunger + PanauLife.Config.Restaurant[tonumber(sentMessage)].HungerValue
  Users[steamid].user_thirst = Users[steamid].user_thirst + PanauLife.Config.Restaurant[tonumber(sentMessage)].ThirstValue
  player:SetMoney(player:GetMoney() - PanauLife.Config.Restaurant[tonumber(sentMessage)].Prix)
end)