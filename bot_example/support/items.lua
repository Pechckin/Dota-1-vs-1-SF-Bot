local items_to_buy = require(
  GetScriptDirectory() .."/database/items_to_buy")

local constants = require(
  GetScriptDirectory() .."/support/constants")
local M = {}

 M.faerie_fire = true
 local npcBot = GetBot()
 
 ------------------------------------------------------------------------------------------------------------------------------------------------------
  ------------------------------------------------------------------------------------------------------------------------------------------------------
function M.Buy()
  M.StartBuy()
  M.SecondBuy()
end

function M.StartBuy()
  if GetGameState() == 4 and M.GetItemSlotsCount() == 0 then 
    for i = 1, 5 do
        local item = items_to_buy.First_Buy[i]
        npcBot:ActionImmediate_PurchaseItem(item)
    end
  end
end

function M.SecondBuy()
  if GetGameState() == 5 then 
    local item =  items_to_buy.ITEMS_TO_BUY[1]
    local money = npcBot:GetGold()
    local price = GetItemCost(item)
      if money > price then
        npcBot:ActionImmediate_PurchaseItem(item)
        table.remove(items_to_buy.ITEMS_TO_BUY,1)
      end  
  end
end
 ------------------------------------------------------------------------------------------------------------------------------------------------------
 ------------------------------------------------------------------------------------------------------------------------------------------------------
 
  function M.GetItemSlotsCount()
	local itemCount = 0
	for i = 0, 8
	do
		local sCurItem = npcBot:GetItemInSlot(i)
		if ( sCurItem ~= nil )
		then
			itemCount = itemCount + 1
		end
	end
	return itemCount
end

 

 ------------------------------------------------------------------------------------------------------------------------------------------------------
 ------------------------------------------------------------------------------------------------------------------------------------------------------
function M.GetItemsInventory(unit)
  local result = {}
  for i = 0, 5, 1 do
    table.insert(result, unit:GetItemInSlot(i))
  end
  return result
end

 function M.GetItems(unit)
  local result = {}
  for i = constants.INVENTORY_START_INDEX, constants.STASH_END_INDEX, 1 do
    table.insert(result, unit:GetItemInSlot(i))
  end
  return result
end


function M.GetItemsBackpack(unit)
  local result = {}
  for i = 6, 8, 1 do
    table.insert(result, unit:GetItemInSlot(i))
  end
  return result
end

 ------------------------------------------------------------------------------------------------------------------------------------------------------
 ------------------------------------------------------------------------------------------------------------------------------------------------------ 
 function M.UpdateInventory()
   local priority = items_to_buy.PRIORITY
   local inventory1 = M.GetItemsInventory(npcBot)
   local inventory2 = M.GetItemsBackpack(npcBot)
   local mini = 100
   local maxi = -1
   local index_min = 0
   local index_max = 0
   local handle1 
   local handle2 
   for key,value in ipairs(inventory1) 
   do
            if mini > priority[value:GetName()] then 
            mini = priority[value:GetName()]
            index_min = key
            handle1 = value
            end  
   end
   for key,value in ipairs(inventory2) 
   do
          if maxi < priority[value:GetName()] then 
          maxi = priority[value:GetName()]
          index_max = key
          handle2 = value
          end  
   end
   
   if handle2 ~= nil and  handle1 ~= nil then 
      if (handle2:GetName() ~= handle1:GetName()) and  (maxi > mini) then
        if handle1:GetName() == "item_faerie_fire" then 
          npcBot:Action_UseAbility(handle1)
          M.faerie_fire = false
        else  
          M.Swap(6 + index_max - 1,index_min-1)
        end
      end
   end
end 


------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------

 function M.Swap(index_1,index_2)
      if (index_1 ~=nil) and (index_2 ~=nil)   then
      npcBot:ActionImmediate_SwapItems(index_1,index_2)
      end
end


------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------
 return M
