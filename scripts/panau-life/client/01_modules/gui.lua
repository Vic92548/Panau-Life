class("Panaulife_GUI")

function Panaulife_GUI:__init()
  self.enabled = true

  Events:Subscribe("Render", self, self.Render)
end


function Panaulife_GUI:SetEnabled(state)
  self.enabled = state
end

function Panaulife_GUI:GetEnabled()
  return self.enabled
end


function Panaulife_GUI:DrawTextShadowed(position, text, color, size)
  Render:DrawText(position+Vector2(1, 1), text, Color(20, 20, 20, color.a*0.6), size)
  Render:DrawText(position+Vector2(2, 2), text, Color(20, 20, 20, color.a*0.3), size)
  Render:DrawText(position, text, color, size)
end


function Panaulife_GUI:GetWidthMiddle(size)
  return Vector2(Render.Size.x/2-size.x/2, size.y)
end

function Panaulife_GUI:GetVelocity(vehicle)
  return -(-vehicle:GetAngle()*vehicle:GetLinearVelocity()).z*3.6
end


function Panaulife_GUI:Render()
  if not self.enabled then return end

  self:GPS()
  self:Speedometer()

  self:HealthBar()
  self:Nametags()
  self:ChatProximity()
end

function Panaulife_GUI:GPS()
  local vehicle = LocalPlayer:GetVehicle()
  if not vehicle or vehicle:GetDriver() ~= LocalPlayer then return end

  local position, is_set = Waypoint:GetPosition()
  if not is_set then return end

  local distance = vehicle:GetPosition():Distance(position)/1000
  local velocity = self:GetVelocity(vehicle)
  local time = distance/velocity*60
  Render:DrawText(Vector2(300, 50), ("GPS - %ikm - %imn"):format(distance, time), Color(255, 190, 110), 40)
end

function Panaulife_GUI:Speedometer()
  local vehicle = LocalPlayer:GetVehicle()
  if not vehicle or vehicle:GetDriver() ~= LocalPlayer then return end

  local bottom_offset = Render.Height

  if vehicle:GetClass() == VehicleClass.Land then
    local transmission = vehicle:GetTransmission()

    local gear = ("%i/%i"):format(transmission:GetGear(), transmission:GetMaxGear())
    bottom_offset = bottom_offset-Render:GetTextHeight(gear, 40)-10
    self:DrawTextShadowed(Vector2(Render.Width/2-Render:GetTextWidth(gear, 40)/2, bottom_offset), gear, Color(255, 190, 110), 40)

    local rpm_width = (400*vehicle:GetRPM())/vehicle:GetMaxRPM()
    bottom_offset = bottom_offset-30-3
    Render:FillArea(Vector2(Render.Width/2-200, bottom_offset), Vector2(400, 30), Color(0, 0, 0, 150))
    Render:FillArea(Vector2(Render.Width/2-200+2, bottom_offset+2), Vector2(rpm_width-4, 26), Color(255, 190, 110))
  end

  local velocity = ("%i km/h"):format(-(-vehicle:GetAngle()*vehicle:GetLinearVelocity()).z*3.6)
  bottom_offset = bottom_offset-Render:GetTextHeight(velocity, 48)-3
  self:DrawTextShadowed(Vector2(Render.Width/2-Render:GetTextWidth(velocity, 48)/2, bottom_offset), velocity, Color(255, 190, 110), 48)
end

function Panaulife_GUI:HealthBar()
  
end

function Panaulife_GUI:Nametags()
  for player in Client:GetStreamedPlayers() do
    local head_position = player:GetBonePosition("ragdoll_Head")
    head_position.z = head_position.z+1

    Render:DrawText(head_position, player:GetName(), Color(255, 255, 255), 24)
  end
  local myTransform = Transform3()
  myTransform:Rotate(Angle(0, 0, math.rad(90)))

  Render:SetTransform(myTransform)
  Render:DrawCircle(Vector3(887.016296386719, 217.547897338867, 441.206298828125), 5, Color(255, 255, 255))
  Render:DrawText(Vector3(887.016296386719, 217.547897338867, 441.206298828125), "Saucisson Hallal", Color(255, 190, 110), 14, 0.05)
  Render:ResetTransform()
end

function Panaulife_GUI:ChatProximity()
  if not Chat:GetActive() then return end

  local near_players = {}
  for player in Client:GetStreamedPlayers() do
    table.insert(near_players, player:GetName())
  end

  if #near_players > 0 then
    local string = "Ces joueurs vous entendent :\n"
    for _, name in ipairs(near_players) do
      string = string..name.."\n"
    end
    Render:DrawText(Vector2(50, 500), string, Color(50, 255, 50), 16)
  else
    Render:DrawText(Vector2(50, 500), "Personne ne peut vous entendre !", Color(255, 50, 50), 16)
  end
end

Panaulife.GUI = Panaulife_GUI()