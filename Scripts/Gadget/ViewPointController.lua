function OnClientExecuteReq(context, param1, param2, param3)
    if param1 == 0 then
		ScriptLib.SetGadgetState(context, GadgetState.Default)
    elseif param1 == 1 then
		ScriptLib.SetGadgetState(context, GadgetState.GearStart)
	end
end