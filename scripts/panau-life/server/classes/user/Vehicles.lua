class("PanauVehicles")

  function PanauVehicles:__init()
    self.vehicles = {}
  end

  function PanauVehicles:SetData(id, data)
    self.vehicles[id].data = data
  end
  function PanauVehicles:Create(id, posx, posy, posz, model)
    self.vehicles[id] = {}
    local obj = Vehicle.Create(model, Vector3(posx,posy,posz), Angle(0, 0, 0))
    print(obj:GetId())
    if obj:GetId() ~= nil then
      self.vehicles[id].veh = obj:GetId()
    else
      print("Veh Bug")
    end
    
  end

  function PanauVehicles:SaveData(id)
    PanauLife.Database:execute([[
      UPDATE  vehicles
      SET     vehicle_posx = :posx, vehicle_posy = :posy, vehicle_posz = :posz, vehicle_colorr = :cr, vehicle_colorg = :cg, vehicle_colorb = :cb
      WHERE   vehicle_id = :veh_id
    ]], {
      [":posx"] = Vehicle.GetById(self.vehicles[id].veh):GetPosition().x,
      [":posy"] = Vehicle.GetById(self.vehicles[id].veh):GetPosition().y,
      [":posz"] = Vehicle.GetById(self.vehicles[id].veh):GetPosition().z,
      [":veh_id"] = id
    })
    Vehicle.GetById(self.vehicles[id].veh):Remove()
  end
PanauLife.Vehicles = PanauVehicles()
