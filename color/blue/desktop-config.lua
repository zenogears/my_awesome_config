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

-- Desktop widgets
-----------------------------------------------------------------------------------------------------------------------
function desktop:init(args)
	if not beautiful.desktop then return end

	args = args or {}
	local env = args.env or {}
	local autohide = env.desktop_autohide or false

	-- placement: cards stacked in two columns (see theme.desktop.columns / theme.desktop.card)
	local card = beautiful.desktop.card
	local cols = beautiful.desktop.columns

	-- Network speed
	--------------------------------------------------------------------------------
	local netspeed = {}

	netspeed.args = {
		interface    = "enp3s0",
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
		interface = "sde4",
		meter_function = system.disk_speed,
		timeout   = 2,
		label     = "HOME"
	}

	ssdspeed.style = beautiful.individual.desktop.speedmeter.drive

	-- HDD speed
	--------------------------------------------------------------------------------
	local hddspeed = {}

	hddspeed.args = {
		interface = "sde3",
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
		sensors  = {
			{ meter_function = system.fs_info, maxm = 100, crit = 80, name = "root", args = "/"            },
			{ meter_function = system.fs_info, maxm = 100, crit = 80, name = "home", args = "/home"        },
			{ meter_function = system.fs_info, maxm = 100, crit = 80, name = "terra", args = "/mnt/terra" },
			{ meter_function = system.fs_info, maxm = 100, crit = 80, name = "oldh", args = "/mnt/oldhome" },
			{ meter_function = system.fs_info, maxm = 100, crit = 90, name = "play",  args = "/mnt/playstation" },
			{ meter_function = system.fs_info, maxm = 100, crit = 90, name = "video", args = "/mnt/Video" },
		},
		timeout = 300
	}

	disks.style = beautiful.individual.desktop.multiline.disks

	-- Sensors parser setup
	--------------------------------------------------------------------------------`
	local sensors_base_timeout = 5

	system.lmsensors.delay = 2
	system.lmsensors.patterns = {
		cpu       = { match = "%+(%d+)%.%d[^\n]-AMD AMDSI" },
	}

	-- start auto async lmsensors check
	system.lmsensors:soft_start(sensors_base_timeout)

	-- Temperature indicator
	--------------------------------------------------------------------------------
	local thermal = {}
	local hddtherm = {}

	-- hddtemp is setuid on this system, so it works without root
	local hddtemp = function(disk)
		return system.simple_async("/usr/sbin/hddtemp " .. disk, ":%s(%d+)[^%d]*C%s*$")
	end
	local gputemp = system.simple_async("nvidia-smi --query-gpu=temperature.gpu --format=csv,noheader", "(%d+)")

	thermal.args = {
		sensors = {
			{ meter_function = system.lmsensors.get, args = "cpu", maxm = 100, crit = 80, name = "cpu" },
			{ async_function = gputemp, maxm = 100, crit = 80, name = "gpu" },
			{ async_function = hddtemp("/dev/sde"), maxm = 70, crit = 60, name = "ssd" },
		},
		timeout = sensors_base_timeout,
	}

	hddtherm.args = {
		sensors = {
			{ async_function = hddtemp("/dev/sdb"), maxm = 65, crit = 55, name = "play" },
			{ async_function = hddtemp("/dev/sdd"), maxm = 65, crit = 55, name = "vid" },
		},
		timeout = 30,
	}

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
	thermal.body  = redflat.desktop.singleline(thermal.args, thermal.style)
	hddtherm.body = redflat.desktop.singleline(hddtherm.args, hddtherm.style)

	-- Desktop setup
	--------------------------------------------------------------------------------
	local desktop_objects = { netspeed, hddspeed, ssdspeed, transm, cpumem, disks, thermal, hddtherm }

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
				for k, item in ipairs(items) do
					local obj = byname[item[1]]
					inner:add(wibox.container.constraint(obj.body.area, "exact", cols.width, item[2]))
					h = h + item[2] + (k > 1 and card.spacing or 0)
				end

				local box = wibox({ type = "desktop", visible = true, bg = card.bg })
				box:geometry({ x = x, y = y, width = cw, height = h + 2 * pad })
				box:set_widget(wibox.container.margin(inner, pad, pad, pad, pad))
				y = y + h + 2 * pad + cols.gap
			end
		end
	else
		redflat.util.desktop.build.dynamic(desktop_objects, nil, beautiful.desktopbg, args.buttons)
	end
end

-- End
-----------------------------------------------------------------------------------------------------------------------
return desktop
