-----------------------------------------------------------------------------------------------------------------------
--                                    Deluge info for redflat desktop multimeter                                     --
-----------------------------------------------------------------------------------------------------------------------
-- Same output format as redflat.system.transmission.info, but reads `deluge-console info`.
-- Works with deluged (or Deluge GUI in thin-client mode); shows "offline" state when daemon isn't running.

local awful = require("awful")

local deluge = {}

local units = { K = 1, M = 1024, G = 1024^2, T = 1024^3 }

-- speed "512.0 K/s" -> KB/s
local function speed_kb(text)
	local num, unit = string.match(text or "", "@%s*([%d%.]+)%s*(%a)/s")
	return num and (tonumber(num) or 0) * (units[unit] or 1) or 0
end

-- Parse `deluge-console info` (compact form)
--------------------------------------------------------------------------------
function deluge.parse(output)
	output = string.gsub(output, "\27%[[%d;]*m", "") -- strip ANSI colors if any

	local list = {}
	local seed = { num = 0, speed = 0 }
	local dnld = { num = 0, speed = 0 }
	local current

	for line in string.gmatch(output, "[^\r\n]+") do
		-- "[D]  45.2% Some torrent name  0123abcd..."
		local state, prog, name, hash = string.match(line, "^%[(%a)%]%s+([%d%.]+)%%%s+(.-)%s+(%x+)%s*$")
		if state and #hash >= 8 then
			current = { state = state, prog = math.floor(tonumber(prog) or 0), name = name }
			table.insert(list, current)
			if     state == "S" then seed.num = seed.num + 1
			elseif state == "D" then dnld.num = dnld.num + 1
			end
		elseif current then
			-- "    DL: 1.2 GiB (1.3 GiB) @ 512.0 K/s UL: 30 MiB (31 MiB) @ 30.0 K/s ETA: 5m"
			local dl, ul = string.match(line, "DL:(.-)UL:(.*)")
			if dl then
				dnld.speed = dnld.speed + speed_kb(dl)
				seed.speed = seed.speed + speed_kb(ul)
			end
		end
	end

	-- downloading first, then seeding, then the rest
	local order = { D = 1, S = 2 }
	table.sort(list, function(a, b) return (order[a.state] or 3) < (order[b.state] or 3) end)

	local bars = {}
	for _, t in ipairs(list) do
		table.insert(bars, { value = t.prog, text = string.format("%d%% %s", t.prog, t.name) })
	end

	return {
		bars  = bars,
		lines = { { seed.speed, seed.num }, { dnld.speed, dnld.num } },
		alert = false
	}
end

-- Async meter function for redflat.desktop.multimeter
--------------------------------------------------------------------------------
function deluge.info(setup, args)
	args = args or {}
	local command = "pidof -x deluged >/dev/null && timeout 8 deluge-console info 2>/dev/null"

	awful.spawn.easy_async_with_shell(command, function(output)
		if output and string.find(output, "%[%a%]") then
			local state = deluge.parse(output)
			if args.speed_only then
				state.lines[1][2] = state.lines[1][1]
				state.lines[2][2] = state.lines[2][1]
			end
			setup(state)
		else
			setup({ bars = {}, lines = { { 0, 0 }, { 0, 0 } }, alert = true })
		end
	end)
end

return deluge
