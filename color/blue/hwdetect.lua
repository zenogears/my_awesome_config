-----------------------------------------------------------------------------------------------------------------------
--                                 Hardware autodetection for desktop widgets (work PC)                              --
-----------------------------------------------------------------------------------------------------------------------
-- Finds network interface, disks and temperature sensors at startup, so the config works on any machine
-- without editing device names. Everything degrades gracefully: missing tools/sensors just drop the widget item.

local awful = require("awful")

local hw = {}

local function read(cmd)
	local f = io.popen(cmd .. " 2>/dev/null")
	if not f then return "" end
	local out = f:read("*a") or ""
	f:close()
	return out
end

local function has(cmd)
	return read("command -v " .. cmd) ~= ""
end

-- Network
--------------------------------------------------------------------------------
function hw.net_iface()
	return read("ip route show default"):match("dev%s+(%S+)") or "eth0"
end

-- Disks
--------------------------------------------------------------------------------
-- kernel block device name (as in /proc/diskstats) of the filesystem containing path
function hw.device_of(path)
	local src = read("findmnt -no SOURCE --target " .. path):match("^/dev/([^%s%[]+)")
	if not src then return nil end
	return read("lsblk -no KNAME /dev/" .. src):match("^(%S+)") or src
end

function hw.parent_disk(dev)
	return dev and read("lsblk -no PKNAME /dev/" .. dev):match("(%S+)") or dev
end

local real_fs = {
	ext2 = true, ext3 = true, ext4 = true, btrfs = true, xfs = true, f2fs = true, zfs = true,
	ntfs = true, ntfs3 = true, fuseblk = true, vfat = true, exfat = true,
}

-- mounted local filesystems: "/" and "/home" first, then the rest; { { path, name }, ... }
function hw.mounts(max)
	local seen, list = {}, {}
	for target, fstype, source in read("findmnt -rno TARGET,FSTYPE,SOURCE"):gmatch("(%S+) (%S+) (%S+)") do
		target = target:gsub("\\x20", " ")
		if source:match("^/dev/") and not source:match("^/dev/loop") and real_fs[fstype]
		   and not target:match("^/boot") and not target:match("^/snap") and not target:match("^/var/snap")
		   and not seen[target] then
			seen[target] = true
			table.insert(list, target)
		end
	end

	local rank = function(p) return p == "/" and 1 or p == "/home" and 2 or 3 end
	table.sort(list, function(a, b)
		if rank(a) ~= rank(b) then return rank(a) < rank(b) end
		return a:lower() < b:lower()
	end)

	local result = {}
	for i = 1, math.min(#list, max or 6) do
		local p = list[i]
		local name = p == "/" and "root" or (p:match("([^/]+)$") or p):lower():sub(1, 5)
		table.insert(result, { p, name })
	end
	return result
end

-- Temperatures (lm-sensors)
--------------------------------------------------------------------------------
-- value of `label` inside the sensors block whose chip name starts with `chip`
function hw.read_sensor(output, chip, label)
	for block in (output .. "\n\n"):gmatch("(.-)\n%s*\n") do
		if block:sub(1, #chip) == chip then
			local value = block:match("\n" .. label .. ":%s+%+?(%-?%d+)")
			if value then return tonumber(value) end
		end
	end
end

-- async meter function for redflat singleline
function hw.sensor(chip, label)
	return function(setup)
		awful.spawn.easy_async("sensors", function(output)
			setup({ hw.read_sensor(output, chip, label) or 0 })
		end)
	end
end

-- list of { async_function, name, maxm, crit } for everything found on this machine
function hw.temperatures()
	local out = read("sensors")
	local chips = {}
	for chip in ("\n" .. out):gmatch("\n([^\n]+)\nAdapter:") do table.insert(chips, chip) end

	local found = {}
	local function add(chip, label, name, maxm, crit)
		if hw.read_sensor(out, chip, label) then
			table.insert(found, { async_function = hw.sensor(chip, label), name = name, maxm = maxm, crit = crit })
			return true
		end
	end

	-- CPU
	local cpu_done = false
	for _, c in ipairs(chips) do
		if not cpu_done then
			if c:match("^coretemp") then cpu_done = add(c, "Package id 0", "cpu", 100, 85)
			elseif c:match("^k10temp") then cpu_done = add(c, "Tctl", "cpu", 100, 85) or add(c, "temp1", "cpu", 100, 80)
			elseif c:match("^zenpower") then cpu_done = add(c, "Tdie", "cpu", 100, 85)
			end
		end
	end

	-- GPU
	if has("nvidia-smi") then
		table.insert(found, {
			async_function = function(setup)
				awful.spawn.easy_async("nvidia-smi --query-gpu=temperature.gpu --format=csv,noheader", function(o)
					setup({ tonumber(o:match("(%d+)")) or 0 })
				end)
			end,
			name = "gpu", maxm = 100, crit = 80
		})
	else
		for _, c in ipairs(chips) do
			if c:match("^amdgpu") then add(c, "edge", "gpu", 100, 85); break end
		end
	end

	-- drives: NVMe and SATA (drivetemp module)
	local n = 0
	for _, c in ipairs(chips) do
		if c:match("^nvme") then
			n = n + 1
			add(c, "Composite", n == 1 and "nvme" or "nvme" .. n, 90, 70)
		elseif c:match("^drivetemp") then
			n = n + 1
			add(c, "temp1", "disk" .. n, 65, 55)
		end
	end

	return found
end

return hw
