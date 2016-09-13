class("PanauLife_Admin")

function PanauLife_Admin:__init() end

function PanauLife_Admin:build(UniqueName, DisplayName, Type, PosX, PosY, PosZ, Radius, Height, Color, Size)
  PanauLife.Database:execute([[
    INSERT
    INTO    ]]..PanauLife.Config.sql.prefix..PanauLife.Config.sql.buildings..[[ (unique_name, display_name, type, pos_x, pos_y, pos_z, radius, name_height, color, size)
    VALUES  (:name, :display, :type, :posx, :posy, :posz, :radius, :height, :color, :size)
  ]], {
    [":name"] = UniqueName,
    [":display"] = DisplayName,
    [":type"] = Type,
    [":posx"] = PosX,
    [":posy"] = PosY,
    [":posz"] = PosZ,
    [":radius"] = Radius,
    [":height"] = Height,
    [":color"] = Color,
    [":size"] = Size
  })
  return "Le batiment a bien été créé"
end

PanauLife.Admin = PanauLife_Admin()
