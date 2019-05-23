local skill_build = require(
  GetScriptDirectory() .."/database/skill_build")
local items_to_buy = require(
  GetScriptDirectory() .."/database/items_to_buy")
local items = require(
  GetScriptDirectory() .."/support/items")
local constants = require(
  GetScriptDirectory() .."/support/constants")
local all_units = require(
 GetScriptDirectory() .."/support/all_units")
local sf_enemy = require(
 GetScriptDirectory() .."/support/sf_enemy")
local sf_ally = require(
 GetScriptDirectory() .."/support/sf_ally")
local attack = require(
 GetScriptDirectory() .."/support/attack")
local enemy_creeps = require(
 GetScriptDirectory() .."/support/enemy_creeps")
local heal = require(
 GetScriptDirectory() .."/support/heal")
local courier = require(
 GetScriptDirectory() .."/support/courier")
local delay = require(
  GetScriptDirectory() .."/support/delay")
-------------------------------------------------------------------------------
local npcBot = GetBot()
local frame_ItemUsageThink = 0
local frame_AbilityUsageThink = 0
local frame_AbilityLevelUpThink = 0
local frame_CourierUsageThink = 0

function ItemUsageThink()
 frame_ItemUsageThink = frame_ItemUsageThink + 1
 if frame_ItemUsageThink % 5 == 0 then
    heal.Process()
    sf_enemy.UpdateSF()
    sf_ally.UpdateSF()
    if frame_ItemUsageThink % 250 == 0 then 
      items.UpdateInventory()
    end   
  end 

 
   
   local location_bot = npcBot:GetLocation()
   local tower = GetTower( npcBot:GetTeam(), TOWER_MID_1)
   local location_tower = tower:GetLocation()
   local distance = GetUnitToLocationDistance(npcBot,location_tower)
   if (DotaTime() > 100) then 
      if distance > 3000 then 
             print("THIS IS BAD")
             npcBot:Action_MoveDirectly(location_tower)
      end
   end   
end



function AbilityUsageThink()
    frame_AbilityUsageThink = frame_AbilityUsageThink + 1
    if frame_AbilityUsageThink % 5 == 0 then 
      sf_enemy.UpdateSF()
      local enemy = sf_enemy.GetSF()
      attack.Kill_In_One_Spell(enemy)
      attack.attack_tower()
      if enemy then
        if GetUnitToUnitDistance(npcBot,enemy) >= 900 then
          attack.Good_Combination()
        end
      end  
      local action = npcBot:GetCurrentActionType()
      local mode = npcBot:GetActiveMode()
      local tower = GetTower( TEAM_DIRE, TOWER_MID_1)
      local location_tower = tower:GetLocation()
      if action == BOT_ACTION_TYPE_DELAY then 
              npcBot:Action_AttackMove(location_tower)
      end        
    end  
end


function AbilityLevelUpThink()
  frame_AbilityLevelUpThink = frame_AbilityLevelUpThink + 1
  if frame_AbilityLevelUpThink % 25 == 0 then
    if  npcBot:GetAbilityPoints() >= 1 and npcBot:IsAlive() == true   then
        local current_level = npcBot:GetLevel()
        npcBot:ActionImmediate_LevelAbility(skill_build.SKILL_BUILD[current_level])
    end  
  end  
end

-------------------------------------------------------------------------------
function CourierUsageThink()
    frame_CourierUsageThink = frame_CourierUsageThink + 1
    if frame_CourierUsageThink % 25 == 0 then
      courier.Process() 
    end  
end



