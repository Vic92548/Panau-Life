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

class("MenuRestaurant")
function MenuRestaurant:__init()
    self.active = false
    self.loaded = true
    self.window = Window.Create()
    self.window:SetSizeRel( Vector2( 0.3, 0.5 ) )
    self.window:SetPositionRel( Vector2( 0.75, 0.5 ) - self.window:GetSizeRel()/2 )
    self.window:SetVisible( self.active )
    self.window:SetTitle( "Restaurant" )
    self.window:Subscribe( "WindowClosed", self, self.Close )

    
    self.ItemsList = SortedList.Create( self.window )
    self.ItemsList:SetSizeRel( Vector2( 1, 0.80 ) )
    self.ItemsList:SetPositionRel( Vector2( 0, 0))
    self.ItemsList:AddColumn( "Nom" )
    self.ItemsList:AddColumn( "Description" )
    self.ItemsList:AddColumn( "Prix" )
    self.ItemsList:SetButtonsVisible( true )

    self.Items = {}

    for i = 1,#PanauLife.Config.Restaurant do
            local item = self.ItemsList:AddItem( tostring(i) )
            item:SetCellText( 0, PanauLife.Config.Restaurant[i].DispName )
            item:SetCellText( 1, PanauLife.Config.Restaurant[i].Description)
            item:SetCellText( 2, tostring(PanauLife.Config.Restaurant[i].Prix).." $")
            self.Items[i] = item
            item:SetVisible( true )
    end

    self.UseButton = Button.Create( self.window )
    self.UseButton:SetSizeRel( Vector2(1, 0.1) )
    self.UseButton:SetPositionRel( Vector2( 0, 0.85) )
    self.UseButton:SetText("Manger")
    self.UseButton:Subscribe( "Press", self, self.EatItem )

    Events:Subscribe( "Render", self, self.Render )
    Events:Subscribe( "LocalPlayerInput", self, self.LocalPlayerInput )
end

function MenuRestaurant:EatItem()
    local SelectedRow = self.ItemsList:GetSelectedRow()
    local SelectedId = 0
    for i = 1,#PanauLife.Config.Restaurant do
            if PanauLife.Config.Restaurant[i].DispName == SelectedRow:GetCellText(0) then
                SelectedId = i
                break
            end
    end
    if LocalPlayer:GetMoney() >= PanauLife.Config.Restaurant[SelectedId].Prix then
        Network:Send("ClientBuyFoodInRestaurant", tostring(SelectedId))
    end
end

function MenuRestaurant:GetActive()
    return self.active
end

function MenuRestaurant:SetActive( active )
    if self.active ~= active then
        if active == true and LocalPlayer:GetWorld() ~= DefaultWorld then
            Chat:Print( "You are not in the main world!", Color( 255, 0, 0 ) )
            return
        end

        self.active = active
        Mouse:SetVisible( self.active )
    end
end

function MenuRestaurant:Render()
    local is_visible = self.active and (Game:GetState() == GUIState.Game)
    if self.window:GetVisible() ~= is_visible then
        self.window:SetVisible( is_visible )
    end

    if self.active then
        Mouse:SetVisible( true )
    end
end

function MenuRestaurant:LocalPlayerInput( args )
    if self.active and Game:GetState() == GUIState.Game then
        return false
    end
end


function MenuRestaurant:Close( args )
    self:SetActive( false )
end

PanauGUI.MenuRestaurant = MenuRestaurant()