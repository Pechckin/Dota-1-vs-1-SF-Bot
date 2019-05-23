
local constants = require(
  GetScriptDirectory() .."/support/constants")
local functions = require(
  GetScriptDirectory() .."/support/functions")
local sf_enemy = require(
 GetScriptDirectory() .."/support/sf_enemy")
local sf_ally = require(
 GetScriptDirectory() .."/support/sf_ally")

local A = {}
A.SD3 = true
A.SD2 = true

function A.Check_Enemy()
  local target = sf_enemy.GetSF()
  if target ~= nil then 
      return true
  else
    return false
  end
end

function A.Distance_To_Target(target)
  local bot = sf_ally.GetSF()
  return GetUnitToUnitDistance( bot, target )
end

function A.Enemy_in_Use_Shadowraze_1_radius(target)
    local bot = sf_ally.GetSF()
    local ability = bot:GetAbilityByName("nevermore_shadowraze1")
    local distance = A.Distance_To_Target(target)
    local range = ability:GetCastRange()
    if math.abs(distance - range) <= 125 then
      return true
     else
       return false
    end   
end
function A.Enemy_in_Use_Shadowraze_2_radius(target)
    local bot = sf_ally.GetSF()
    local ability = bot:GetAbilityByName("nevermore_shadowraze2")
    local distance = A.Distance_To_Target(target)
    local range = ability:GetCastRange()
    if math.abs(distance - range) <= 125 then
      return true
     else
       return false
    end   
end
function A.Enemy_in_Use_Shadowraze_3_radius(target)
    local bot = sf_ally.GetSF()
    local ability = bot:GetAbilityByName("nevermore_shadowraze3")
    local distance = A.Distance_To_Target(target)
    local range = ability:GetCastRange()
     if math.abs(distance - range) <= 125 then
      return true
     else
       return false
    end   
end

function A.Get_Shadowraze_1()
   local bot = sf_ally.GetSF()
   return bot:GetAbilityByName("nevermore_shadowraze1")
  end
  
  function A.Get_Shadowraze_2()
   local bot = sf_ally.GetSF()
   return bot:GetAbilityByName("nevermore_shadowraze2")
  end
  
  function A.Get_Shadowraze_3()
   local bot = sf_ally.GetSF()
   return bot:GetAbilityByName("nevermore_shadowraze3")
  end
  function A.Get_Shadowraze_damage()
   local bot = sf_ally.GetSF()
   local Shadowraze =  bot:GetAbilityByName("nevermore_shadowraze1")
   local level = Shadowraze:GetLevel()
   if level> 0 then 
      return constants.Shadowraze_Damage[level]
   else
     return 0
   end  
  end
  
   function A.Check_Cooldown(ability)
   
   if ability:IsCooldownReady() then 
     return true
   end
   return false
  end
  
  
  

function A.Kill_In_One_Spell(target)
    if A.Check_Enemy() then 
        local damage = A.Get_Shadowraze_damage()
        local hp = target:GetHealth()
        local location = target:GetLocation()
        local bot = sf_ally.GetSF()
        if hp <= damage * 2   then
          if A.Enemy_in_Use_Shadowraze_1_radius(target) then 
            local sd1 = A.Get_Shadowraze_1()
            if A.Check_Cooldown(sd1) == true then 
            bot:Action_AttackMove(location)
            bot:Action_UseAbility(sd1)
            end
          else
                if A.Enemy_in_Use_Shadowraze_2_radius(target) then 
                    local sd2 = A.Get_Shadowraze_2()
                    if A.Check_Cooldown(sd2) == true then 
                    bot:Action_AttackMove(location)
                    bot:Action_UseAbility(sd2)
                    end
                else
                      if A.Enemy_in_Use_Shadowraze_3_radius(target) then 
                            local sd3 = A.Get_Shadowraze_3()
                            if A.Check_Cooldown(sd3) == true then 
                            bot:Action_AttackMove(location)
                            bot:Action_UseAbility(sd3)
                            end
                      end 
              end  
          end
        end 
    end    
end

function A.Good_Combination()
    local bot = sf_ally.GetSF()
    local Shadowraze =  bot:GetAbilityByName("nevermore_shadowraze1")
    local level = Shadowraze:GetLevel()
    if level >= 3 then
          local creeps = bot:GetNearbyCreeps( 1600, true)
          if #creeps >= 4 then 
            
            
            if A.Enemy_in_Use_Shadowraze_3_radius(creeps[1]) then 
              local sd3 = A.Get_Shadowraze_3()
              if A.Check_Cooldown(sd3) == true then 
                bot:Action_AttackMove(creeps[1]:GetLocation())
                bot:Action_UseAbility(sd3)
                A.SD3 = false
              end  
            end 
            if  A.SD3 == false then
              bot:Action_AttackMove(creeps[1]:GetLocation())
              if A.Enemy_in_Use_Shadowraze_2_radius(creeps[1]) then 
                local sd2 = A.Get_Shadowraze_2()
                if A.Check_Cooldown(sd2) == true then 
                    bot:Action_AttackMove(creeps[1]:GetLocation())
                    bot:Action_UseAbility(sd2)
                    A.SD3 = true
                end
              end  
            end 
          end
    end 
 end 
 function A.attack_tower()
   local bot = sf_ally.GetSF()
   local tower = GetTower( TEAM_DIRE, TOWER_MID_1)
   local target = tower:GetAttackTarget()
   local range = bot:GetAttackRange()
   local dist = GetUnitToUnitDistance(bot,tower)
   if dist + 100 <= range then 
     if target ~= bot then 
       bot:Action_AttackMove(tower:GetLocation())
     end
   end 
   
 end  



return A

