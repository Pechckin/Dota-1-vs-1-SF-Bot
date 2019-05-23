local constants = require(
  GetScriptDirectory() .."/support/constants")

local M = {}


function M.ternary(condition, a, b)
  if condition then
    return a
  else
    return b
  end
end


function M.spairs(t, order)
    local keys = {}
    for k in pairs(t) do keys[#keys+1] = k end
    if order ~= nil then
        table.sort(keys, function(a,b) return order(t, a, b) end)
    else
        table.sort(keys)
    end

 
    local i = 0
    return function()
        i = i + 1
        if keys[i] then
            return keys[i], t[keys[i]]
        end
    end
end


function M.GetElementWith(list, compare_function, validate_function)

  for _, element in M.spairs(list, compare_function) do
    if validate_function == nil or validate_function(element) then
      return element
    end
  end

  return nil
end




function M.DoWithKeysAndElements(list, do_function)
  for key, element in pairs(list) do
    do_function(key, element)
  end
end



function M.ClearTable(table)
  for i = 1, #table do
    table.remove(table, i)
  end
end



return M
