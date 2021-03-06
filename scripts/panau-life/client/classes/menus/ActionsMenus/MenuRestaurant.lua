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
    self.RestaurantId = 1;
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
    for k, v in pairs( PanauLife.Config.Restaurant_Items[self.RestaurantId] ) do
        if k == SelectedRow:GetCellText(0) then
            SelectedId = k
            break
        end
    end
    if LocalPlayer:GetMoney() >= PanauLife.Config.Restaurant_Items[self.RestaurantId][SelectedId].Prix then
        Network:Send("ClientBuyFoodInRestaurant", {Id = SelectedId, Restaurant = self.RestaurantId})
        Game:ShowPopup("Vous venez de manger "..SelectedId.." pour "..PanauLife.Config.Restaurant_Items[self.RestaurantId][SelectedId].Prix.."$", false)
    end
end

function MenuRestaurant:GetActive()
    return self.active
end

function MenuRestaurant:SetActive( active,building )
    if self.active ~= active then
        if active == true and LocalPlayer:GetWorld() ~= DefaultWorld then
            Chat:Print( "You are not in the main world!", Color( 255, 0, 0 ) )
            return
        end

        if building ~= nil then
            self.RestaurantId = building.building_items
            self.ItemsList:Clear()
            self.window:SetTitle(self.RestaurantId)
            for k, v in pairs( PanauLife.Config.Restaurant_Items[self.RestaurantId] ) do
                local item = self.ItemsList:AddItem( k )
                item:SetCellText( 0, k )
                item:SetCellText( 1, PanauLife.Config.Restaurant_Items[self.RestaurantId][k].Description)
                item:SetCellText( 2, tostring(PanauLife.Config.Restaurant_Items[self.RestaurantId][k].Prix).." $")
                self.Items[k] = item
                item:SetVisible( true )
            end
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