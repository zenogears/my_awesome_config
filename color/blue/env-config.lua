-----------------------------------------------------------------------------------------------------------------------
--                                                  Environment config                                               --
-----------------------------------------------------------------------------------------------------------------------

local awful = require("awful")
local gears = require("gears")
local beautiful = require("beautiful")
local wibox = require("wibox")
local naughty = require("naughty")

local redflat = require("redflat")

local unpack = unpack or table.unpack

-- Initialize tables and vars for module
-----------------------------------------------------------------------------------------------------------------------
local env = {}

-- Build hotkeys depended on config parameters
-----------------------------------------------------------------------------------------------------------------------
function env:init(args)

	-- init vars
	args = args or {}

	-- environment vars
	self.theme = args.theme or "red"
	self.terminal = args.terminal or "konsole"
	self.mod = args.mod or "Mod4"
	self.fm = args.fm or "dolphin"
	self.mail = args.mail or "thunderbird"
	self.player = args.player or "deadbeef"
	self.updates = args.updates or "bash -c 'apt list --upgradable 2>/dev/null | grep -c upgradable'"
	self.home = os.getenv("HOME")
	self.themedir = awful.util.get_configuration_dir() .. "themes/" .. self.theme

	-- boolean defaults is pain
	self.sloppy_focus = args.sloppy_focus or false
	self.color_border_focus = args.color_border_focus or false
	self.set_slave = args.set_slave == nil and true or false
	self.set_center = args.set_center or false
	self.desktop_autohide = args.desktop_autohide or false

	-- theme setup
	beautiful.init(env.themedir .. "/theme.lua")

	-- naughty config
	naughty.config.padding = beautiful.useless_gap and 2 * beautiful.useless_gap or 0

	naughty.config.spacing = 6

	-- look up app icons (notify-send -i name) in ACYLS too, svg included
	local acyls = os.getenv("HOME") .. "/.icons/ACYLS-steel/scalable/"
	naughty.config.icon_dirs = { acyls .. "apps/", acyls .. "status/", acyls .. "devices/", "/usr/share/pixmaps/" }
	naughty.config.icon_formats = { "svg", "png", "gif" }

	-- Presets are updated in place: naughty.dbus keeps references to the original
	-- preset tables, so replacing them would leave notify-send/app notifications unstyled
	if beautiful.naughty then
		for _, name in ipairs({ "low", "normal", "critical" }) do
			local preset = naughty.config.presets[name]
			for _, src in ipairs({ beautiful.naughty.base, beautiful.naughty[name] }) do
				for k, v in pairs(src or {}) do preset[k] = v end
			end
		end
	end
end


-- Common functions
-----------------------------------------------------------------------------------------------------------------------

-- Wallpaper setup
--------------------------------------------------------------------------------
env.wallpaper = function(s)
	if beautiful.wallpaper then
		if not env.desktop_autohide and awful.util.file_readable(beautiful.wallpaper) then
			gears.wallpaper.maximized(beautiful.wallpaper, s, true)
		else
			gears.wallpaper.set(beautiful.color and beautiful.color.bg)
		end
	end
end

-- Tag tooltip text generation
--------------------------------------------------------------------------------
env.tagtip = function(t)
	local layname = awful.layout.getname(awful.tag.getproperty(t, "layout"))
	if redflat.util.table.check(beautiful, "widget.layoutbox.name_alias") then
		layname = beautiful.widget.layoutbox.name_alias[layname] or layname
	end
	return string.format("%s (%d apps) [%s]", t.name, #(t:clients()), layname)
end

-- Panel widgets wrapper
--------------------------------------------------------------------------------
env.wrapper = function(widget, name, buttons)
	local margin = redflat.util.table.check(beautiful, "widget.wrapper")
	               and beautiful.widget.wrapper[name] or { 0, 0, 0, 0 }
	if buttons then
		widget:buttons(buttons)
	end

	return wibox.container.margin(widget, unpack(margin))
end


-- End
-----------------------------------------------------------------------------------------------------------------------
return env
