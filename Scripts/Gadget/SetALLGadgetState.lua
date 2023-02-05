function OnClientExecuteReq(context, param1, param2, param3)
	if param1 == 0 then
		ScriptLib.SetGadgetState(context, GadgetState.Default)
	end
    elseif param1 == 106 then
		ScriptLib.SetGadgetState(context, GadgetState.ChestRock)
	end
    elseif param1 == 201 then
		ScriptLib.SetGadgetState(context, GadgetState.GearStart)
	end
    elseif param1 == 202 then
		ScriptLib.SetGadgetState(context, GadgetState.GearStop)
	end
    elseif param1 == 203 then
		ScriptLib.SetGadgetState(context, GadgetState.GearAction1)
	end
    elseif param1 == 204 then
		ScriptLib.SetGadgetState(context, GadgetState.GearAction2)
	end

    elseif param1 == 901 then
		ScriptLib.SetGadgetState(context, GadgetState.Action01)
	end
    elseif param1 == 902 then
		ScriptLib.SetGadgetState(context, GadgetState.Action02)
	end
    elseif param1 == 903 then
		ScriptLib.SetGadgetState(context, GadgetState.Action03)
	end

    elseif (param1 >= 101 and param1 <= 104) or param1 == 200 or
        (param1 >= 211 and param1 <= 214) or param1 == 222 or
        (param1 >= 300 and param1 <= 304) or (param1 >= 310 and param1 <= 314) or param1 = 322 then
		ScriptLib.SetGadgetState(context, param1)
	end
end