local items_to_buy = require(
  GetScriptDirectory() .."/database/items_to_buy")
local sf_enemy = require(
 GetScriptDirectory() .."/support/sf_enemy")
local sf_ally = require(
 GetScriptDirectory() .."/support/sf_ally")
local attack = require(
 GetScriptDirectory() .."/support/attack")
local frame = 0
local npcBot = GetBot()
local tower = GetTower( TEAM_RADIANT, TOWER_MID_1)


function GetDesire()
  frame = frame + 1
  local target = tower:GetAttackTarget()
  if target ~= nil then
          return 0.4
  end    
  return 0
end  
