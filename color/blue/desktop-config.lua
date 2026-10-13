-----------------------------------------------------------------------------------------------------------------------
--                                               Desktop widgets config                                              --
-----------------------------------------------------------------------------------------------------------------------

-- Grab environment
local beautiful = require("beautiful")
--local awful = require("awful")
local redflat = require("redflat")

-- Initialize tables and vars for module
-----------------------------------------------------------------------------------------------------------------------
local desktop = {}

-- desktop aliases
local wgeometry = redflat.util.desktop.wgeometry
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

	-- placement
	local grid = beautiful.desktop.grid
	local places = beautiful.desktop.places

	-- Network speed
	--------------------------------------------------------------------------------
	local netspeed = { geometry = wgeometry(grid, places.netspeed, workarea) }

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
	local ssdspeed = { geometry = wgeometry(grid, places.ssdspeed, workarea) }

	ssdspeed.args = {
		interface = "sde4",
		meter_function = system.disk_speed,
		timeout   = 2,
		label     = "HOME"
	}

	ssdspeed.style = beautiful.individual.desktop.speedmeter.drive

	-- HDD speed
	--------------------------------------------------------------------------------
	local hddspeed = { geometry = wgeometry(grid, places.hddspeed, workarea) }

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
	local cpumem = { geometry = wgeometry(grid, places.cpumem, workarea) }

	cpumem.args = {
		topbars = { num = 8, maxm = 100, crit = 90 },
		lines   = { { maxm = 100, crit = 80 }, { maxm = 100, crit = 80 } },
		meter   = { args = cpu_storage, func = system.dformatted.cpumem },
		timeout = 2
	}

	cpumem.style = beautiful.individual.desktop.multimeter.cpumem

	-- Torrents info (deluge)
	--------------------------------------------------------------------------------
	local transm = { geometry = wgeometry(grid, places.transm, workarea) }

	transm.args = {
		topbars    = { num = 8, maxm = 100 },
		lines      = { { maxm = 6*1024 }, { maxm = 6*1024 } },
		meter      = { async = deluge.info, args = { speed_only = true } },
		timeout    = 5,
	}

	transm.style = beautiful.individual.desktop.multimeter.transmission

	-- Disks
	--------------------------------------------------------------------------------
	local disks = { geometry = wgeometry(grid, places.disks, workarea) }

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
	local thermal = { geometry = wgeometry(grid, places.thermal, workarea) }
	local hddtherm = { geometry = wgeometry(grid, places.hddtherm, workarea) }

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
		redflat.util.desktop.build.static(desktop_objects)
	else
		redflat.util.desktop.build.dynamic(desktop_objects, nil, beautiful.desktopbg, args.buttons)
	end
end

-- End
-----------------------------------------------------------------------------------------------------------------------
return desktop
