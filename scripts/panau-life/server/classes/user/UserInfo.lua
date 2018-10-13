Users = {}
class("PanauUser")

  function PanauUser:__init()

    Events:Subscribe("ModuleLoad", self, self.Load)
    Events:Subscribe("ModuleUnload", self, self.Unload)
    Events:Subscribe("PlayerAuthenticate", self, self.Join)
    Events:Subscribe("PlayerQuit", self, self.Leave)
  end

  function PanauUser:Load()
    for player in Server:GetPlayers() do
      Users[player:GetSteamId().string] = User(player)
    end
  end

  function PanauUser:Unload()
    for player in Server:GetPlayers() do
      self:GetUser(player):SaveData()
      self:RemoveUser(player)
    end
  end

  function PanauUser:Join(args)
    User(args.player)
    PanauLife.Build:SendBuildingsTo(args.player)
  end

  function PanauUser:Leave(args)
    PlayerSaveData(args.player)
    self:RemoveUser(args.player)
  end


  function PanauUser:RemoveUser(player)
    Users[player:GetSteamId().string] = nil
  end

PanauLife.User = PanauUser()

function PlayerSaveData(player)
    local steamid = player:GetSteamId().string
    PanauLife.Database:execute([[
      UPDATE  users
      SET     user_posx = :posx, user_posy = :posy, user_posz = :posz, user_angle = :angle, user_health = :health, user_cash = :cash, user_account = :account, user_model = :model, user_hunger = :hunger, user_thirst = :thirst, user_items = :items, user_level = :level, user_xp = :xp, user_skills = :skills, user_options = :options, user_skillspoint = :skillspoint
      WHERE   user_steamid = :steamid
    ]], {
      [":posx"] = player:GetPosition().x,
      [":posy"] = player:GetPosition().y,
      [":posz"] = player:GetPosition().z,
      [":angle"] = player:GetAngle().y,
      [":health"] = player:GetHealth(),
      [":cash"] = player:GetMoney(),
      [":account"] = Users[steamid].user_account,
      [":model"] = player:GetModelId(),
      [":hunger"] = Users[steamid].user_hunger,
      [":thirst"] = Users[steamid].user_thirst,
      [":items"] = Users[steamid].user_items,
      [":level"] = Users[steamid].user_level,
      [":xp"] = Users[steamid].user_xp,
      [":skills"] = Users[steamid].user_skills,
      [":options"] = Users[steamid].user_options,
      [":skillspoint"] = Users[steamid].user_skillspoint,
      [":steamid"] = player:GetSteamId().string
    })

    local data = PanauLife.Database:query([[
      SELECT  vehicle_id
      FROM    vehicles
      WHERE   vehicle_owner = :owner
    ]], {
      [":owner"] = player:GetSteamId().string
    })

    if not data then

    else
      local x = 1
      while data[x] ~= nil do
        PanauLife.Vehicles:SaveData(data[x].vehicle_id)
        x = x + 1
      end
    end
end

class("User")

  function User:__init(player)
    self.player = player

    self:Login()
  end

  function User:LoadData()
    local data = PanauLife.Database:query([[
      SELECT  *
      FROM    users
      WHERE   user_steamid = :steamid
      LIMIT   1
    ]], {
      [":steamid"] = self.player:GetSteamId().string
    })

    if not data then
      return ""
    end
    return data
  end

  

  function User:Register()
    PanauLife.Database:execute([[
      INSERT
      INTO    users (user_steamid, user_posx, user_posy, user_posz, user_angle, user_health, user_cash, user_account, user_model, user_hunger, user_thirst, user_items, user_level, user_xp, user_skills, user_options, user_skillspoint)
      VALUES  (:steamid, :posx, :posy, :posz, :angle, :health, :cash, :account, :model, :hunger, :thirst, :items, :level, :xp, :skills, :options, :skillspoint)
    ]], {
      [":steamid"] = self.player:GetSteamId().string,
      [":posx"] = PanauLife.Config.User.default_x,
      [":posy"] = PanauLife.Config.User.default_y,
      [":posz"] = PanauLife.Config.User.default_z,
      [":angle"] = math.rad(PanauLife.Config.User.default_angle),
      [":health"] = 1,
      [":cash"] = PanauLife.Config.User.default_cash,
      [":account"] = PanauLife.Config.User.default_account,
      [":model"] = PanauLife.Config.User.default_model,
      [":hunger"] = PanauLife.Config.User.default_hunger,
      [":thirst"] = PanauLife.Config.User.default_thirst,
      [":items"] = PanauLife.Config.User.default_items,
      [":level"] = PanauLife.Config.User.default_level,
      [":xp"] = PanauLife.Config.User.default_xp,
      [":skills"] = PanauLife.Config.User.default_skills,
      [":options"] = PanauLife.Config.User.default_options,
      [":skillspoint"] = PanauLife.Config.User.default_skillspoint
    })
  end

  function User:Login()
    local steamid = self.player:GetSteamId().string
    local PlayerData = self:LoadData()
    if PlayerData ~= "" then
      Users[steamid] = PlayerData
      Users[steamid].vehicles = {}
      self:Spawn()
    else
      self:Register()
      Users[steamid] = self:LoadData()
      Users[steamid].vehicles = {}
      self:Spawn()
    end
    print(Users[self.player:GetSteamId().string])
  end

  function User:GetExpForNextLevel()
    if self.player.data.level == 1 then
      self.player.data.expfornextlevel = PanauLife.Level.default_xp
    else
      local x = 1
      local expfornextlevel = PanauLife.Level.default_xp
      while x < self.player.level do
        expfornextlevel = expfornextlevel * PanauLife.Level.default_multiplier
        x = x + 1
      end
    end
  end

  function User:Spawn()
    self.player:ClearInventory()
    self.player:SetPosition(Vector3(Users[self.player:GetSteamId().string].user_posx, Users[self.player:GetSteamId().string].user_posy, Users[self.player:GetSteamId().string].user_posz))
    self.player:SetHealth(Users[self.player:GetSteamId().string].user_health)
    self.player:SetMoney(Users[self.player:GetSteamId().string].user_cash)
    self.player:SetModelId(Users[self.player:GetSteamId().string].user_model)


    local data = PanauLife.Database:query([[
      SELECT  *
      FROM    vehicles
      WHERE   vehicle_owner = :owner
    ]], {
      [":owner"] = self.player:GetSteamId().string
    })

      if not data then
        print("not data")
      else
        if #data == 1 then
          print("Veh : "..tostring(data[1].vehicle_id))
          PanauLife.Vehicles:SetData(data[1].vehicle_id, data[1])
          PanauLife.Vehicles:Create(data[1].vehicle_id)
          Users[self.player:GetSteamId().string].vehicles[1] = data[1]
        else
          for i = 1,#data do
            print("Veh : "..tostring(data[i].vehicle_id))
            PanauLife.Vehicles:SetData(data[i].vehicle_id, data[i])
            PanauLife.Vehicles:Create(data[i].vehicle_id)
            Users[self.player:GetSteamId().string].vehicles[i] = data[i]
          end
        end
      end
      print(Users[self.player:GetSteamId().string].vehicles[0])
      Network:Send(self.player, "UpdateUser", Users[self.player:GetSteamId().string])
  end
