
local constants = require(
  GetScriptDirectory() .."/support/constants")

local functions = require(
  GetScriptDirectory() .."/support/functions")

local SF = {}
SF.flag = false
SF.SF = 0
SF.current_health = 0;
SF.max_health = 0;
SF.current_mana = 0;
SF.max_mana = 0;
SF.location = 0;




function SF.GetSF()
  if SF.flag == false then 
    SF.SF = GetBot()
    SF.flag = true
  end  
  return GetBot()
end   

function SF.UpdateData(sf)
   SF.current_health = sf:GetHealth()
   SF.max_health = sf:GetMaxHealth()
   SF.current_mana = sf:GetMana()
   SF.max_mana = sf:GetMaxMana()
   SF.location = sf:GetLocation()
end   

function SF.ShowData()
   print(SF.current_health,'  current_health') 
   print(SF.max_health, '  max_health' )
   print(SF.current_mana, ' current_mana' )
   print(SF.max_mana,  ' max_mana' )
   print(SF.location , ' location')
end 

function SF.UpdateSF()
   local sf = SF.GetSF()
   if sf ~= nil then 
        SF.UpdateData(sf)
   end     
end   


return SF

