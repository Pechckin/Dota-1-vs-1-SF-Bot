

local Reward = {}
local end_position = Vector(-800,-700)



function Reward.get_reward()
 local reward = 0
   
    sf = GetBot()
    local creeps = sf:GetNearbyLaneCreeps(1600, false)
    sf_X = sf:GetLocation()[1]
    sf_Y = sf:GetLocation()[2]
    Creep_1 = creeps[1]
    Creep_2 = creeps[2]
    Creep_3 = creeps[3]
    Creep_4 = creeps[4]
    X = {Creep_1:GetLocation()[1],Creep_2:GetLocation()[1],Creep_3:GetLocation()[1],Creep_4:GetLocation()[1]}
    Y = {Creep_1:GetLocation()[2],Creep_2:GetLocation()[2],Creep_3:GetLocation()[2],Creep_4:GetLocation()[2]}
    local check_creeps = {GetUnitToLocationDistance(Creep_1, end_position), GetUnitToLocationDistance(Creep_2, end_position), GetUnitToLocationDistance(Creep_3, end_position), GetUnitToLocationDistance(Creep_4, end_position)}
    local check_sf = GetUnitToLocationDistance(sf, end_position)
    if math.min(unpack(check_creeps)) > check_sf  then 
      reward = reward +  1
    else
      reward = reward - 1
    end 
    
    return reward
end  


return Reward
