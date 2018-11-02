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

class("InventoryMenu")
function InventoryMenu:__init()
    self.active = false

    self.window = Window.Create()
    self.window:SetSizeRel( Vector2( 0.3, 0.5 ) )
    self.window:SetPositionRel( Vector2( 0.75, 0.5 ) - self.window:GetSizeRel()/2 )
    self.window:SetVisible( self.active )
    self.window:SetTitle( "Menu Personnage" )
    self.window:Subscribe( "WindowClosed", self, self.Close )

    self.TabControl = TabControl.Create( self.window )
    self.TabControl:SetDock( GwenPosition.Fill )

    -- INFO MENU --
    self.InfoBase = BaseWindow.Create( self.window )
    self.InfoBase:SetDock( GwenPosition.Bottom )
    self.InfoBase:SetSizeRel( Vector2( 1, 1 ) )

    self.MoneyLabel = Label.Create(self.InfoBase)
    self.MoneyLabel:SetSizeRel( Vector2( 0.5, 0.2 ))
    self.MoneyLabel:SetPositionRel( Vector2( 0, 0.01))

    self.AccountLabel = Label.Create(self.InfoBase)
    self.AccountLabel:SetSizeRel( Vector2( 0.5, 0.05 ))
    self.AccountLabel:SetPositionRel( Vector2( 0.5, 0.01))

    self.SuicideButton = Button.Create(self.InfoBase)
    self.SuicideButton:SetSizeRel( Vector2(0.3,0.05))
    self.SuicideButton:SetPositionRel( Vector2(0.65,0.80))
    self.SuicideButton:SetText("Se suicider")
    self.SuicideButton:Subscribe( "Press", self, self.Suicide )

    -- INVENTORY MENU --
    self.OldInventory = ""
    self.InventoryBase = BaseWindow.Create( self.window )
    self.InventoryBase:SetDock( GwenPosition.Bottom )
    self.InventoryBase:SetSizeRel( Vector2( 1, 1 ) )

    self.ItemList = SortedList.Create( self.InventoryBase )
    self.ItemList:SetMargin( Vector2( 0, 0 ), Vector2( 0, 0 ) )
    self.ItemList:SetSizeRel( Vector2(1,0.8))
    self.ItemList:AddColumn( "Nom" )
    self.ItemList:AddColumn( "Quantité" )
    self.ItemList:SetButtonsVisible( true )

    self.InventoryUseButton = Button.Create(self.InventoryBase)
    self.InventoryUseButton:SetSizeRel( Vector2(0.25,0.05))
    self.InventoryUseButton:SetPositionRel( Vector2(0.0625,0.825))
    self.InventoryUseButton:SetText("Utiliser")
    self.InventoryUseButton:Subscribe( "Press", self, self.UseItem )

    self.InvetoryDestroyButton = Button.Create(self.InventoryBase)
    self.InvetoryDestroyButton:SetSizeRel( Vector2(0.25,0.05))
    self.InvetoryDestroyButton:SetPositionRel( Vector2(0.375,0.825))
    self.InvetoryDestroyButton:SetText("Détruire")
    self.InvetoryDestroyButton:Subscribe( "Press", self, self.DestroyItem )

    self.InventoryGiveButton = Button.Create(self.InventoryBase)
    self.InventoryGiveButton:SetSizeRel( Vector2(0.25,0.05))
    self.InventoryGiveButton:SetPositionRel( Vector2(0.6875,0.825))
    self.InventoryGiveButton:SetText("Donner")
    --self.InventoryGiveButton:Subscribe( "Press", self, self.Suicide )


    self.Items = {}

    -- VEICULE MENU  --
    self.OldVehicles = {}
    self.VehiculeBase = BaseWindow.Create( self.window )
    self.VehiculeBase:SetDock( GwenPosition.Bottom )
    self.VehiculeBase:SetSizeRel( Vector2( 1, 1 ) )

    self.VehiculeList = SortedList.Create( self.VehiculeBase )
    self.VehiculeList:SetDock( GwenPosition.Fill )
    self.VehiculeList:SetMargin( Vector2( 4, 4 ), Vector2( 4, 0 ) )
    self.VehiculeList:AddColumn( "Nom" )
    self.VehiculeList:AddColumn( "Capacité" )
    self.VehiculeList:AddColumn( "Distance" )
    self.VehiculeList:AddColumn( "Vérouillé" )
    self.VehiculeList:SetButtonsVisible( true )

    self.Vehicles = {}

    self.InfoButton = TabControl.AddPage(self.TabControl,"  Infos  ",self.InfoBase)
    self.InventoryButton = TabControl.AddPage(self.TabControl,"  Inventaire  ",self.InventoryBase)
    self.VehicleButton = TabControl.AddPage(self.TabControl,"  Véhicules  ", self.VehiculeBase)
    self.VehicleButton = TabControl.AddPage(self.TabControl,"  Options  ")

    Events:Subscribe( "Render", self, self.Render )
    Events:Subscribe( "KeyUp", self, self.KeyUp )
    Events:Subscribe( "LocalPlayerInput", self, self.LocalPlayerInput )
end

function InventoryMenu:GetActive()
    return self.active
end

function InventoryMenu:DestroyItem()
    local SelectedRow = self.ItemList:GetSelectedRow()
    Network:Send("ClientDestroyedItem", SelectedRow:GetCellText(0))
end

function InventoryMenu:UseItem()
    local SelectedRow = self.ItemList:GetSelectedRow()
    Network:Send("ClientUseItem", SelectedRow:GetCellText(0))
end

function InventoryMenu:Suicide()
    Network:Send("PlayerSuicide", "Suicide")
end

function InventoryMenu:SetActive( active )
    if self.active ~= active then
        if active == true and LocalPlayer:GetWorld() ~= DefaultWorld then
            Chat:Print( "You are not in the main world!", Color( 255, 0, 0 ) )
            return
        end

        self.active = active
        Mouse:SetVisible( self.active )
    end
end

function InventoryMenu:Render()
    local is_visible = self.active and (Game:GetState() == GUIState.Game)

    if self.window:GetVisible() ~= is_visible then
        self.window:SetVisible( is_visible )
    end

    if self.active then
        Mouse:SetVisible( true )
    end

    if UserLoaded then
        self.MoneyLabel:SetText("Argent : "..tostring(LocalPlayer:GetMoney()).." $")
        self.AccountLabel:SetText("Compte en banque : "..tostring(User.user_account).." $")

        if User.user_items != self.OldInventory then
            self.OldInventory = User.user_items
            local items = User.user_items:split("/")
            self.ItemList:Clear()
            for i = 1,#items do
                local item = self.ItemList:AddItem( items[i] )
                local UnderItems = items[i]:split("*")
                for i = 1,#UnderItems do
                    item:SetCellText( i-1, UnderItems[i] )
                end
                self.Items[i] = item
                item:SetVisible( true )
            end
        end
        local bVehicleUpdated = false
        for i = 1,#User.vehicles do
            if self.OldVehicles[i] ~= User.vehicles[i] then
                bVehicleUpdated = true
                self.OldVehicles = User.vehicles
                self.VehiculeList:Clear()
            end
        end
        if bVehicleUpdated then
            for i = 1,#User.vehicles do
                local item = self.VehiculeList:AddItem( tostring(User.vehicles[i]) )
                item:SetCellText( 0, "Voiture1" )
                item:SetCellText( 1, tostring(User.vehicles[i].vehicle_capacity))
                item:SetCellText( 2, tostring(math.abs(math.sqrt(math.pow(LocalPlayer:GetPosition().x - User.vehicles[i].vehicle_posx,2) + math.pow(LocalPlayer:GetPosition().y - User.vehicles[i].vehicle_posy,2) + math.pow(LocalPlayer:GetPosition().z - User.vehicles[i].vehicle_posz,2)))))
                item:SetCellText( 3, tostring(User.vehicles[i].vehicle_locked))
                self.Vehicles[i] = item
            end
        end
        UserLoaded = false
    end
    for i = 1,#User.vehicles do
            local item = self.Vehicles[i]
            if item then
                item:SetCellText( 2, tostring(math.abs(math.sqrt(math.pow(LocalPlayer:GetPosition().x - User.vehicles[i].vehicle_posx,2) + math.pow(LocalPlayer:GetPosition().y - User.vehicles[i].vehicle_posy,2) + math.pow(LocalPlayer:GetPosition().z - User.vehicles[i].vehicle_posz,2)))))
                item:SetCellText( 3, tostring(User.vehicles[i].vehicle_locked))
            end
    end
end

function InventoryMenu:KeyUp( args )
    if args.key == string.byte('I') then
        self:SetActive( not self:GetActive() )
    end
end

function InventoryMenu:LocalPlayerInput( args )
    if self.active and Game:GetState() == GUIState.Game then
        return false
    end
end


function InventoryMenu:Close( args )
    self:SetActive( false )
end

PanauGUI.InventoryMenu = InventoryMenu()