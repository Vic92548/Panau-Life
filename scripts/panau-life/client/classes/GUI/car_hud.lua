class 'CarHud'

function CarHud:__init()
    self.enabled = true
    self.bottom_aligned = false
    self.center_aligned = false
    self.unit = 1 -- 0: m/s 1: km/h 2: mph
    self.position = LocalPlayer:GetPosition()

    self.speed_text_size = TextSize.Gigantic
    self.unit_text_size = TextSize.Huge
    self.zero_health        = Color( 255,  78, 69 ) -- Zero health colour
    self.full_health        = Color( 55,  204, 73 ) -- Full health colour

    Events:Subscribe( "PreTick", self, self.PreTick )
    Events:Subscribe( "Render", self, self.Render )
    Events:Subscribe( "GameRender", self, self.GameRender )
    Events:Subscribe( "LocalPlayerInput", self, self.LocalPlayerInput )
    Events:Subscribe( "ModulesLoad", self, self.ModulesLoad )
    Events:Subscribe( "ModuleUnload", self, self.ModuleUnload )
end

function CarHud:GetWindowOpen()
    return self.window_open
end

function CarHud:SetWindowOpen( state )
    self.window_open = state
    self.window:SetVisible( self.window_open )
    Mouse:SetVisible( self.window_open )
end

function CarHud:GetSpeed( vehicle )
    local speed = vehicle:GetLinearVelocity():Length()

    if self.unit == 0 then
        return speed
    elseif self.unit == 1 then
        return speed * 3.6
    elseif self.unit == 2 then
        return speed * 2.237
    end
end

function CarHud:DrawShadowedText3( pos, text, colour, size, scale )
    if scale == nil then scale = 1.0 end
    if size == nil then size = TextSize.Default end

    local shadow_colour = Color( 0, 0, 0, 255 )
    shadow_colour = shadow_colour * 0.4

    Render:DrawText( pos + Vector3( 1, 1, 4 ), text, colour, size, scale )
    Render:DrawText( pos + Vector3( 1, 1, 2 ), text, shadow_colour, size, scale )
    Render:DrawText( pos, text, colour, size, scale )
end

function CarHud:DrawShadowedText2( pos, text, colour, size, scale )
    if scale == nil then scale = 1.0 end
    if size == nil then size = TextSize.Default end

    local shadow_colour = Color( 0, 0, 0, 255 )
    shadow_colour = shadow_colour * 0.4

    Render:DrawText( pos + Vector2( 1, 1 ), text, shadow_colour, size, scale )
    Render:DrawText( pos, text, colour, size, scale )
end

function CarHud:PreTick()
    self.position = LocalPlayer:GetPosition()
end

function CarHud:Render()
    if Game:GetState() ~= GUIState.Game or not self.enabled then return end
    if not self.bottom_aligned then return end
    if not LocalPlayer:InVehicle() then return end

    local vehicle = LocalPlayer:GetVehicle()

    local speed = self:GetSpeed( vehicle )
    local speed_text = string.format( "%.01f", speed )
    local speed_size = Render:GetTextSize( speed_text, self.speed_text_size )

    local unit_text = "km/h"
    local unit_size = Render:GetTextSize( unit_text, self.unit_text_size )
    local angle = vehicle:GetAngle() * Angle( math.pi, 0, math.pi )

    local factor = math.clamp( vehicle:GetHealth() - 0.4, 0.0, 0.6 ) * 2.5

    local textcol
    local col = math.lerp( self.zero_health, self.full_health, factor )
    
    textcol = col
    
    local text_size = speed_size + Vector2( unit_size.x + 16, 0 )

    local speed_position = Vector2(Render.Width / 2, Render.Height)
    
    speed_position.y = speed_position.y - (speed_size.y + 10)
    speed_position.x = speed_position.x - (text_size.x / 2)
    
    local unit_position = Vector2()
    
    unit_position.x = speed_position.x + speed_size.x + 16
    unit_position.y = speed_position.y + ((speed_size.y - unit_size.y) / 2)
    
    self:DrawShadowedText2( speed_position, speed_text, textcol, self.speed_text_size )
    self:DrawShadowedText2( unit_position,
        unit_text,
        Color( 255, 255, 255, 255 ),
        self.unit_text_size )

    local bar_len = 300
    local bar_start = (Render.Width - bar_len) / 2
    
    local bar_pos = Vector2( bar_start, speed_position.y + text_size.y)
    local final_pos = Vector2(bar_len, 4)
    
    bar_len = bar_len * vehicle:GetHealth()
end

function CarHud:GameRender()
    if Game:GetState() ~= GUIState.Game or not self.enabled then return end
    if self.bottom_aligned then return end
    if not LocalPlayer:InVehicle() then return end

    local vehicle = LocalPlayer:GetVehicle()

    local speed = self:GetSpeed( vehicle )
    local speed_text = string.format( "%.01f", speed )
    local speed_size = Render:GetTextSize( speed_text, self.speed_text_size )

    local unit_text = "km/h"
    local unit_size = Render:GetTextSize( unit_text, self.unit_text_size )
    local angle = vehicle:GetAngle() * Angle( math.pi, 0, math.pi )

    local factor = math.clamp( vehicle:GetHealth() - 0.4, 0.0, 0.6 ) * 2.5

    local textcol
    local col = math.lerp( self.zero_health, self.full_health, factor )
    
    textcol = col
    
    local text_size = speed_size + Vector2( unit_size.x + 24, 0 )

    local t = Transform3()

    if self.center_aligned then
        local pos_3d = vehicle:GetPosition()
        pos_3d.y = LocalPlayer:GetBonePosition( "ragdoll_Head" ).y

        local scale = 1
        
        t:Translate( pos_3d )
        t:Scale( 0.0050 * scale )
        t:Rotate( angle )
        t:Translate( Vector3( 0, 0, 2000 ) )
        t:Translate( -Vector3( text_size.x, text_size.y, 0 )/2 )
    else
        local pos_3d = self.position
        angle = angle * Angle( -math.rad(20), 0, 0 )

        local scale = math.clamp( Camera:GetPosition():Distance( pos_3d ), 0, 500 )
        scale = scale / 20
        
        t = Transform3()
        t:Translate( pos_3d )
        t:Scale( 0.0050 * scale )
        t:Rotate( angle )
        t:Translate( Vector3( text_size.x + 50, text_size.y, -250 ) * -1.5 )
    end

    Render:SetTransform( t )
    
    self:DrawShadowedText3( Vector3( 0, 0, 0 ), speed_text, textcol, self.speed_text_size )
    self:DrawShadowedText3( Vector3( speed_size.x + 24, (speed_size.y - unit_size.y)/2, 0), 
        unit_text,
        Color( 255, 255, 255, 255 ),
        self.unit_text_size )

    local bar_pos = Vector3( 0, text_size.y + 4, 0 )
    local bar_len = text_size.x * vehicle:GetHealth()
end

function CarHud:LocalPlayerInput( args )
    if self:GetWindowOpen() and Game:GetState() == GUIState.Game then
        return false
    end
end

function CarHud:WindowClosed( args )
    self:SetWindowOpen( false )
end

function CarHud:ModulesLoad()
    Events:Fire( "HelpAddItem",
        {
            name = "Speedometer",
            text = 
                "The speedometer is a heads-up display that shows you your " ..
                "current speed in m/s, km/h, or mph.\n\n" ..
                "To configure it, type /speedometer or /speedo in chat."
        } )
end

function CarHud:ModuleUnload()
    Events:Fire( "HelpRemoveItem",
        {
            name = "CarHud"
        } )
end

car_hud = CarHud()