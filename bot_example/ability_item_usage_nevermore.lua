local courier = require(
  GetScriptDirectory() .."/support/courier")
local heal = require(
  GetScriptDirectory() .."/support/heal")
local skill_build = require(
  GetScriptDirectory() .."/database/skill_build")
local items = require(
  GetScriptDirectory() .."/support/items")

-------------------------------------------------------------------------------
local npcBot = GetBot()
local frame_ItemUsageThink = 0
local frame_AbilityUsageThink = 0
local frame_AbilityLevelUpThink = 0
local frame_CourierUsageThink = 0


function ItemUsageThink()
               frame_ItemUsageThink = frame_ItemUsageThink + 1
                if frame_ItemUsageThink % 10 == 0 then 
                  heal.Process()
                  if frame_ItemUsageThink % 250 == 0 then 
                    items.UpdateInventory()
                  end   
                end 
end



function AbilityLevelUpThink() -- прокачка способностей
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



