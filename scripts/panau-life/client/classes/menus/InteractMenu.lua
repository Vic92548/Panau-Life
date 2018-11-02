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

class("ActionMenu")
function ActionMenu:__init()
    Events:Subscribe( "KeyUp", self, self.KeyUp )
end

function ActionMenu:KeyUp( args )
    if args.key == string.byte('F') then
        for Index, Value in pairs( BuildingsList ) do
            if math.abs(math.sqrt(math.pow(LocalPlayer:GetPosition().x - BuildingsList[Index].building_posx,2) + math.pow(LocalPlayer:GetPosition().y - BuildingsList[Index].building_posy,2) + math.pow(LocalPlayer:GetPosition().z - BuildingsList[Index].building_posz,2))) <= BuildingsList[Index].building_radius then
                if tostring(BuildingsList[Index].building_type) == "restaurant" then
                    print("C'est un restaurant")
                    PanauGUI.MenuRestaurant:SetActive( not PanauGUI.MenuRestaurant:GetActive(), BuildingsList[Index] )
                elseif tostring(BuildingsList[Index].building_type) == "garage" then
                    if LocalPlayer:InVehicle() then
                      PanauGUI.MenuGarage:SetActive( not PanauGUI.MenuGarage:GetActive(), BuildingsList[Index] )
                    else
                      Chat:Print("Vous devez être dans un véhicule pour utiliser un garage!", Color(250,0,0))
                    end
                elseif tostring(BuildingsList[Index].building_type) == "cardealer" then
                    if LocalPlayer:InVehicle() then
                      Chat:Print("Vous devez être a pied pour utiliser un concéssionaire!", Color(250,0,0))
                    else
                      PanauGUI.MenuCarDealer:SetActive( not PanauGUI.MenuCarDealer:GetActive(), BuildingsList[Index] )
                    end
                elseif tostring(BuildingsList[Index].building_type) == "cloth" then
                    if LocalPlayer:InVehicle() then
                      Chat:Print("Vous devez être a pied pour acheter des vêtements!", Color(250,0,0))
                    else
                      PanauGUI.MenuCloth:SetActive( not PanauGUI.MenuCloth:GetActive(), BuildingsList[Index] )
                    end
                elseif tostring(BuildingsList[Index].building_type) == "champ" then
                    if LocalPlayer:InVehicle() then
                      Chat:Print("Vous devez être a pied rammasser!", Color(250,0,0))
                    else
                      PanauGUI.MenuChamp:SetActive( not PanauGUI.MenuChamp:GetActive(), PanauLife.Config.Champs_Items[BuildingsList[Index].building_items] )
                    end
                end
                break
            end
        end
    elseif args.key == string.byte('C') then
      local vehicle = LocalPlayer:GetAimTarget().entity
      if vehicle then
        PanauGUI.CarMenu:SetActive( not PanauGUI.CarMenu:GetActive(), vehicle )
      end
    end
end

PanauGUI.ActionMenu = ActionMenu()