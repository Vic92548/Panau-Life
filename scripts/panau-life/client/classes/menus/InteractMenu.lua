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
    if args.key == string.byte('X') then
        for Index, Value in pairs( BuildingsList ) do
            if math.abs(math.sqrt(math.pow(LocalPlayer:GetPosition().x - BuildingsList[Index].building_posx,2) + math.pow(LocalPlayer:GetPosition().y - BuildingsList[Index].building_posy,2) + math.pow(LocalPlayer:GetPosition().z - BuildingsList[Index].building_posz,2))) <= BuildingsList[Index].building_radius then
                if tostring(BuildingsList[Index].building_type) == "restaurant" then
                    print("C'est un restaurant")
                    PanauGUI.MenuRestaurant:SetActive( not PanauGUI.MenuRestaurant:GetActive() )
                else
                    print("Ce n'est pas un restaurant")
                end
                break
            end
        end
    end
end

PanauGUI.ActionMenu = ActionMenu()