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
--Надо ли хилиться?
 function M.NeedHeal()
   local unit = GetBot()
   local current_hp = unit:GetHealth()
   local max_hp = unit:GetMaxHealth()
   local coeff = current_hp / max_hp
   if coeff <= 0.75 then return true
   else
     return false
   end  
end
--Слоты с хилом
function M.HaveHealinSlots()
    local npcBot = GetBot()
    local items = items.GetItems(npcBot)
    for i = 0, 5, 1 do
      if items[i] ~= nil  and (items[i]:GetName() == "item_tango" or items[i]:GetName() == "item_flask") then 
        return true
      end
    end  
    return false
end

function M.HaveTangoinSlot()
    local npcBot = GetBot()
    local items = items.GetItems(npcBot)
    for i = 0, 5, 1 do
      if items[i] ~= nil  and items[i]:GetName() == "item_tango" then 
        return true
      end
    end  
    return false
end

function M.HaveFlaskinSlot()
    print("WE is the flasck?")
    local npcBot = GetBot()
    local items = items.GetItems(npcBot)
    for i = 0, 5, 1 do
      if items[i] ~= nil  and items[i]:GetName() == "item_flask" then 
        return true
      end
    end  
    return false
end

 --Юзаем фери фаер
 function M.Useitem_faerie_fire()
    local npcBot = GetBot()
    local current_hp = npcBot:GetHealth()
    if (current_hp <= 100 or ( DotaTime() > 300  and current_hp <= 500)) and M.faerie_fire == true then 
      slot = npcBot:FindItemSlot("item_faerie_fire")
      item = npcBot:GetItemInSlot(slot)
      npcBot:Action_UseAbility(item)
      M.faerie_fire = false
    end
end

--Юзаем хилки

function M.Useitem_heal()
    local npcBot = GetBot()
    local slot_item_tango = npcBot:FindItemSlot("item_tango")
    local slot_item_flask = npcBot:FindItemSlot("item_flask")
        if slot_item_tango > 0 and not npcBot:HasModifier("modifier_tango_heal") then 
                M.Get_Save_Zone()
                if M.HaveTangoinSlot() then
                item_item_tango = npcBot:GetItemInSlot(slot_item_tango)
                local trees = npcBot:GetNearbyTrees(constants.MAX_UNIT_TARGET_RADIUS)
                npcBot:Action_UseAbilityOnTree(item_item_tango,trees[1])
                end
        else
          if not npcBot:HasModifier("modifier_flask_healing") and slot_item_flask > 0 and npcBot:GetHealth() < 500 then 
              if M.Check_flask_Use() and M.HaveFlaskinSlot() then 
                  item_item_flask = npcBot:GetItemInSlot(slot_item_flask)
                  npcBot:Action_UseAbilityOnEntity(item_item_flask,npcBot)
              end    
          end    
    end
end


function M.Healing_on_line()
    local npcBot = GetBot()
    if M.NeedHeal() then 
   if M.HaveHealinSlots() then 
       M.Useitem_heal()
   else
      if items_to_buy.ITEMS_TO_BUY[1] ~= "item_flask" and (npcBot:FindItemSlot("item_flask") <= 0  or npcBot:FindItemSlot("item_flask") == nil)  then 
          table.insert(items_to_buy.ITEMS_TO_BUY,1,"item_flask")
      end    
   end  
 end  
end


function M.Get_Save_Zone()
    print("Going to the safe zone")
    local npcBot = GetBot()
    local tower = GetTower( npcBot:GetTeam(), TOWER_MID_1)
    local location_tower = tower:GetLocation()
    npcBot:Action_MoveDirectly(location_tower)
    delay.ActionDelay()
end

function M.Check_flask_Use()
    print("Checking the flask use ability due to enemy location")
    local enemy = sf_enemy.GetSF()
    local dist = attack.Distance_To_Target(enemy)
    if  dist >= enemy:GetAttackRange() and dist >= attack.Get_Shadowraze_3():GetCastRange() then return true
  else
    return false
    end
end

function M.Get_Wand()
    local npcBot = GetBot()
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
          --local hp_enemy = enemy:GetHealth()
          --local damage_to_bot_in_3 = enemy:GetEstimatedDamageToTarget( true, npcBot, 3, DAMAGE_TYPE_ALL )
          --local damage_to_enemy_in_3 = npcBot:GetEstimatedDamageToTarget( true, enemy, 3, DAMAGE_TYPE_ALL )
          --local damage_to_bot_in_2 = enemy:GetEstimatedDamageToTarget( true, npcBot, 2, DAMAGE_TYPE_ALL )
          --local damage_to_enemy_in_2 = npcBot:GetEstimatedDamageToTarget( true, enemy, 2, DAMAGE_TYPE_ALL )
          local damage_to_bot_in_1 = enemy:GetEstimatedDamageToTarget( true, npcBot, 1, DAMAGE_TYPE_ALL )
          --print(damage_to_bot_in_1)
          --local damage_to_enemy_in_1 = npcBot:GetEstimatedDamageToTarget( true, enemy, 1, DAMAGE_TYPE_ALL )
          if (damage_to_bot_in_1 >= hp) then 
            return true
          end  
          --Action_AttackUnit( hUnit, bOnce )
    end
    return false
end

function M.Process()
 M.UpdateHealPriority() 
 M.Useitem_faerie_fire()
 M.Healing_on_line()
 M.Use_Wand()
end



function M.UpdateHealPriority()
 local priority = items_to_buy.PRIORITY
  local unit = GetBot()
  local current_hp = unit:GetHealth()
  local max_hp = unit:GetMaxHealth()
  local coeff = current_hp / max_hp
  if coeff <= 0.75 and coeff >= 0.5  then 
    priority["item_tango"] = 61
    priority["item_flask"] = 14
   
      else
            if coeff <= 0.5   then 
            priority["item_tango"] = 61
            priority["item_flask"] = 100
    
              else
                  priority["item_tango"] = 53
                  priority["item_flask"] = 14
            end  
  end          
end



return M