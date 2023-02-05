function OnBeHurt(context, element_type, unkParam, is_host)
    local state = ScriptLib.GetGadgetState(context)
    if state == GadgetState.GearStop then
        if element_type == ElementType.Fire then
            local value = ScriptLib.GetGearStartValue(context)
            value = value + 1
            if value >= 1 then
                ScriptLib.SetGadgetState(context, GadgetState.GearStart)
                ScriptLib.SetGearStartValue(context, 1)
            else
                ScriptLib.SetGearStartValue(context, value)
            end
        elseif element_type == ElementType.Ice then
            ScriptLib.ResetGadgetState(context, GadgetState.GearStop)
        end
    elseif state == GadgetState.GearStart then
        if element_type == ElementType.Ice then
            local value = ScriptLib.GetGearStopValue(context)
            value = value + 1
            if value >= 1 then
                ScriptLib.SetGadgetState(context, GadgetState.GearStop)
                ScriptLib.SetGearStopValue(context, 1)
            else
                ScriptLib.SetGearStopValue(context, value)
            end
        end
    end
end

function OnClientExecuteReq(context, param1, param2, param3)
    if param1 == 1 then
        ScriptLib.SetGadgetState(context, GadgetState.GearStart)
    end
end

function OnTimer(context, now)
    local state = ScriptLib.GetGadgetState(context)
    if state == GadgetState.GearStop then
        local start_time = ScriptLib.GetGadgetStateBeginTime(context)
        if now >= start_time + 4 then
            ScriptLib.SetGadgetState(context, GadgetState.GearStart)
            ScriptLib.SetGearStopValue(context, 0)
        end
    end
end