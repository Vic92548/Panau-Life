class("PanauVehicle")

  function PanauVehicle:__inti()
    self.vehicles = {}

    Events:Subscribe("ModuleUnload", self, self.Unload)
  end

  function PanauVehicle:Unload()
    for vehicle in self.vehicles do
      self:GetVehicle(vehicle):SaveData()
    end
  end

  function PanauVehicle:AddVehicle(vehicle)
    self.vehicles[vehicle:GetId().string] = Vehicle(vehicle)
  end  
