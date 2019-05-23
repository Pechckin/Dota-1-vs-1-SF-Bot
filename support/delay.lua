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


local M = {}
M.small_delay = 1.0
M.mid_delay = 30
M.high_delay = 5.0
M.time = 0;


function M.UpdateTime()
  M.time = DotaTime()
end   

function M.ActionDelay()
  local bot = GetBot()
  bot:Action_Delay(M.mid_delay)
end   



return M