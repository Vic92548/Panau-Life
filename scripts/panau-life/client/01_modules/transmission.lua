class("PanauLife_Transmission")

function Panaulife_Transmission:__init()
  self.gear_cooldown = Timer()
  self.cruise_cooldown = Timer()
  self.gear_cooldown_delay = 250
  self.cruise_cooldown_delay = 250
  self.cruise_deadzone = 5

  Events:Subscribe("LocalPlayerEnterVehicle", self, self.EnterVehicle)
  Events:Subscribe("LocalPlayerInput", self, self.ChangeGear)
  Events:Subscribe("LocalPlayerInput", self, self.EnableCruiseControl)
  Events:Subscribe("InputPoll", self, self.CruiseControl)
end

function PanauLife_Transmission:GetVelocity()

end

function PanauLife_Transmission:EnterVehicle(a)
  if not a.is_driver then return end

  if not a.vehicle:GetValue("IsAutomatic") then
    local transmission = a.vehicle:GetTransmission()
    transmission:SetManual(true)
  end
end

function PanauLife_Transmission:ChangeGear(a)
  local vehicle = LocalPlayer:GetVehicle()
  if not vehicle or vehicle:GetClass() ~= VehicleClass.Land or vehicle:GetDriver() ~= LocalPlayer then return end

  local transmission = vehicle:GetTransmission()
  if self.gear_cooldown:GetMilliseconds() >= self.gear_cooldown_delay then
    if a.input == Action.Dash and transmission:GetGear() < transmission:GetMaxGear() then
      transmission:SetGear(transmission:GetGear()+1)
      self.gear_cooldown:Restart()
      return false
    elseif a.input == Action.Crouch and transmission:GetGear() > 1 then
      transmission:SetGear(transmission:GetGear()-1)
      self.gear_cooldown:Restart()
      return false
    end
  end
end

function PanauLife_Transmission:EnableCruiseControl(a)
  local vehicle = LocalPlayer:GetVehicle()
  if not vehicle or vehicle:GetClass() ~= VehicleClass.Land or vehicle:GetDriver() ~= LocalPlayer then return end

  if self.cruise_cooldown:GetMilliseconds() >= self.cruise_cooldown_delay then
    local velocity = -(-vehicle:GetAngle()*vehicle:GetLinearVelocity()).z*3.6
    if a.input == Action.SoundHornSiren then
      Chat:Print("Triggered!", Color(255, 0, 0))
      if vehicle:GetValue("Panaulife.CruiseControl") then
        vehicle:SetValue("Panaulife.CruiseControl", nil)
        Chat:Print("Régulateur désactivé !", Color(255, 0, 0))
      elseif velocity > 0 then
        vehicle:SetValue("Panaulife.CruiseControl", velocity)
        Chat:Print("Régulateur activé à "..velocity.." km/h.", Color(0, 255, 0))
      end
      self.cruise_cooldown:Restart()
      return false
    end
  end
end

function PanauLife_Transmission:CruiseControl(a)
  local vehicle = LocalPlayer:GetVehicle()
  if not vehicle or vehicle:GetClass() ~= VehicleClass.Land or vehicle:GetDriver() ~= LocalPlayer then return end

  if vehicle:GetValue("Panaulife.CruiseControl") then
    local velocity = -(-vehicle:GetAngle()*vehicle:GetLinearVelocity()).z*3.6
    if velocity > vehicle:GetValue("Panaulife.CruiseControl")+self.cruise_deadzone then
      Input:SetValue(Action.Reverse, 1)
    elseif velocity < vehicle:GetValue("Panaulife.CruiseControl")-self.cruise_deadzone then
      Input:SetValue(Action.Accelerate, 1)
    end
  end
end

PanauLife.Transmission = PanauLife_Transmission()
