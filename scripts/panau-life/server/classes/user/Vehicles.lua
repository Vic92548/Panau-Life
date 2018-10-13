class("PanauVehicles")

  function PanauVehicles:__init()
    self.vehicles = {}
  end

  function PanauVehicles:SetData(id, data)
    self.vehicles[id] = {}
    self.vehicles[id].data = data
  end
  function PanauVehicles:Create(id)
    local obj = Vehicle.Create(self.vehicles[id].data.vehicle_model, Vector3(self.vehicles[id].data.vehicle_posx,self.vehicles[id].data.vehicle_posy,self.vehicles[id].data.vehicle_posz), Angle(self.vehicles[id].data.vehicle_yaw, self.vehicles[id].data.vehicle_pitch, self.vehicles[id].data.vehicle_roll))
    self.vehicles[id].veh = obj:GetId()
    obj:SetColors( Color(self.vehicles[id].data.vehicle_colorr,self.vehicles[id].data.vehicle_colorg,self.vehicles[id].data.vehicle_colorb), Color(self.vehicles[id].data.vehicle_colorr2,self.vehicles[id].data.vehicle_colorg2,self.vehicles[id].data.vehicle_colorb2) )
    obj:SetUnoccupiedRemove(false)
    obj:SetUnoccupiedRespawnTime(9999999999)
  end

  function PanauVehicles:SaveData(id)
    local Tone1,Tone2 = Vehicle.GetById(self.vehicles[id].veh):GetColors()
    PanauLife.Database:execute([[
      UPDATE  vehicles
      SET     vehicle_posx = :posx, vehicle_posy = :posy, vehicle_posz = :posz, vehicle_colorr = :cr, vehicle_colorg = :cg, vehicle_colorb = :cb, vehicle_colorr2 = :cr2, vehicle_colorg2 = :cg2, vehicle_colorb2 = :cb2, vehicle_yaw = :yaw, vehicle_pitch = :pitch, vehicle_roll = :roll, vehicle_items = :items, vehicle_locked = :locked, vehicle_capacity = :capacity
      WHERE   vehicle_id = :veh_id
    ]], {
      [":posx"] = Vehicle.GetById(self.vehicles[id].veh):GetPosition().x,
      [":posy"] = Vehicle.GetById(self.vehicles[id].veh):GetPosition().y,
      [":posz"] = Vehicle.GetById(self.vehicles[id].veh):GetPosition().z,
      [":cr"] = Tone1.r,
      [":cg"] = Tone1.g,
      [":cb"] = Tone1.b,
      [":cr2"] = Tone2.r,
      [":cg2"] = Tone2.g,
      [":cb2"] = Tone2.b,
      [":yaw"] = Vehicle.GetById(self.vehicles[id].veh):GetAngle().yaw,
      [":pitch"] = Vehicle.GetById(self.vehicles[id].veh):GetAngle().pitch,
      [":roll"] = Vehicle.GetById(self.vehicles[id].veh):GetAngle().roll,
      [":items"] = self.vehicles[id].data.vehicle_items,
      [":locked"] = self.vehicles[id].data.vehicle_locked,
      [":capacity"] = self.vehicles[id].data.vehicle_capacity,
      [":veh_id"] = id
    })
    Vehicle.GetById(self.vehicles[id].veh):Remove()
  end
PanauLife.Vehicles = PanauVehicles()
