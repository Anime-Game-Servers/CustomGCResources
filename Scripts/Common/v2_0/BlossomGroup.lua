triggers = {
  [1] = {config_id = 8000001, name = "GADGET_STATE_CHANGE", event = EventType.EVENT_GADGET_STATE_CHANGE, source = "", condition = "condition_EVENT_GADGET_STATE_CHANGE", action = "action_EVENT_GADGET_STATE_CHANGE", trigger_count = 0},
  [2] = {config_id = 8000002, name = "GADGET_CREATE", event = EventType.EVENT_GADGET_CREATE, source = "", condition = "condition_EVENT_GADGET_CREATE", action = "action_EVENT_GADGET_CREATE", trigger_count = 0},
  [3] = {config_id = 8000003, name = "SELECT_OPTION", event = EventType.EVENT_SELECT_OPTION, source = "", condition = "condition_EVENT_SELECT_OPTION", action = "action_EVENT_SELECT_OPTION", trigger_count = 0},
  [4] = {config_id = 8000004, name = "ANY_MONSTER_DIE", event = EventType.EVENT_ANY_MONSTER_DIE, source = "", condition = "", action = "action_EVENT_ANY_MONSTER_DIE", trigger_count = 0},
  [5] = {config_id = 8000005, name = "BLOSSOM_PROGRESS_FINISH", event = EventType.EVENT_BLOSSOM_PROGRESS_FINISH, source = "", condition = "", action = "action_EVENT_BLOSSOM_PROGRESS_FINISH"},
  [6] = {config_id = 8000006, name = "BLOSSOM_CHEST_DIE", event = EventType.EVENT_BLOSSOM_CHEST_DIE, source = "", condition = "", action = "action_EVENT_BLOSSOM_CHEST_DIE", trigger_count = 0},
  [7] = {config_id = 8000007, name = "GROUP_LOAD", event = EventType.EVENT_GROUP_LOAD, source = "", condition = "", action = "action_EVENT_GROUP_LOAD"}
}

function condition_EVENT_GADGET_STATE_CHANGE(context, script_args)
  if GadgetState.GearAction2 == script_args.param1 then
    goto lbl_11
  end
  do return false end
  ::lbl_11::
  return true
end

function action_EVENT_GADGET_STATE_CHANGE(context, script_args)
  local L2_2 = ScriptLib.GetBlossomScheduleStateByGroupId(context, 0)
  if 0 == L2_2 or 1 == L2_2 then
    ScriptLib.SetWorktopOptions(context, {187})
  end
  if 0 ~= ScriptLib.RefreshBlossomDropRewardByGroupId(context, script_args.group_id) then
    ScriptLib.PrintContextLog(context, "@@ LUA_WARNING : remove_gadget_by_configid")
    return -1
  end
  return 0
end

function condition_EVENT_GADGET_CREATE(context, script_args)
  if GadgetState.GearAction2 == ScriptLib.GetGadgetStateByConfigId(context, 0, script_args.param1) then
    goto lbl_16
  end
  do return false end
  ::lbl_16::
  return true
end

function action_EVENT_GADGET_CREATE(context, script_args)
  local L2_2 = ScriptLib.GetBlossomScheduleStateByGroupId(context, 0)
  if 0 == L2_2 or 1 == L2_2 then
    ScriptLib.SetWorktopOptions(context, {187})
  end
  if 0 ~= ScriptLib.RefreshBlossomDropRewardByGroupId(context, script_args.group_id) then
    ScriptLib.PrintContextLog(context, "@@ LUA_WARNING : remove_gadget_by_configid")
    return -1
  end
  return 0
end

function action_EVENT_BLOSSOM_CHEST_DIE(context)
  if 0 ~= ScriptLib.RefreshBlossomGroup(context, {group_id = 0, suite = 1, exclude_prev = true, is_delay_unload = true}) then
    ScriptLib.PrintContextLog(context, "@@ LUA_WARNING : refresh_blossom_group")
    return -1
  end
  return 0
end

function condition_EVENT_SELECT_OPTION(context, script_args)
  if 187 ~= script_args.param2 then
    return false
  end
  return true
end

function action_EVENT_SELECT_OPTION(context, script_args)
  ScriptLib.AddExtraGroupSuite(context, script_args.group_id, 2)
  ScriptLib.SetGroupVariableValue(context, "wave", 2)
  if 0 ~= ScriptLib.DelWorktopOptionByGroupId(context, script_args.group_id, script_args.param1, 187) then
    ScriptLib.PrintContextLog(context, "@@ LUA_WARNING : del_work_options_by_group_configId")
    return -1
  end
  if 0 ~= ScriptLib.SetGadgetStateByConfigId(context, script_args.param1, GadgetState.GearStart) then
    ScriptLib.PrintContextLog(context, "@@ LUA_WARNING : set_gadget_state_by_configId")
    return -1
  end
  if 0 ~= ScriptLib.SetBlossomScheduleStateByGroupId(context, script_args.group_id, 2) then
    ScriptLib.PrintContextLog(context, "@@ LUA_WARNING : set_blossomscehedule_byGroupId")
    return -1
  end
  if 0 ~= ScriptLib.RefreshBlossomDropRewardByGroupId(context, script_args.group_id) then
    ScriptLib.PrintContextLog(context, "@@ LUA_WARNING : remove_gadget_by_configid")
    return -1
  end
  return 0
end

function action_EVENT_ANY_MONSTER_DIE(context, script_args)
  ScriptLib.AddBlossomScheduleProgressByGroupId(context, script_args.group_id)
  if ScriptLib.GetGroupMonsterCountByGroupId(context, script_args.group_id) == 0 then
		local wave = ScriptLib.GetGroupVariableValue(context,"wave")
    local next_wave = wave + 1
    local current_suite = ScriptLib.GetGroupSuite(context, script_args.group_id)
    local next_suite = current_suite + 1
    local next_next_suite = current_suite + 2
    if next_wave <= next_next_suite then
        ScriptLib.AddExtraGroupSuite(context, script_args.group_id, next_wave)
        ScriptLib.SetGroupVariableValue(context, "wave", nextWave)
    end
	end
  return 0
end

function action_EVENT_BLOSSOM_PROGRESS_FINISH(context, script_args)
  if 0 ~= ScriptLib.CreateBlossomChestByGroupId(context, script_args.group_id, script_args.param1) then
    ScriptLib.PrintContextLog(context, "@@ LUA_WARNING : create_blossomChest_bygroupid")
    return -1
  end
  if 0 ~= ScriptLib.SetBlossomScheduleStateByGroupId(context, script_args.group_id, 3) then
    ScriptLib.PrintContextLog(context, "@@ LUA_WARNING : set_blossomscehedule_byGroupId")
    return -1
  end
  if 0 ~= ScriptLib.SetGroupVariableValue(context, "GroupCompletion", 1) then
    ScriptLib.PrintContextLog(context, "@@ LUA_WARNING : set_groupVariable")
    return -1
  end
  return 0
end

function action_EVENT_GROUP_LOAD(context)
  if 0 ~= ScriptLib.RefreshBlossomGroup(context, {group_id = 0, suite = 1, exclude_prev = true, is_delay_unload = true}) then
    ScriptLib.PrintContextLog(context, "@@ LUA_WARNING : refresh_blossom_group")
    return -1
  end
  return 0
end