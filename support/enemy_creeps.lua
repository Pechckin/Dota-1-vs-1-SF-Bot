
local constants = require(
  GetScriptDirectory() .."/support/constants")

local functions = require(
  GetScriptDirectory() .."/support/functions")

local C = {}
C.Creep = {}

C.Creeps = {
    [C.Creep] = {
        current_health = 0,
        max_health = 0,
      },
}



function C.GetCreeps()
  local creeps = GetUnitList(UNIT_LIST_ENEMY_CREEPS)
  if creeps ~= nil then
      return creeps
  end
  return nil
end   

function C.UpdateData(creeps)
   C.count = #creeps
   for i = 1,#creeps do
     table.insert(C.Creeps,creeps[i])
     print(creeps[i]:GetHealth())
   end
end   



function C.UpdateCreeps()
   local creeps = C.GetCreeps()
   if creeps ~= nil then 
        C.UpdateData(creeps)
   end     
end   


return C

