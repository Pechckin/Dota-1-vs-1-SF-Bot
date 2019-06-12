-- Observation generation module.

local Observation = {}
local Action = require(GetScriptDirectory() .. '/agent_utils/action')
local Resolver = require(GetScriptDirectory() .. '/agent_utils/resolver')
local Func = require(GetScriptDirectory() .. '/util/func')
local Config = require(GetScriptDirectory() .. '/config')
local Reward = require(GetScriptDirectory() .. '/agent_utils/reward')

local agent = Config.is_in_training_mode and GetBot() or GetTeamMember(1)
local agent_player_id = agent:GetPlayerID()

local NEARBY_RADIUS = 1600
local end_position = Vector(-800,-700)

function get_info_creeps_X()
    local info = {}
    local creeps = agent:GetNearbyLaneCreeps(NEARBY_RADIUS, false)
    if #creeps == 4  then
        Func.extend_table(info,{creeps[1]:GetLocation()[1],creeps[2]:GetLocation()[1]})
    else
        Func.extend_table(info, {0})
    end
    return info
end

function get_info_creeps_Y()
    local info = {}
    local creeps = agent:GetNearbyLaneCreeps(NEARBY_RADIUS, false)
    if #creeps == 4 then
        Func.extend_table(info, {creeps[1]:GetLocation()[2],creeps[2]:GetLocation()[2]})
    else
        Func.extend_table(info, {0})
    end
    return info
end

function get_info_creeps()
    local info = {}
    local creeps = agent:GetNearbyLaneCreeps(NEARBY_RADIUS, false)
    if #creeps == 4 then
        Func.extend_table(info, {creeps[1]:GetLocation(),creeps[2]:GetLocation()})
    else
        Func.extend_table(info, {0})
    end
    return creeps
end



function get_info_hero()
    local info = {}
    Func.extend_table(info, {agent:GetLocation()[1],agent:GetLocation()[2]})
    return info
end





function check_distance()
    local creeps = agent:GetNearbyLaneCreeps(NEARBY_RADIUS, false)
    sf = GetBot()
    sf_X = sf:GetLocation()[1]
    sf_Y = sf:GetLocation()[2]
    Creep_1 = creeps[1]
    Creep_2 = creeps[2]
    Creep_3 = creeps[3]
    Creep_4 = creeps[4]
    local check_creeps = {GetUnitToLocationDistance(Creep_1, end_position), GetUnitToLocationDistance(Creep_2, end_position), GetUnitToLocationDistance(Creep_3, end_position), GetUnitToLocationDistance(Creep_4, end_position)}
    local check_sf = GetUnitToLocationDistance(sf, end_position)
    if math.min(unpack(check_creeps)) < check_sf  then  
      return false
    end  
    return true
end

function get_distance()
      local creeps = agent:GetNearbyLaneCreeps(NEARBY_RADIUS, false)
      local res = GetUnitToUnitDistance(agent, creeps[1])
      return res
end

function get_distance()
      local creeps = agent:GetNearbyLaneCreeps(NEARBY_RADIUS, false)
      local res = GetUnitToUnitDistance(agent, creeps[1])
      return res
end

function get_advise(advise)
      if advise then 
          return 1
      end
      return 0
        
end






-- Get all observations.
function Observation.get_observation(action, advise, distance)
    local observation = {
        ['action_info'] = action,
        ['creeps_X'] = get_info_creeps_X(),
        ['creeps_Y'] = get_info_creeps_Y(),
        ['hero'] = get_info_hero(),
        ['advise'] = get_advise(advise),
        ['distance'] = distance
        
    }
    return observation
end

function Observation.is_done()
    local _end = false
    if DotaTime() > 20 or check_distance() == false or GetUnitToLocationDistance(agent,end_position) <= 300 then
        _end = true
        print('Bot: the game has ended.')
    end
    return _end
end

return Observation
