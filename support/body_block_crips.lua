
local constants = require(
  GetScriptDirectory() .."/support/constants")
local map = require(
  GetScriptDirectory() .."/database/map")
local functions = require(
  GetScriptDirectory() .."/support/functions")
local sf_enemy = require(
 GetScriptDirectory() .."/support/sf_enemy")
local sf_ally = require(
 GetScriptDirectory() .."/support/sf_ally")

local B = {}
--------------------------------------------------------------------------------------------------------------
function B.pre_body_block()
  return GetBot():IsAlive()
end

--------------------------------------------------------------------------------------------------------------
function B.ternary(condition, a, b)
  if condition then
    return a
  else
    return b
  end
end
--------------------------------------------------------------------------------------------------------------
function B.IsFirstWave()
  return DotaTime() < 22--constants.TIME_FIRST_WAVE_MEET
end

--------------------------------------------------------------------------------------------------------------
function B.GetAllySpot(spot_name)
  return map.MAP[GetTeam()][spot_name]
end

--------------------------------------------------------------------------------------------------------------
local function GetBodyBlockSpot()
  return B.ternary(
           B.IsFirstWave(),
           B.GetAllySpot("first_body_block"),
           B.GetAllySpot("second_body_block"))
end
--------------------------------------------------------------------------------------------------------------



return B

