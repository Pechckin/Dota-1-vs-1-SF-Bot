

local M = {}


local npcBot = GetBot();
local npcCourier = GetCourier(0);



function M.IsCourierNeed()
  local sCurItem = npcBot:GetItemInSlot(9);
  if sCurItem~=nil and npcBot:IsAlive() and GetGameState() == 5 then return true 
  else  
  return false
  end
end

function M.CourierTransfer()
  local cState = GetCourierState(npcCourier);
  if  npcBot:IsAlive() and GetGameState() == 5 and cState == COURIER_STATE_AT_BASE then 
    npcBot:ActionImmediate_Courier(npcCourier,COURIER_ACTION_TAKE_AND_TRANSFER_ITEMS);
  end
end

function M.Process()
  if M.IsCourierNeed() then 
     M.CourierTransfer();
   end  
end




 
return M