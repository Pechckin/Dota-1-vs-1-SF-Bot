local items_to_buy = require(
  GetScriptDirectory() .."/database/items_to_buy")
local sf_enemy = require(
 GetScriptDirectory() .."/support/sf_enemy")
local sf_ally = require(
 GetScriptDirectory() .."/support/sf_ally")
local frame = 0

function GetDesire()
  frame = frame + 1
  if frame % 5 == 0 then
    local enemy = sf_enemy.GetSF()
    local npcBot = sf_ally.GetSF()
    local enemy_power = 0
    if enemy then 
       enemy_power = enemy:GetRawOffensivePower()
    end   
    local bot_power = npcBot:GetRawOffensivePower()
    
    if bot_power > enemy_power and enemy_power > 0 then
      return 0.5
    else
      return 0.1
    end  
  end  
  
end  


function OnStart()
  local enemy = sf_enemy.GetSF()
  local npcBot = sf_ally.GetSF()
  npcBot:Action_AttackUnit(enemy,true)
end  