class("PanauVehicles")

  function PanauVehicles:__init()
    self.vehicles = {}
  end

  function PanauVehicles:SetData(id, data)
    self.vehicles[id].data = data
  end
  function PanauVehicles:Create(id)
    self.vehicles[id].veh = Vehicle.Create(self.vehicles[id].data.vehicle_model, Vector3(self.vehicles[id].data.vehicle_posx,self.vehicles[id].data.vehicle_posy,self.vehicles[id].data.vehicle_posz), Angle(0, 0, 0)):GetId()
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
      [":cr"] = Vehicle.GetById(self.vehicles[id].veh):GetColors()[1].r,
      [":cg"] = Vehicle.GetById(self.vehicles[id].veh):GetColors()[1].g,
      [":cb"] = Vehicle.GetById(self.vehicles[id].veh):GetColors()[1].b,
      [":veh_id"] = id
    })
  end
PanauLife.Vehicles = PanauVehicles()
