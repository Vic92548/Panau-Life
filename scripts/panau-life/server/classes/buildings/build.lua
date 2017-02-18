class("PanauBuild")

  function PanauBuild:__init()
    self.buildings = {}

    Events:Subscribe("ModuleLoad", self, self.LoadBuildings)
  end

  function PanauBuild:LoadBuildings()
    self.buildings = PanauLife.Database:query([[
      SELECT  *
      FROM    buildings
    ]])
    for k, v in pairs( self.buildings ) do
      print(k, v)
    end
    print(self.buildings[1].building_name)
  end

  function PanauBuild:CreateBuilding(data)
    
    PanauLife.Database:execute([[
      INSERT  
      INTO    buildings (building_name, building_type, building_posx, building_posy, building_posz, building_radius, building_state)
      VALUES  (:name, :type, :posx, :posy, :posz, :radius, :state)
    ]], {
      [":name"] = data.building_name,
      [":type"] = data.building_type,
      [":posx"] = data.building_posx,
      [":posy"] = data.building_posy,
      [":posz"] = data.building_posz,
      [":radius"] = data.building_radius,
      [":state"] = data.building_state
    })
  end

  function PanauBuild:SendBuildings(buildings)
    for player in Server:GetPlayers() do
      Network:Send(player, "Buldings", buildings)
    end
  end

  function PanauBuild:SendBuildingsTo(player)
    Network:Send(player, "Buldings", self.buildings)
  end

  function PanauBuild:UpdateState(id, state)
    PanauLife.Database:execute([[
      UPDATE  buildings
      SET     building_state = :state
      WHERE   building_name = :name
    ]], {
      [":state"] = state,
      [":name"] = self.buildings[id].building_name
    })
    self.SendBuildings()
  end

  function PanauBuild:GetBuildings()
    return self.buildings
  end

PanauLife.Build = PanauBuild()
