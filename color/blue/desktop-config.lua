-----------------------------------------------------------------------------------------------------------------------
--                                               Desktop widgets config                                              --
-----------------------------------------------------------------------------------------------------------------------

-- Grab environment
local beautiful = require("beautiful")
--local awful = require("awful")
local redflat = require("redflat")
local wibox = require("wibox")

-- Initialize tables and vars for module
-----------------------------------------------------------------------------------------------------------------------
local desktop = {}

-- desktop aliases
local workarea = screen[mouse.screen].workarea
local system = redflat.system
local deluge = require("color.blue.deluge-meter")
local hw = require("color.blue.hwdetect")

-- Desktop widgets
-----------------------------------------------------------------------------------------------------------------------
function desktop:init(args)
	if not beautiful.desktop then return end

	args = args or {}
	local env = args.env or {}
	local autohide = env.desktop_autohide or false

	-- hardware of this machine (see color/blue/hwdetect.lua)
	local root_dev = hw.device_of("/")
	local home_dev = hw.device_of("/home")
	local home_label = "HOME"
	if home_dev == root_dev then home_dev, home_label = hw.parent_disk(root_dev), "DISK" end

	-- placement: cards stacked in two columns (see theme.desktop.columns / theme.desktop.card)
	local card = beautiful.desktop.card
	local cols = beautiful.desktop.columns

	-- Network speed
	--------------------------------------------------------------------------------
	local netspeed = {}

	netspeed.args = {
		interface    = hw.net_iface(),
		maxspeed     = { up = 6*1024^2, down = 6*1024^2 },
		crit         = { up = 6*1024^2, down = 6*1024^2 },
		timeout      = 2,
		autoscale    = false
	}

	netspeed.style  = {}

	-- SSD speed
	--------------------------------------------------------------------------------
	local ssdspeed = {}

	ssdspeed.args = {
		interface = home_dev,
		meter_function = system.disk_speed,
		timeout   = 2,
		label     = home_label
	}

	ssdspeed.style = beautiful.individual.desktop.speedmeter.drive

	-- HDD speed
	--------------------------------------------------------------------------------
	local hddspeed = {}

	hddspeed.args = {
		interface = root_dev,
		meter_function = system.disk_speed,
		timeout = 2,
		label = "ROOT"
	}

	hddspeed.style = beautiful.individual.desktop.speedmeter.drive

	-- CPU and memory usage
	--------------------------------------------------------------------------------
	local cpu_storage = { cpu_total = {}, cpu_active = {} }
	local cpumem = {}

	cpumem.args = {
		topbars = { num = 8, maxm = 100, crit = 90 },
		lines   = { { maxm = 100, crit = 80 }, { maxm = 100, crit = 80 } },
		meter   = { args = cpu_storage, func = system.dformatted.cpumem },
		timeout = 2
	}

	cpumem.style = beautiful.individual.desktop.multimeter.cpumem

	-- Torrents info (deluge)
	--------------------------------------------------------------------------------
	local transm = {}

	transm.args = {
		topbars    = { num = 8, maxm = 100 },
		lines      = { { maxm = 6*1024 }, { maxm = 6*1024 } },
		meter      = { async = deluge.info, args = { speed_only = true } },
		timeout    = 5,
	}

	transm.style = beautiful.individual.desktop.multimeter.transmission

	-- Disks
	--------------------------------------------------------------------------------
	local disks = {}

	disks.args = {
		sensors  = {},
		timeout = 300
	}

	for _, m in ipairs(hw.mounts(6)) do
		table.insert(disks.args.sensors, { meter_function = system.fs_info, maxm = 100, crit = 90, name = m[2], args = m[1] })
	end

	disks.style = beautiful.individual.desktop.multiline.disks

	-- Temperature indicators: whatever lm-sensors / nvidia-smi report on this machine, 3 per row
	--------------------------------------------------------------------------------
	local temps = hw.temperatures()
	local thermal, hddtherm = {}, {}
	local row1, row2 = {}, {}
	for k, t in ipairs(temps) do table.insert(k <= 3 and row1 or row2, t) end

	thermal.args  = { sensors = row1, timeout = 5 }
	hddtherm.args = { sensors = row2, timeout = 10 }

	thermal.style  = beautiful.individual.desktop.singleline.thermal
	hddtherm.style = beautiful.individual.desktop.singleline.thermal


	-- Initialize all desktop widgets
	--------------------------------------------------------------------------------
	netspeed.body = redflat.desktop.speedmeter.normal(netspeed.args, netspeed.style)
	ssdspeed.body = redflat.desktop.speedmeter.normal(ssdspeed.args, ssdspeed.style)
	hddspeed.body = redflat.desktop.speedmeter.normal(hddspeed.args, hddspeed.style)
	cpumem.body   = redflat.desktop.multimeter(cpumem.args, cpumem.style)
	transm.body   = redflat.desktop.multimeter(transm.args, transm.style)
	disks.body    = redflat.desktop.multiline(disks.args, disks.style)
	if #row1 > 0 then thermal.body  = redflat.desktop.singleline(thermal.args, thermal.style) end
	if #row2 > 0 then hddtherm.body = redflat.desktop.singleline(hddtherm.args, hddtherm.style) end

	-- Desktop setup
	--------------------------------------------------------------------------------
	local desktop_objects = {}
	for _, o in ipairs({ netspeed, hddspeed, ssdspeed, transm, cpumem, disks, thermal, hddtherm }) do
		if o.body then table.insert(desktop_objects, o) end
	end

	if not autohide then
		local byname = {
			netspeed = netspeed, ssdspeed = ssdspeed, hddspeed = hddspeed, cpumem = cpumem,
			transm = transm, disks = disks, thermal = thermal, hddtherm = hddtherm,
		}
		local pad, cw = card.padding, cols.width + 2 * card.padding

		for side, list in pairs({ left = cols.left, right = cols.right }) do
			local x = workarea.x + (side == "left" and cols.edge.x or workarea.width - cols.edge.x - cw)
			local y = workarea.y + cols.edge.y

			for _, items in ipairs(list) do
				local inner = wibox.layout.fixed.vertical()
				inner.spacing = card.spacing
				local h = 0
				local count = 0
				for _, item in ipairs(items) do
					local obj = byname[item[1]]
					if obj and obj.body then
						-- disks card grows with the number of detected filesystems
						local ih = item[1] == "disks" and math.ceil(item[2] * #disks.args.sensors / 6) or item[2]
						inner:add(wibox.container.constraint(obj.body.area, "exact", cols.width, ih))
						h = h + ih + (count > 0 and card.spacing or 0)
						count = count + 1
					end
				end

				if count > 0 then
					local box = wibox({ type = "desktop", visible = true, bg = card.bg })
					box:geometry({ x = x, y = y, width = cw, height = h + 2 * pad })
					box:set_widget(wibox.container.margin(inner, pad, pad, pad, pad))
					y = y + h + 2 * pad + cols.gap
				end
			end
		end
	else
		redflat.util.desktop.build.dynamic(desktop_objects, nil, beautiful.desktopbg, args.buttons)
	end
end

-- End
-----------------------------------------------------------------------------------------------------------------------
return desktop
