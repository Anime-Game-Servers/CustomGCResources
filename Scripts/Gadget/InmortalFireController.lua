function OnBeHurt(context, element_type, unkParam, is_host)
    local state = ScriptLib.GetGadgetState(context)
    if element_type == ElementType.Fire then
        if state == GadgetState.Default then
            ScriptLib.SetGadgetState(context, GadgetState.GearStart);
        end
    end
end