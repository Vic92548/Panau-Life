class("PanauUser")

  function PanauUser:__init()
    self.users = {}

    Events:Subscribe("ModuleLoad", self, self.Load)
    Events:Subscribe("ModuleUnload", self, self.Unload)
    Events:Subscribe("PlayerAuthenticate", self, self.Join)
    Events:Subscribe("PlayerQuit", self, self.Leave)
  end

  function PanauUser:Load()
    for player in Server:GetPlayers() do
      self.users[player:GetSteamId().string] = User(player)
    end
  end

  function PanauUser:Unload()
    for player in Server:GetPlayers() do
      self:GetUser(player):SaveData()
      self:RemoveUser(player)
    end
  end

  function PanauUser:Join(args)
    self.users[args.player:GetSteamId().string] = User(args.player)
  end

  function PanauUser:Leave(args)
    self:GetUser(args.player):SaveData()
    self:RemoveUser(args.player)
  end

  function PanauUser:GetUser(player)
    return self.users[player:GetSteamId().string]
  end

  function PanauUser:RemoveUser(player)
    self.users[player:GetSteamId().string] = nil
  end

PanauLife.User = PanauUser()

class("User")

  function User:__init(player)
    self.player = player

    self:Login()
  end

  function User:LoadData()
    local data = PanauLife.Database:query([[
      SELECT  user_posx, user_posy, user_posz, user_health, user_cash, user_account, user_model
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

  function User:SaveData()
    PanauLife.Database:execute([[
      UPDATE  users
      SET     user_posx = :posx, user_posy = :posy, user_posz = :posz, user_angle = :angle, user_health = :health, user_cash = :cash, user_account = :account, user_model = :model
      WHERE   user_steamid = :steamid
    ]], {
      [":posx"] = self.player:GetPosition().x,
      [":posy"] = self.player:GetPosition().y,
      [":posz"] = self.player:GetPosition().z,
      [":angle"] = self.player:GetAngle().y,
      [":health"] = self.player:GetHealth(),
      [":cash"] = self.player:GetMoney(),
      [":account"] = self.player.data.user_account,
      [":model"] = self.player:GetModelId(),
      [":steamid"] = self.player:GetSteamId().string
    })

    local data = PanauLife.Database:query([[
      SELECT  vehicle_id
      FROM    vehicles
      WHERE   vehicle_owner = :owner
    ]], {
      [":owner"] = self.player:GetSteamId().string
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

  function User:Register()
    PanauLife.Database:execute([[
      INSERT
      INTO    users (user_steamid, user_posx, user_posy, user_posz, user_angle, user_health, user_cash, user_account, user_model)
      VALUES  (:steamid, :posx, :posy, :posz, :angle, :health, :cash, :account, :model)
    ]], {
      [":steamid"] = self.player:GetSteamId().string,
      [":posx"] = PanauLife.Config.User.default_x,
      [":posy"] = PanauLife.Config.User.default_y,
      [":posz"] = PanauLife.Config.User.default_z,
      [":angle"] = math.rad(PanauLife.Config.User.default_angle),
      [":health"] = 1,
      [":cash"] = PanauLife.Config.User.default_cash,
      [":account"] = PanauLife.Config.User.default_account,
      [":model"] = PanauLife.Config.User.default_model
    })
  end

  function User:Login()
    local PlayerData = self:LoadData()
    if PlayerData ~= "" then
      self.player.data = PlayerData
      self:Spawn()
    else
      self:Register()
      self.player.data = self:LoadData()
      self:Spawn()
    end
  end

  function User:Spawn()
    self.player:ClearInventory()
    self.player:SetPosition(Vector3(self.player.data.user_posx, self.player.data.user_posy, self.player.data.user_posz))
    self.player:SetHealth(self.player.data.user_health)
    self.player:SetMoney(self.player.data.user_cash)
    self.player:SetModelId(self.player.data.user_model)

    local data = PanauLife.Database:query([[
      SELECT  *
      FROM    vehicles
      WHERE   vehicle_owner = :owner
    ]], {
      [":owner"] = self.player:GetSteamId().string
    })

      local x = 1
      if not data then
        print("not data")
      else
        while data[x] ~= nil do
          PanauLife.Vehicles:SetData(data[x].vehicle_id, data[x])
          PanauLife.Vehicles:Create(data[x].vehicle_id)
          x = x + 1
        end
      end
  end
