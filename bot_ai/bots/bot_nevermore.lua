require(GetScriptDirectory() .. '/util/json')

local Observation = require(GetScriptDirectory() .. '/agent_utils/observation')
local Reward = require(GetScriptDirectory() .. '/agent_utils/reward')
local Action = require(GetScriptDirectory() .. '/agent_utils/action')


local MIN_FRAMES_BETWEEN = 1
local NEARBY_RADIUS = 1600
local frame_count = 0
local total_frames_reward = 0
local current_action = 0
local action_memory = false
local action_to_do_next
local next_step = 1
local need_action = 1
-- Bot communication automaton.
local IDLE = 0
local ACTION_RECEIVED = 1
local SEND_OBSERVATION = 2
local fsm_state = SEND_OBSERVATION

local wrong_action = 0

local cur_x = 0
local cur_y = 0
local flag = false
sf = GetBot()
--- Executes received action.
-- @param action_info bot action
--
function execute_action(action)
    wrong_action = Action.execute_action(action)
end

--- Create JSON message from table 'message' of type 'type'.
-- @param message table containing message
-- @param type type of message e.g. 'what_next' or 'observation'
-- @return JSON encoded {'type': type, 'content': message}
--
function create_message(message, type)
    local msg = {
        ['type'] = type,
        ['content'] = message
    }

    local encode_msg = Json.Encode(msg)
    return encode_msg
end

--- Send JSON message to bot server.
-- @param json_message message to send
-- @param route route ('/what_next' or '/observation')
-- @param callback called after response is received
--
function send_message(json_message, route, callback)
    local req = CreateHTTPRequest(':5000' .. route)
    req:SetHTTPRequestRawPostBody('application/json', json_message)
    req:Send(function(result)
        for k, v in pairs(result) do
            if k == 'Body' then
                if v ~= '' then
                    local response = Json.Decode(v)
                    current_action = response['action']
                    next_step = response['answer']
                end
            end
        end

    end)
end
function send_what_next_message()
    local message = create_message('', 'what_next')
    send_message(message, '/what_next', nil)
end

--
function send_observation_message(msg)
    send_message(create_message(msg, 'observation'), '/observation', nil)
end

function Think()
  
  if DotaTime()  <= -80  then
               local start_position = Vector(-3975,-3475)
               sf:Action_MoveToLocation(start_position)
  end   
  frame_count = frame_count + 1
    
  if(DotaTime() >= 0.5 and flag == false) then 
                local creeps = GetUnitList(UNIT_LIST_ALLIED_CREEPS)
                Creep_1 = creeps[1]
                Creep_2 = creeps[2]
                Creep_3 = creeps[3]
                Creep_4 = creeps[4]
                flag = true
  end
    
  if  DotaTime() >= 0.7 then
                  sf_X = sf:GetLocation()[1]
                  sf_Y = sf:GetLocation()[2]
                  X = {Creep_1:GetLocation()[1],Creep_2:GetLocation()[1],Creep_3:GetLocation()[1],Creep_4:GetLocation()[1]}
                  Y = {Creep_1:GetLocation()[2],Creep_2:GetLocation()[2],Creep_3:GetLocation()[2],Creep_4:GetLocation()[2]}
                  Distance = {GetUnitToUnitDistance(sf,Creep_1),GetUnitToUnitDistance(sf,Creep_2),GetUnitToUnitDistance(sf,Creep_3),GetUnitToUnitDistance(sf,                   Creep_4)}
                  table.sort(X)
                  table.sort(Y)
                  table.sort(Distance)
                  totald= Distance[1] + Distance[2] + Distance[3] + Distance[4]
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
                  total_speed_x = mx+(frame_speed_x*150)
                  total_speed_y = my+(frame_speed_y*150)
                  
                  local advise = (X[4] >= sf:GetLocation()[1]-30) or (Y[4] >= sf:GetLocation()[2]-30)
                  local next_position = Vector(total_speed_x,total_speed_y)
                  if next_step == 1 then 
                      next_step = 0
                      local rew = Reward.get_reward()
                      local done = Observation.is_done()
                      --print("FOR NOW DONE IS --> ", done, " REWARD IS --> ", rew)
                      local observation = Observation.get_observation(current_action, advise, Distance[1])
                      message = {
                          current_action, {
                              ['observation'] = observation,
                              ['reward'] = rew,
                              ['done'] = done,
                          }
                      }
                      send_observation_message({message})
                      if Observation.is_done() then
                          DebugPause()
                      end
                     -- if current_action == 0 and action_memory == false   then 
                       --   action_memory = true
                        --  sf:Action_ClearActions(true)
                      --else
                          --print("НАДОБНО ИДТИ")
                          --action_memory = false
                          --sf:Action_MoveToLocation(next_position)
                      --end  
                      Action.move(next_position, current_action)
                  end   
  end  
end





