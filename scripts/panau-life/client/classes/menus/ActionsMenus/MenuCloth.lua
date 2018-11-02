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

class("MenuCloth")
function MenuCloth:__init()
    self.active = false
    self.loaded = true
    self.window = Window.Create()
    self.window:SetSizeRel( Vector2( 0.3, 0.5 ) )
    self.window:SetPositionRel( Vector2( 0.75, 0.5 ) - self.window:GetSizeRel()/2 )
    self.window:SetVisible( self.active )
    self.window:SetTitle( "Garage" )
    self.window:Subscribe( "WindowClosed", self, self.Close )

    
    self.ItemsList = SortedList.Create( self.window )
    self.ItemsList:SetSizeRel( Vector2( 1, 0.80 ) )
    self.ItemsList:SetPositionRel( Vector2( 0, 0))
    self.ItemsList:AddColumn( "Nom" )
    self.ItemsList:AddColumn( "Prix" )
    self.ItemsList:SetButtonsVisible( true )

    self.Items = {}


    

    self.UseButton = Button.Create( self.window )
    self.UseButton:SetSizeRel( Vector2(1, 0.1) )
    self.UseButton:SetPositionRel( Vector2( 0, 0.85) )
    self.UseButton:SetText("Acheter")
    self.UseButton:Subscribe( "Press", self, self.Buy )

    Events:Subscribe( "Render", self, self.Render )
    Events:Subscribe( "LocalPlayerInput", self, self.LocalPlayerInput )
end

function MenuCloth:Buy()
    local SelectedRow = self.ItemsList:GetSelectedRow()
    local SelectedId = 0
    for k, v in pairs( PanauLife.Config.Cloth_Items[self.ClothId] ) do
        if k == SelectedRow:GetCellText(0) then
            SelectedId = k
            break
        end
    end
    if LocalPlayer:GetMoney() >= PanauLife.Config.Cloth_Items[self.ClothId][SelectedId].Prix then
        Network:Send("ClientBuyCloth", {Id = SelectedId, Garage = self.ClothId})
        self:SetActive(false, nil)
        Game:ShowPopup("Vous venez d'acheter les vêtements "..SelectedId.." pour "..PanauLife.Config.Cloth_Items[self.ClothId][SelectedId].Prix.."$", false)
    end
end

function MenuCloth:GetActive()
    return self.active
end

function MenuCloth:SetActive( active,building )
    if self.active ~= active then
        if active == true and LocalPlayer:GetWorld() ~= DefaultWorld then
            Chat:Print( "You are not in the main world!", Color( 255, 0, 0 ) )
            return
        end

        if building ~= nil then
            self.ClothId = building.building_items
            self.ItemsList:Clear()
            self.window:SetTitle(self.ClothId)
            for k, v in pairs( PanauLife.Config.Cloth_Items[self.ClothId] ) do
                local item = self.ItemsList:AddItem( k )
                item:SetCellText( 0, k )
                item:SetCellText( 1, tostring(PanauLife.Config.Cloth_Items[self.ClothId][k].Prix).." $")
                self.Items[k] = item
                item:SetVisible( true )
            end
        end
        self.active = active
        Mouse:SetVisible( self.active )
    end
end

function MenuCloth:Render()
    local is_visible = self.active and (Game:GetState() == GUIState.Game)
    if self.window:GetVisible() ~= is_visible then
        self.window:SetVisible( is_visible )
    end

    if self.active then
        Mouse:SetVisible( true )
    end
end

function MenuCloth:LocalPlayerInput( args )
    if self.active and Game:GetState() == GUIState.Game then
        return false
    end
end


function MenuCloth:Close( args )
    self:SetActive( false )
end

PanauGUI.MenuCloth = MenuCloth()