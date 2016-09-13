class("PanauLife_User")

function PanauLife_User:__init()
  self.users = {}

  Events:Subscribe("ModuleLoad", self, self.Load)
  Events:Subscribe("ModuleUnload", self, self.Unload)
  Events:Subscribe("PlayerAuthenticate", self, self.Join)
  Events:Subscribe("PlayerQuit", self, self.Leave)
end

function PanauLife_User:Load()
  for player in Server:GetPlayers() do
    self.users[player:GetSteamId().string] = User(player)
  end
end

function PanauLife_User:Unload()
  for player in Server:GetPlayers() do
    self:GetUser(player):SaveData()
    self:RemoveUser(player)
  end
end

function PanauLife_User:Join(a)
  self.users[a.player:GetSteamId().string] = User(a.player)
end

function PanauLife_User:Leave(a)
  self:GetUser(a.player):SaveData()
  self:RemoveUser(a.player)
end

function PanauLife_User:GetUser(player)
  return self.users[player:GetSteamId().string]
end

function PanauLife_User:RemoveUser(player)
  self.users[player:GetSteamId().string] = nil
end

PanauLife.User = PanauLife_User()






class("User")

function User:__init(player)
  self.player = player

  local data = PanauLife.Database:query([[
    SELECT  user_steamid
    FROM    whitelisted
    WHERE   user_steamid = :steamid
    LIMIT   1
  ]], {
    [":steamid"] = self.player:GetSteamId().string
  })

  if not data then
    self.player:Kick("Serveur réservé aux développeurs de PanaoLife !")
  end


  self:login()

  Events:Subscribe("PlayerChat", self, self.Chat)
end

function User:Apply(position, angle, health, money)

end

function User:LoadData()
  local data = PanauLife.Database:query([[
    SELECT  user_group, user_posx, user_posy, user_posz, user_health, user_money, user_model, user_items
    FROM    ]]..PanauLife.Config.sql.prefix..PanauLife.Config.sql.users..[[
    WHERE   user_steamid = :steamid
    LIMIT   1
  ]], {
    [":steamid"] = self.player:GetSteamId().string
  })

  if not data then
    return false
  end


  Inventory = lines(data.user_items)
  print(Inventory[1])
  self.player:ClearInventory()
  self.player:SetPosition(Vector3(data.user_posx, data.user_posy, data.user_posz))
  self.player:SetHealth(data.user_health)
  self.player:SetMoney(data.user_money)
  self.player:SetModelId(data.user_model)

  return true
end

function lines(str)
  local t = {}
  local function helper(line) table.insert(t, line) return "" end
  helper((str:gsub("(.-),", helper)))
  return t
end

function User:login()
  if not self:LoadData() then
    register = true
    register_chosesex = true
    return
  end

end

function User:register()
  PanauLife.Database:execute([[
    INSERT
    INTO    ]]..PanauLife.Config.sql.prefix..PanauLife.Config.sql.users..[[ (user_steamid, user_posx, user_posy, user_posz, user_angle, user_health, user_money, user_model, user_items, user_gender, user_origine)
    VALUES  (:steamid, :posx, :posy, :posz, :angle, :health, :money, :model, :items, :gender, :origine)
  ]], {
    [":steamid"] = self.player:GetSteamId().string,
    [":posx"] = PanauLife.Config.default_x,
    [":posy"] = PanauLife.Config.default_y,
    [":posz"] = PanauLife.Config.default_z,
    [":angle"] = math.rad(PanauLife.Config.default_angle),
    [":health"] = 1,
    [":money"] = PanauLife.Config.default_money,
    [":model"] = PanauLife.Config.default_model,
    [":items"] = PanauLife.Config.default_items,
    [":gender"] = genre,
    [":origine"] = origine
  })
end

function User:SaveData()
  PanauLife.Database:execute([[
    UPDATE  ]]..PanauLife.Config.sql.prefix..PanauLife.Config.sql.users..[[
    SET     user_posx = :posx, user_posy = :posy, user_posz = :posz, user_angle = :angle, user_health = :health, user_money = :money, user_model = :model, user_items = :items
    WHERE   user_steamid = :steamid
  ]], {
    [":posx"] = self.player:GetPosition().x,
    [":posy"] = self.player:GetPosition().y,
    [":posz"] = self.player:GetPosition().z,
    [":angle"] = self.player:GetAngle().y,
    [":health"] = self.player:GetHealth(),
    [":money"] = self.player:GetMoney(),
    [":model"] = self.player:GetModelId(),
    [":items"] = table.concat( Inventory, "," ),
    [":steamid"] = self.player:GetSteamId().string
  })
end

function User:perdreitem(item_name, number_lose)
  local x = 1
    while Inventory[x] ~= nil do
      if tostring(Inventory[x]) == item_name then
        local Inventory_Number = multiplier(tostring(Inventory[x]))
        local Inventory_Number_Calcul = tonumber(Inventory_Number[2]) - number_lose
        if Inventory_Number_Calcul == 0 then
          self.player:SendChatMessage("L'objet "..tostring(Inventory[x]).." a été détruit", Color(0,0,0))
          table.remove(Inventory, x)
          return
        else
        Inventory_Number[2] = tostring(Inventory_Number_Calcul)
        Inventory[x] = table.concat( Inventory_Number, "*" )
        self.player:SendChatMessage("Vous avez perdu "..number_lose.." "..tostring(Inventory[x]).."", Color(0,0,0))
        end
      end
      x = x + 1
    end
end

function User:add_item(item_name, number_add)
  local x = 1
    while Inventory[x] do
      local Inventory_Number = multiplier(tostring(Inventory[x]))
      if Inventory_Number[1] == item_name then
        if Inventory_Number[2] then
          local Inventory_Number_Calcul = tonumber(Inventory_Number[2]) + number_add
          Inventory_Number[2] = tostring(Inventory_Number_Calcul)
          Inventory[x] = table.concat( Inventory_Number, "*" )
          self.player:SendChatMessage("Vous avez gagnez "..number_add.." "..tostring(Inventory[x]).."", Color(0,0,0))
          return
        end

      end
       --[[ elseif multiplier(tostring(Inventory[x])) ~= nil then
          local Inventory_Number = multiplier(tostring(Inventory[x]))
          if tostring(Inventory_Number[1]) == item_name then
          Inventory_Number[2] = tostring(Inventory_Number_Calcul)
          Inventory[x] = table.concat( Inventory_Number, "*" )
          self.player:SendChatMessage("Vous avez gagnez "..number_add.." "..tostring(Inventory[x]).."", Color(0,0,0))
          return
          end
        end--]]
      x = x + 1
    end
    self.player:SendChatMessage("Vous avez gagnez "..number_add.." "..item_name.."", Color(0,0,0))
    table.insert(Inventory, ""..item_name.."*"..number_add.."")
    return
  end

function User:Chat(args)
  local cmd_args = args.text:split( " " )

  if register then
    if register_chosesex then
      Chat:Send(self.player, "Quel est votre genre ? ( homme ou femme )", Color(255,0,0))
      if args.Text == "homme" or args.Text == "femme" then
        genre = args.Text
        register_chosesex = false
        register_choseorigine = true
      else
        Chat:Send(self.player, "Le genre que vous avez entrez est invalide !", Color(255,0,0))
      end
    elseif register_choseorigine then
      Chat:Send(self.player, "De quel continant venez vous ? ( amerique,europe,asie,affrique,antartique )", Color(255,0,0))
      if args.Text == "amerique" or args.Text == "europe" or args.Text == "asie" or args.Text == "affrique" or args.Text == "antartique" then
        origine = args.Text
        register_choseorigine = false
        register = false
        self:register()
        self:LoadData()
      else
        Chat:Send(self.player, "Le genre que vous avez entrez est invalide !", Color(255,0,0))
      end
    end
  end
  if args.text == "/inventaire" then
    local x = 1
    while Inventory[x] ~= nil do
      self.player:SendChatMessage(tostring(Inventory[x]), Color(0,0,0))
      x = x + 1
    end
    return false
  end

  local cmd_args = args.text:split( " " )
  if cmd_args[1] == "/ramasser" then
    if not UserFarm:verif_zone_exsist(cmd_args[2])then
      self.player:SendChatMessage("L'objet "..cmd_args[2].." n'est pas ramassable", Color(0,0,0))
      return true
    elseif not UserFarm:verif_zone(cmd_args[2],self.player) then
      self.player:SendChatMessage("Il n'y a pas de champ de "..cmd_args[2].." ici !", Color(0,0,0))
      return true
    end
  end

  if cmd_args[1] == "/ajouter" then -- Commande ajouter = /ajouter item_name qualiter densiter pos1
      if cmd_args[5] == "pos1" then
        PanauLife.Database:execute([[
        INSERT
        INTO    ]]..cmd_args[2]..[[ (quality, density, pos_x_1, pos_z_1)
        VALUES  (:quality, :density, :pos_x_1, :pos_z_1)
        ]], {
        [":quality"] = cmd_args[3],
        [":density"] = cmd_args[4],
        [":pos_x_1"] = self.player:GetPosition().x,
        [":pos_z_1"] = self.player:GetPosition().z
        })
      end

      if cmd_args[4] == "pos2" then -- /ajouter item_name id pos2
        PanauLife.Database:execute([[
        UPDATE  ]]..cmd_args[2]..[[
        SET     pos_x_2 = :posx, pos_z_2 = :posy
        WHERE   id = :id
        ]], {
        [":posx"] = self.player:GetPosition().x,
        [":posy"] = self.player:GetPosition().y,
        [":id"] = cmd_args[3],
        })
      end

       local data2 = PanauLife.Database:query([[
    SELECT  *
    FROM    ]]..cmd_args[3]..[[
  ]])

  --if data.adminlvl == 3 then
    if cmd_args[1] == "/add" then
      if cmd_args[2] == "item" then  -- /create item item_name
        if not data2 then
          self.player:SendChatMessage("L'objet "..cmd_args[3].."  a été créé.", Color(0,0,0))
        else
          self.player:SendChatMessage("L'objet "..cmd_args[3].." existe deja.", Color(0,0,0))
        end
      end
    end
  --end
  if cmd_args[1] == "/verif" then -- /verif item_name id
    local data = PanauLife.Database:query([[
    SELECT  *
    FROM    :zone
    WHERE   id = :id
    LIMIT   1
  ]], {
    [":id"] = cmd_args[3],
    [":zone"] = cmd_args[2]
  })
    if tonumber(data[x].pos_x_1) <= tonumber(data[x].pos_x_2) and tonumber(data[x].pos_z_1) >= tonumber(data[x].pos_z_2) then
      self.player:SendChatMessage("La zone de "..cmd_args[2].." et d'id " ..cmd_args[3].." été correct.", Color(0,0,0))
    elseif tonumber(data[x].pos_x_1) >= tonumber(data[x].pos_x_2) then

    end
  end

      return false
  end

  if cmd_args[1] == "/jeter" then
    self:perdreitem(cmd_args[2], 1)
    return false
  end
end






function multiplier(str)
  if str == nil then
    return false
  end
  local t = {}
  local function helper(line) table.insert(t, line) return "" end
  helper((str:gsub("(.-)*", helper)))
  return t
end

function User:Remove()

end
