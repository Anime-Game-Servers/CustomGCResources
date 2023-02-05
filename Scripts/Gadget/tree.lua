function OnBeHurt(context, element_type, unkParam, is_host)
    local configIds = ScriptLib.GetGatherConfigIdList(context)
    local count = #configIds

    if length > 0 then
        ScriptLib.SetGadgetStateByConfigId(context, configIds[1], GadgetState.GatherDrop)
    end
end