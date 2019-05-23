local items_to_buy = require(
  GetScriptDirectory() .."/database/items_to_buy")
local items = require(
  GetScriptDirectory() .."/support/items")
local frame = 0

function ItemPurchaseThink()
    frame = frame + 1
    if frame % 5 == 0 then
        items.Buy()
    end    
end