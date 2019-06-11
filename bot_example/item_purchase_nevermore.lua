local items = require(
  GetScriptDirectory() .."/support/items")

local frame = 0
function ItemPurchaseThink()
    if GetBot():GetTeam() == 2 then
        frame = frame + 1
        if frame % 15 == 0 then
            items.Buy()
        end   
    end    
end