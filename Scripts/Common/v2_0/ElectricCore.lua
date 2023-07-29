
local starter_id = 8100001

local function Initialize()
	for g_idx = 1, #gadgets do
		if gadgets[g_idx].gadget_id ~= 70900380 then
			goto continue
		end
        local region_template = { 
            config_id = starter_id,
            shape = RegionShape.SPHERE,
            radius = 14.5,
            pos = gadgets[g_idx].pos,
            area_id = gadgets[g_idx].area_id,
            ability_group_list = { "Fly_Electric_Core_Play" }
        }
        table.insert(regions, region_template)

        for s_idx = 1, #suites do
            local suite_gadgets = suites[s_idx].gadgets
            for sg_idx = 1, #suite_gadgets do
                if suite_gadgets[sg_idx] == gadgets[g_idx].config_id then
                    table.insert(suites[s_idx].regions, starter_id)
                end
            end
        end
        starter_id = starter_id + 1
        ::continue::
	end
end

----------------------------------

-- function Electric_Core_Explain(context)
-- 	ScriptLib.MarkPlayerAction(context, 7002, 3, 1)
-- 	return 0
-- end

----------------------------------
Initialize()
----------------------------------