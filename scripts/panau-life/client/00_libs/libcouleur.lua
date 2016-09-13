Class("Couleur")

Couleur.Color = "#Color(%i, %i, %i, %i)"

function Couleur:__init(text, size, scale)
  scale = scale and scale or 1

  self.size = size
  self.scale = scale
  self.elements = self:Parse(text)
end

function Couleur:Parse(text, size, scale)
  local elements = {}
end

function Couleur:SetColor(r, g, b, a)
  a = a and a or 255
  return self.Color:format(r, g, b, a)
end

function Couleur:DrawText(pos, text, size, scale)
  for _, el in ipairs(self:Parse(text, size, scale)) do
    Render:DrawText(pos, el.text, el.color, size, scale)
    pos = pos+Vector2(Render:GetTextWidth(el.text, size, scale))
  end
end

function Couleur:GetTextWidth(text, size, scale)
  local width = 0
  for _, el in ipairs(self:Parse(text, size, scale)) do
    width = width+Render:GetTextWidth(text, size, scale)
  end

  return width
end

function Couleur:GetTextHeight(text, size, scale)
  return Render:GetTextHeight(text, size, scale)
end

function Couleur:GetTextSize(text, size, scale)
  return Vector2(self:GetTextWidth(text, size, scale), self:GetTextHeight(text, size, scale))
end

Render.Couleur = Couleur()