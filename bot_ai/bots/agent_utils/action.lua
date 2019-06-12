-- Action execution module.

local Action = {}
local agent = GetBot()



local NEARBY_RADIUS = 1600


function Action.move(loc_move, act)
    if act == 0 or act == "0"  then 
      agent:Action_ClearActions(true)
    else
      agent:Action_MoveToLocation(loc_move)
    end  
    
end




return Action
