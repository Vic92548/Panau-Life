UserLoaded = false

function string:split( inSplitPattern, outResults )
 
   if not outResults then
      outResults = {}
   end
   local theStart = 1
   local theSplitStart, theSplitEnd = string.find( self, inSplitPattern, theStart )
   while theSplitStart do
      table.insert( outResults, string.sub( self, theStart, theSplitStart-1 ) )
      theStart = theSplitEnd + 1
      theSplitStart, theSplitEnd = string.find( self, inSplitPattern, theStart )
   end
   table.insert( outResults, string.sub( self, theStart ) )
   return outResults
end

class("CarMenu")
function CarMenu:__init()
    self.active = false

    self.window = Window.Create()
    self.window:SetSizeRel( Vector2( 0.3, 0.5 ) )
    self.window:SetPositionRel( Vector2( 0.75, 0.5 ) - self.window:GetSizeRel()/2 )
    self.window:SetVisible( self.active )
    self.window:SetTitle( "Menu Véhicule" )
    self.window:Subscribe( "WindowClosed", self, self.Close )

    self.TabControl = TabControl.Create( self.window )
    self.TabControl:SetDock( GwenPosition.Fill )

    Events:Subscribe( "Render", self, self.Render )
    Events:Subscribe( "LocalPlayerInput", self, self.LocalPlayerInput )
end

function CarMenu:GetActive()
    return self.active
end

function CarMenu:Sell()
    print("selling car")
end

function CarMenu:SetActive( active, vehicle )
    if self.active ~= active then
        if vehicle then
            self.window:SetTitle( vehicle:GetName() )
        end

        self.active = active
        Mouse:SetVisible( self.active )
    end
end

function CarMenu:Render()
    local is_visible = self.active and (Game:GetState() == GUIState.Game)

    if self.window:GetVisible() ~= is_visible then
        self.window:SetVisible( is_visible )
    end

    if self.active then
        Mouse:SetVisible( true )
    end
end

function CarMenu:LocalPlayerInput( args )
    if self.active and Game:GetState() == GUIState.Game then
        return false
    end
end


function CarMenu:Close( args )
    self:SetActive( false,nil )
end

PanauGUI.CarMenu = CarMenu()