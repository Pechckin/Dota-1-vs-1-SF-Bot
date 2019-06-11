


local flag = false
local cur_x = 0
local cur_y = 0
local frame = 0
local start_position = Vector(-3975,-3475)
sf = GetBot()




function GetDesire()
  if DotaTime()  <= 20 then 
    return 1
  else
    return 0
  end  
end  


function Think()
  frame = frame + 1
  if DotaTime()  <= -50 then
     sf:Action_MoveToLocation(start_position)
  end   

  
  
  if(DotaTime() >= 0.5 and flag == false) then 
    local creeps = GetUnitList(UNIT_LIST_ALLIED_CREEPS)
    Creep_1 = creeps[1]
    Creep_2 = creeps[2]
    Creep_3 = creeps[3]
    Creep_4 = creeps[4]
    flag = true
  end
  
  if  DotaTime() >= 1 then
      sf_X = sf:GetLocation()[1]
      sf_Y = sf:GetLocation()[2]
      X = {Creep_1:GetLocation()[1],Creep_2:GetLocation()[1],Creep_3:GetLocation()[1],Creep_4:GetLocation()[1]}
      Y = {Creep_1:GetLocation()[2],Creep_2:GetLocation()[2],Creep_3:GetLocation()[2],Creep_4:GetLocation()[2]}
      Distance = {GetUnitToUnitDistance(sf,Creep_1),GetUnitToUnitDistance(sf,Creep_2),GetUnitToUnitDistance(sf,Creep_3),GetUnitToUnitDistance(sf,Creep_4)}
      table.sort(X)
      table.sort(Y)
      table.sort(Distance)
      totald= Distance[1] + Distance[2] + Distance[3] + Distance[4]
      md = math.min(unpack(Distance))
      if(totald <= 650) then 
          mx =  0.7 * X[4] + 0.2 * X[3] + 0.1 * X[2]
          my =  0.7 * Y[4] + 0.2 * Y[3] + 0.1 * Y[2]
      else
          mx =  0.9 * X[4] + 0.1 * X[3] 
          my =  0.9 * Y[4] + 0.1 * Y[3] 
      end

     
      frame_speed_x = math.abs(mx - cur_x)
      frame_speed_y = math.abs(my - cur_y)
      cur_x, cur_y = mx, my
      total_speed_x = mx+(frame_speed_x*35)
      total_speed_y = my+(frame_speed_y*35)
      local advise = (X[4] >= sf:GetLocation()[1]-20) or (Y[4] >= sf:GetLocation()[2]-20)
      local next_position = Vector(total_speed_x,total_speed_y)
      if    advise == false  then 
           sf:Action_ClearActions(true)
      else     
        sf:Action_MoveToLocation(next_position)
      end  
  end    
  --
  
 
  
   
   
end

