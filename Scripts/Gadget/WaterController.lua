function OnBeHurt(context, element_type, unkParam, is_host)
    ScriptLib.PrintContextLog(context, "Test WaterController")
    local state = ScriptLib.GetGadgetState(context)
    if element_type == ElementType.Water then
        if state == GadgetState.Default or state == GadgetState.GearAction1 then
            ScriptLib.SetGadgetState(context, GadgetState.GearStart)
        end
        if state == GadgetState.Action01 then
            ScriptLib.SetGadgetState(context, GadgetState.Action02)
        end
    end
end