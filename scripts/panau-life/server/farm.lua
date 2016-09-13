
class("UserFarm")

function UserFarm:__init(player)
  self.player = player
end

function lines(str)
  local t = {}
  local function helper(line) table.insert(t, line) return "" end
  helper((str:gsub("(.-),", helper)))
  return t
end

function UserFarm:perdreitem(item_name, number_lose)
  local x = 1
    while Inventory[x] ~= nil do
      if tostring(Inventory[x]) == item_name then
        local Inventory_Number = multiplier(tostring(Inventory[x]))
        local Inventory_Number_Calcul = tonumber(Inventory_Number[2]) - number_lose
        if Inventory_Number_Calcul == 0 then
          self.player:SendChatMessage("L'objet "..tostring(Inventory[x]).." a été détruit", Color(0,0,0))
          table.remove(Inventory, x)
          return
        else
        Inventory_Number[2] = tostring(Inventory_Number_Calcul)
        Inventory[x] = table.concat( Inventory_Number, "*" )
        self.player:SendChatMessage("Vous avez perdu "..number_lose.." "..tostring(Inventory[x]).."", Color(0,0,0))
        end
      end
      x = x + 1
    end
end

function UserFarm:add_item(item_name, number_add)
  local x = 1
    while Inventory[x] do
      local Inventory_Number = multiplier(tostring(Inventory[x]))
      if Inventory_Number[1] == item_name then
        if Inventory_Number[2] then
          local Inventory_Number_Calcul = tonumber(Inventory_Number[2]) + number_add
          Inventory_Number[2] = tostring(Inventory_Number_Calcul)
          Inventory[x] = table.concat( Inventory_Number, "*" )
          self.player:SendChatMessage("Vous avez gagnez "..number_add.." "..tostring(Inventory[x]).."", Color(0,0,0))
          return
        end

      end
       --[[ elseif multiplier(tostring(Inventory[x])) ~= nil then
          local Inventory_Number = multiplier(tostring(Inventory[x]))
          if tostring(Inventory_Number[1]) == item_name then
          Inventory_Number[2] = tostring(Inventory_Number_Calcul)
          Inventory[x] = table.concat( Inventory_Number, "*" )
          self.player:SendChatMessage("Vous avez gagnez "..number_add.." "..tostring(Inventory[x]).."", Color(0,0,0))
          return
          end
        end--]]
      x = x + 1
    end
    self.player:SendChatMessage("Vous avez gagnez "..number_add.." "..item_name.."", Color(0,0,0))
    table.insert(Inventory, ""..item_name.."*"..number_add.."")
    return
  end

function multiplier(str)
  if str == nil then
    return false
  end
  local t = {}
  local function helper(line) table.insert(t, line) return "" end
  helper((str:gsub("(.-)*", helper)))
  return t
end

function UserFarm:verif_zone_exsist(zone_name)
local data = Panaulife.Database:query([[
    SELECT  name, prix
    FROM    zones
    WHERE   name = :name
    LIMIT   1
  ]], {
    [":name"] = zone_name
  })

  if not data then
    return false
  end


  return true
end

function UserFarm:verif_zone(zone_name,player)
local data = Panaulife.Database:query([[
    SELECT  pos_x_1, pos_x_2, pos_z_1, pos_z_2
    FROM    ]]..zone_name..[[
  ]], {
  })

  if not data then
  end
  
  print(data[2])
  local x = 1
  while data[x] do
    if player:GetPosition().x >= tonumber(data[x].pos_x_1) and player:GetPosition().z <= tonumber(data[x].pos_z_1) and player:GetPosition().x <= tonumber(data[x].pos_x_2) and player:GetPosition().z >= tonumber(data[x].pos_z_2) then
      self:add_item(zone_name, 1)
      return true
    end
  end
  return false
end