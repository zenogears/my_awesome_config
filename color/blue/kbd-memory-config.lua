-----------------------------------------------------------------------------------------------------------------------
--                                        Per-application keyboard layout memory                                     --
-----------------------------------------------------------------------------------------------------------------------
-- Every window remembers its own xkb layout group; new windows inherit the last layout used by their class.
-- Per-window value survives awesome restart (X property), per-class values are saved to cache dir.
-----------------------------------------------------------------------------------------------------------------------

-- Grab environment
-----------------------------------------------------------------------------------------------------------------------
local gears = require("gears")

local kbdmemory = {}

-- Build the file with per-class data
-----------------------------------------------------------------------------------------------------------------------
local cache_file = gears.filesystem.get_cache_dir() .. "kbd-memory"

local function load_classes()
	local data = {}
	local f = io.open(cache_file, "r")
	if not f then return data end
	for line in f:lines() do
		local class, group = line:match("^(.-)\t(%d+)$")
		if class then data[class] = tonumber(group) end
	end
	f:close()
	return data
end

local function save_classes(data)
	gears.filesystem.make_parent_directories(cache_file)
	local f = io.open(cache_file, "w")
	if not f then return end
	for class, group in pairs(data) do f:write(class, "\t", group, "\n") end
	f:close()
end

-- Init
-----------------------------------------------------------------------------------------------------------------------
-- args.defaults  : { [class] = group } fixed start layout for new windows of class (group index from 0)
-- args.remember_class : inherit last used layout for new windows of the same class (default true)
function kbdmemory:init(args)
	args = args or {}
	local defaults = args.defaults or {}
	local remember_class = args.remember_class ~= false

	local classes = remember_class and load_classes() or {}
	local pending  -- group we just set ourselves; its echo signal must not be recorded

	awesome.register_xproperty("_AWM_KBD_GROUP", "number")

	local function get_client_group(c)
		local group = c:get_xproperty("_AWM_KBD_GROUP")
		if group then return group end
		local class = c.class or ""
		return defaults[class] or classes[class] or 0
	end

	-- remember layout of focused window
	local function record(group)
		local c = client.focus
		if not c then return end
		c:set_xproperty("_AWM_KBD_GROUP", group)

		local class = c.class
		if remember_class and class and not defaults[class] and classes[class] ~= group then
			classes[class] = group
			save_classes(classes)
		end
	end

	awesome.connect_signal("xkb::group_changed", function()
		local group = awesome.xkb_get_layout_group()
		if pending ~= nil then
			local expected = pending
			pending = nil
			if group == expected then return end
		end
		record(group)
	end)

	-- restore layout on focus
	client.connect_signal("focus", function(c)
		local group = get_client_group(c)
		if group ~= awesome.xkb_get_layout_group() then
			pending = group
			awesome.xkb_set_layout_group(group)
		end
	end)
end

-- End
-----------------------------------------------------------------------------------------------------------------------
return kbdmemory
