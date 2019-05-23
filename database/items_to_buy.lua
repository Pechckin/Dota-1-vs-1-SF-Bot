
local M = {}
M.First_Buy = {
    [1] = "item_faerie_fire",
    [2] = "item_tango",
    [3] = "item_slippers",
    [4] = "item_slippers",
    [5] = "item_circlet",
  }
  
 

M.PRIORITY = {
['item_faerie_fire'] = 52,
['item_tango'] = 53,
['item_flask'] = 14,
-----------------------
['item_slippers'] = 32,
['item_circlet'] = 33,
['item_recipe_wraith_band'] = 0,
['item_wraith_band'] = 65,

-----------------------
['item_magic_stick'] = 64,
['item_recipe_magic_wand'] = 1,
['item_branches'] = 20,
['item_magic_wand'] = 75,
-----------------------
['item_boots'] = 74,
['item_gloves'] = 56,
['item_belt_of_strength'] = 55,
['item_power_treads'] = 90,
-----------------------
['item_ogre_axe'] = 80,
['item_boots_of_elves'] = 50,
['item_dragon_lance'] = 91,
-----------------------
['item_claymore'] = 88,
['item_shadow_amulet'] = 89,
['item_shadow_blade'] = 92,
-----------------------
['item_mithril_hammer'] = 0,
['item_recipe_black_king_bar'] = 0,
['item__black_king_bar'] = 200,
-----------------------
}

M.ITEMS_TO_BUY = {
  "item_recipe_wraith_band",
  "item_magic_stick",
  "item_circlet",
  "item_recipe_wraith_band",
  "item_branches",
  "item_branches",
  "item_recipe_magic_wand",
  "item_slippers",
  "item_circlet",
  "item_recipe_wraith_band",
  "item_boots",
  "item_gloves",	
  "item_belt_of_strength",
	"item_ogre_axe"	,
  "item_boots_of_elves",
  "item_boots_of_elves",
  "item_claymore"	,
  "item_shadow_amulet",
  "item_mithril_hammer",
  "item_ogre_axe"	,
  "item_recipe_black_king_bar",
  --
 -- "item_faerie_fire",
  --"item_tango",
  --"item_flask",
  --"item_enchanted_mango",
  --"item_clarity",
  -----------------------
  --item_wraith_band
  --"item_slippers",
  --"item_circlet",
  --"item_recipe_wraith_band",
  --------------------------
  --item_magic_wand
 -- "item_magic_stick",
  --"item_branches",
  --"item_branches",
  --"item_recipe_magic_wand",
  --------------------------
  
  --------------------------
  --item_power_treads
  --"item_boots",	
	--"item_belt_of_strength",
	--"item_gloves",	
  --------------------------
}

--M.ITEMS = {
 -- [WRAITH_BAND] = {
  --       "item_slippers",
   --      "item_circlet",
    --     "item_recipe_wraith_band",
     --  }
  --[POWER_THREADS] = {
   --       "item_boots",	
    --      "item_belt_of_strength",
     --     "item_gloves",	
--}
--[MAGIC_WAND] = {
 --         "item_magic_stick",
  --        "item_branches",
   --       "item_branches",
    --      "item_recipe_magic_wand",
  --}
  --}




return M
