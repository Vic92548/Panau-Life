local RemainingTime = nil
local MaxTime = nil
local GatherValue = 0
local Champ = nil
local CurrentChampSetActive = nil

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

class("MenuChamp")
function MenuChamp:__init()
    self.active = false
    self.loaded = true

    self.GatherValue = 0
    self.GatherSpeed = 0.005
    self.GatherBar = ProgressBar.Create("GatherBar")
    self.GatherBar:SetValue(0)
    self.GatherBar:SetSizeRel( Vector2( 0.4, 0.05 ) )
    self.GatherBar:SetPositionRel( Vector2( 0.3, 0.475 ) )

    Events:Subscribe( "Render", self, self.Render )
    Events:Subscribe( "LocalPlayerInput", self, self.LocalPlayerInput )
end

function MenuChamp:GetActive()
    return self.active
end


function MenuChamp:SetActive( active,champ )
    if self.active ~= active then
        if active == true and LocalPlayer:GetWorld() ~= DefaultWorld then
            Chat:Print( "You are not in the main world!", Color( 255, 0, 0 ) )
            return
        end

        self.active = active
        if self.active then
            if champ then
                Champ = champ
                RemainingTime = champ.Time
                MaxTime = champ.Time
                GatherValue = 0
            end
        end
    end
end

function MenuChamp:Render()
    local is_visible = self.active and (Game:GetState() == GUIState.Game)
    if self.GatherBar:GetVisible() ~= is_visible then
        self.GatherBar:SetVisible( is_visible )
    end
    
    if is_visible then
        RemainingTime = RemainingTime - Client:GetFrameTime()
        GatherValue = 1 - RemainingTime / MaxTime
        if RemainingTime <= 0 then
            gatheredItem = nil
            while gatheredItem == nil do
                for k,v in pairs(Champ.Items) do
                    if(math.random() <= v.Chance) then
                        gatheredItem = k
                        break
                    end
                end
            end
            self:SetActive(false,nil)
            Network:Send("ClientGather", gatheredItem)
            Game:ShowPopup("Vous venez de ramasser "..gatheredItem, false)
        end
        self.GatherBar:SetValue(GatherValue)
    end
end

function MenuChamp:LocalPlayerInput( args )
    if self.active and Game:GetState() == GUIState.Game then
        return false
    end
end

PanauGUI.MenuChamp = MenuChamp()