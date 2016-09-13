class("Panaulife_Database")

function Panaulife_Database:__init() end

function Panaulife_Database:query(query, binds)
  local data = {}

  query = SQL:Query(query)
  if binds then
    for param, value in pairs(binds) do
      query:Bind(param, value)
    end
  end
  query = query:Execute()

  if #query == 0 then
    return false
  end

  for _, row in ipairs(query) do
    table.insert(data, {})

    for key, value in pairs(row) do
      if tonumber(value) then
        value = tonumber(value)
      end
      data[#data][key] = value
    end
  end

  if #data == 1 then
    return data[1]
  end
  return data
end

function Panaulife_Database:execute(query, binds)
  query = SQL:Command(query)
  if binds then
    for param, value in pairs(binds) do
      query:Bind(param, value)
    end
  end
  query = query:Execute()
end

Panaulife.Database = Panaulife_Database()