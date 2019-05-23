local items_to_buy = require(
  GetScriptDirectory() .."/database/items_to_buy")
local constants = require(
  GetScriptDirectory() .."/support/constants")
local attack = require(
  GetScriptDirectory() .."/support/attack")
local sf_enemy = require(
  GetScriptDirectory() .."/support/sf_enemy")
local items = require(
  GetScriptDirectory() .."/support/items")
local delay = require(
  GetScriptDirectory() .."/support/delay")


local M = {}

M.faerie_fire = true
M.flask_mod = false
local npcBot = GetBot()

 function M.Useitem_faerie_fire()
    local current_hp = npcBot:GetHealth()
    if (current_hp <= 100 and M.faerie_fire) or (DotaTime() > 300  and current_hp <= 500 and M.faerie_fire) then 
      local slot = npcBot:FindItemSlot("item_faerie_fire")
      local item = npcBot:GetItemInSlot(slot)
      npcBot:Action_UseAbility(item)
      M.faerie_fire = false
    end
end


 function M.NeedHeal()
   local current_hp = npcBot:GetHealth()
   local max_hp = npcBot:GetMaxHealth()
   local coeff = current_hp / max_hp
   if coeff <= 0.75 then return true
   else
     return false
   end  
end


function M.HaveHealinSlots()
    local items = items.GetItems(npcBot)
    if (npcBot:FindItemSlot("item_tango") ~= -1 and M.Check_item_not_in_stash("item_tango")) or  (npcBot:FindItemSlot("item_flask") ~= -1 and M.Check_item_not_in_stash("item_flask")) then 
        return true
    end
    return false
end


function M.Check_item_in_bot(item)
   if M.Check_item_in_stash(item) and M.Check_item_not_in_stash(item) then 
     return true
    else
      return false
   end
end

function M.Check_item_in_stash(item)
    if npcBot:FindItemSlot(item) >= 6 and npcBot:FindItemSlot(item) <= 8   then 
        return true
    end
    return false
end


function M.Check_item_not_in_stash(item)
    if npcBot:FindItemSlot(item) >= 0 and npcBot:FindItemSlot(item) <= 5   then 
        return true
    end
    return false
end


function M.Get_Save_Zone()
    local tower = GetTower(npcBot:GetTeam(), TOWER_MID_1)
    local location_tower = tower:GetLocation()
    npcBot:Action_MoveDirectly(location_tower)
end

function M.Save_Zone()
    local tower = GetTower(npcBot:GetTeam(), TOWER_MID_1)
    local location_tower = tower:GetLocation()
    local dist = GetUnitToLocationDistance(npcBot, location_tower)
    if dist <= 500 then
      return true
    end  
    return false  
end


function M.Check_flask_Use()
    local enemy = sf_enemy.GetSF()
    if enemy ~= nil then 
        local dist = attack.Distance_To_Target(enemy)
        if  dist >= enemy:GetAttackRange()+100 and dist >= attack.Get_Shadowraze_3():GetCastRange()+50 then return true
            else
                return false
        end
    end
    return false 
end



function M.Useitem_heal()
    local slot_item_tango = npcBot:FindItemSlot("item_tango")
    local slot_item_flask = npcBot:FindItemSlot("item_flask")
    if M.Check_item_not_in_stash("item_tango") and npcBot:HasModifier("modifier_tango_heal") == false then
                M.Get_Save_Zone()
                if M.Save_Zone() then
                  item_item_tango = npcBot:GetItemInSlot(slot_item_tango)
                  local trees = npcBot:GetNearbyTrees(constants.MAX_UNIT_TARGET_RADIUS)
                  npcBot:Action_UseAbilityOnTree(item_item_tango,trees[1])
                end  
    else
          if  npcBot:HasModifier("modifier_flask_healing") == false and npcBot:GetHealth() < 500 then 
              if M.Check_flask_Use() then 
                  item_item_flask = npcBot:GetItemInSlot(slot_item_flask)
                  npcBot:Action_UseAbilityOnEntity(item_item_flask,npcBot)
                else
                  M.Get_Save_Zone()
              end    
          end    
    end
end

function M.Keep_Distance_when_flask_using()
    if npcBot:HasModifier("modifier_flask_healing") then 
        local enemy = sf_enemy.GetSF()
        if enemy ~= nil then 
            local dist = attack.Distance_To_Target(enemy)
            if  dist <= enemy:GetAttackRange() or dist <= attack.Get_Shadowraze_3():GetCastRange() then 
                M.Get_Save_Zone()
            end
        end
    end    
end



function M.Healing_on_line()
    if M.NeedHeal() then 
            M.Keep_Distance_when_flask_using()
            if M.HaveHealinSlots() then 
                      M.Useitem_heal()
            else
              if items_to_buy.ITEMS_TO_BUY[1] ~= "item_flask" and (npcBot:FindItemSlot("item_flask") == -1)  then 
                    table.insert(items_to_buy.ITEMS_TO_BUY,1,"item_flask")
              end    
            end  
    end  
end

function M.UpdateHealPriority()
  local priority = items_to_buy.PRIORITY
  local current_hp = npcBot:GetHealth()
  local max_hp = npcBot:GetMaxHealth()
  local coeff = current_hp / max_hp
  if coeff <= 0.75 and coeff >= 0.5  then 
    priority["item_tango"] = 66
    priority["item_flask"] = 14
  else
    if coeff < 0.5  and priority["item_flask"] ~= 100  then 
      priority["item_tango"] = 66
      priority["item_flask"] = 100
    else
      if coeff > 0.75 then
        priority["item_tango"] = 53
        priority["item_flask"] = 14
      end  
    end  
  end  
end


function M.Get_Wand()
    local slot_item_stick = npcBot:FindItemSlot("item_magic_stick")
    local slot_item_wand = npcBot:FindItemSlot("item_magic_wand")
    if slot_item_stick > 0 then 
      return npcBot:GetItemInSlot(slot_item_stick)
    else
      if 
      slot_item_wand > 0 then 
      return npcBot:GetItemInSlot(slot_item_wand)
    end
  end
  return nil
end

function M.Get_Wand_Charges(wand)
      return wand:GetCurrentCharges()
end


function M.Need_wand()
  local unit = GetBot()
  local wand = M.Get_Wand()
  if wand ~= nil then 
     if M.Critical_Situation() then 
       return true
     end
  end
  return false
end

function M.Use_Wand()
   local wand = M.Get_Wand()
   local bot = GetBot()
   if M.Need_wand() then 
     bot:Action_UseAbility(wand)
   end  
end

function M.Critical_Situation()
    local npcBot = GetBot()
    local enemy = sf_enemy.GetSF()
    local hp = npcBot:GetHealth()
    if enemy ~= nil then 
          local damage_to_bot_in_1 = enemy:GetEstimatedDamageToTarget( true, npcBot, 1, DAMAGE_TYPE_ALL )
          if (damage_to_bot_in_1 >= hp) then 
            return true
          end  
    end
    return false
end



function M.Process()
 M.UpdateHealPriority() 
 M.Useitem_faerie_fire()
 M.Healing_on_line()
 M.Use_Wand()
end


return M