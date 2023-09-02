local const = {
    scoin_worktop = 70360056,
    exp_worktop = 70360057,
    chest = 70210106
}
local defs = {
    worktop_option = 187
}
local temp_suites = {}


local Tri = {
    [1] = { name = "GROUP_LOAD_", config_id = 8000001, event = EventType.EVENT_GROUP_LOAD, source = "", condition = "", action = "action_EVENT_GROUP_LOAD" },
    [2] = { name = "GROUP_REFRESH_", config_id = 8000002, event = EventType.EVENT_GROUP_REFRESH, source = "", condition = "", action = "action_EVENT_GROUP_REFRESH"},
    [3] = { name = "GADGET_CREATE_", config_id = 8000003, event = EventType.EVENT_GADGET_CREATE, source = "", condition = "condition_EVENT_GADGET_CREATE", action = "action_EVENT_GADGET_CREATE", trigger_count = 0 },
    [4] = { name = "GADGET_STATE_CHANGE_", config_id = 8000004, event = EventType.EVENT_GADGET_STATE_CHANGE, source = "", condition = "condition_EVENT_GADGET_STATE_CHANGE", action = "action_EVENT_GADGET_STATE_CHANGE", trigger_count = 0 },
    [5] = { name = "SELECT_OPTION_", config_id = 8000005, event = EventType.EVENT_SELECT_OPTION, source = "", condition = "condition_EVENT_SELECT_OPTION", action = "action_EVENT_SELECT_OPTION", trigger_count = 0 },
    [6] = { name = "ANY_MONSTER_DIE_A", config_id = 8000006, event = EventType.EVENT_ANY_MONSTER_DIE, source = "", condition = "", action = "action_EVENT_ANY_MONSTER_DIE_A", trigger_count = 0 },
    [7] = { name = "ANY_MONSTER_DIE_B", config_id = 8000007, event = EventType.EVENT_ANY_MONSTER_DIE, source = "", condition = "condition_ANY_MONSTER_DIE_B", action = "action_EVENT_ANY_MONSTER_DIE_B" },
    [8] = { name = "BLOSSOM_PROGRESS_FINISH_", config_id = 8000008, event = EventType.EVENT_BLOSSOM_PROGRESS_FINISH, source = "", condition= "", action = "action_EVENT_BLOSSOM_PROGRESS_FINISH" },
    [9] = { name = "BLOSSOM_CHEST_DIE_", config_id = 8000009, event = EventType.EVENT_BLOSSOM_CHEST_DIE, source = "", condition = "condition_EVENT_BLOSSOM_CHEST_DIE", action = "action_EVENT_BLOSSOM_CHEST_DIE", trigger_count = 0 },
}

local function Initialize()
    --define blossom group cfgs
    if gadgets == nil then
        return
    end
    for i = 1, #gadgets do
        if gadgets[i].gadget_id == const.scoin_worktop then
            defs.scoin = gadgets[i].config_id
        end

        if gadgets[i].gadget_id == const.exp_worktop then
            defs.exp = gadgets[i].config_id
        end

        if gadgets[i].gadget_id == const.chest then
            defs.chest = gadgets[i].config_id
        end        
    end

    for k,v in pairs(Tri) do
        -- build unique trigger name for different group
        v.name = v.name .. defs.chest
	end

	for k,v in pairs(Tri) do
		table.insert(triggers, v)
		table.insert(suites[1].triggers, v.name)
	end

    --variable to control monster suite refresh
    table.insert(variables, { configId = 50000001, name = "wave", value = 0, no_refresh = true }) 
    temp_suites = suites
end

----------------------------------
local Static = {}

function Static.Get_Operator(context)
    --Obtain blossom operator depending on its type
    local operator = { [1] = defs.scoin, [2] = nil, [3] = defs.exp }
    local refreshType = ScriptLib.GetBlossomRefreshTypeByGroupId(context, 0)
    if not (refreshType == 1 or refreshType == 3) then
        return -1
    end

    return operator[refreshType]
end

function Static.Create_Next_Monster_Wave(context, evt)
    --add new monster suite if it is not already the last suite
    local wave = ScriptLib.GetGroupVariableValue(context, "wave")
    local next_wave = wave + 1
    local next_next_wave = wave + 2

    if next_next_wave <= #temp_suites then
		ScriptLib.AddExtraGroupSuite(context, evt.group_id, next_next_wave)
        ScriptLib.SetGroupVariableValue(context, "wave", next_wave)
    end
end

----------------------------------

function action_EVENT_GROUP_LOAD(context, evt)
     --refresh blossom group/camp
    ScriptLib.SetGroupVariableValue(context, "GroupCompletion", 0)
    if 0 ~= ScriptLib.RefreshBlossomGroup(context, { group_id = evt.group_id, suite = 1, exclude_prev = true }) then
        return -1
    end

    --remove all monster suite on init
	-- for i = 2, #temp_suites do
    --     ScriptLib.RemoveExtraGroupSuite(context, 0, i)
    -- end

    return 0
end

function action_EVENT_GROUP_REFRESH(context, evt)
    ScriptLib.CreateGadget(context, { config_id = Static.Get_Operator(context) })
	
	if 0 ~= ScriptLib.SetBlossomScheduleStateByGroupId(context, evt.group_id, 1) then
		return -1
	end
	
	if 0 ~= ScriptLib.RefreshBlossomDropRewardByGroupId(context, evt.group_id) then
		return -1
	end 
	
	return 0
end

function condition_EVENT_GADGET_CREATE(context, evt)
    if Static.Get_Operator(context) ~= evt.param1 then
        return false
    end

    if ScriptLib.GetGadgetStateByConfigId(context, evt.group_id, evt.param1) ~= GadgetState.GearAction2 then
        return false
    end

    return true
end

function action_EVENT_GADGET_CREATE(context, evt)
    local schedule_state = ScriptLib.GetBlossomScheduleStateByGroupId(context, evt.group_id)
    if 0 == schedule_state or 1 == schedule_state then
        --add worktop option to blossom gadget
        ScriptLib.SetWorktopOptions(context, { defs.worktop_option })
    end

    if 0 ~= ScriptLib.RefreshBlossomDropRewardByGroupId(context, evt.group_id) then
        return -1
    end

    return 0
end

function condition_EVENT_GADGET_STATE_CHANGE(context, evt)
    if Static.Get_Operator(context) ~= evt.param2 then
        return false
    end

    if evt.param1 ~= GadgetState.GearAction2 then
        return false
    end

    return true
end

function action_EVENT_GADGET_STATE_CHANGE(context, evt)
    local schedule_state = ScriptLib.GetBlossomScheduleStateByGroupId(context, evt.group_id)
    if 0 == schedule_state or 1 == schedule_state then
        --add worktop option to blossom gadget
        ScriptLib.SetWorktopOptions(context, { defs.worktop_option })
    end

    if 0 ~= ScriptLib.RefreshBlossomDropRewardByGroupId(context, evt.group_id) then
        return -1
    end

    return 0
end

function condition_EVENT_SELECT_OPTION(context, evt)
    if Static.Get_Operator(context) ~= evt.param1 then
        return false
    end

    if defs.worktop_option ~= evt.param2 then
        return false
    end

    return true
end

function action_EVENT_SELECT_OPTION(context, evt)
    --Upon player selection, hide blossom gadget, remove worktop option, add next monster suite
    ScriptLib.DelWorktopOptionByGroupId(context, evt.group_id, Static.Get_Operator(context), evt.param2)
    ScriptLib.SetGadgetStateByConfigId(context, Static.Get_Operator(context), GadgetState.GearStart)
    ScriptLib.SetBlossomScheduleStateByGroupId(context, evt.group_id, 2)
    -- ScriptLib.RefreshBlossomDropRewardByGroupId(context, 0)
    
    --mark group as started
    ScriptLib.SetGroupVariableValue(context, "wave", 0)

    Static.Create_Next_Monster_Wave(context, evt)
    return 0
end

function action_EVENT_ANY_MONSTER_DIE_A(context, evt)
    --Add blossom camp progress at group monster death
	ScriptLib.AddBlossomScheduleProgressByGroupId(context, evt.group_id)
	return 0
end

function condition_ANY_MONSTER_DIE_B(context, evt)
    --Do nothing if there is any active suite monster alive
    if ScriptLib.GetGroupMonsterCountByGroupId(context, evt.group_id) ~= 0 then
		return false
	end
    return true
end 

function action_EVENT_ANY_MONSTER_DIE_B(context, evt)
    --Add next monster suite if all active suite monster died
	Static.Create_Next_Monster_Wave(context, evt)
	return 0
end

function action_EVENT_BLOSSOM_PROGRESS_FINISH(context, evt)
    --create reward upon finishing blossom challenge
    if 0 ~= ScriptLib.CreateBlossomChestByGroupId(context, evt.group_id, defs.chest) then
        return -1
    end

    if 0 ~= ScriptLib.SetBlossomScheduleStateByGroupId(context, evt.group_id, 3) then
        return -1
    end
    
    if 0 ~= ScriptLib.SetGroupVariableValue(context, "GroupCompletion", 1) then
        return -1
    end

    return 0
end

function condition_EVENT_BLOSSOM_CHEST_DIE(context, evt)
    if defs.chest ~= evt.param1 then
        return false
    end
    return true
end

function action_EVENT_BLOSSOM_CHEST_DIE(context, evt)
    --Refresh blossom group/camp after getting reward
    ScriptLib.SetGroupVariableValue(context, "wave", 0)
    ScriptLib.RefreshBlossomGroup(context, { group_id = evt.group_id, suite = 1, exclude_prev = true })
    return 0
end

----------------------------------
Initialize()
----------------------------------