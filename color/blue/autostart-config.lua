-----------------------------------------------------------------------------------------------------------------------
--                                              Autostart app list                                                   --
-----------------------------------------------------------------------------------------------------------------------

-- Grab environment
local awful = require("awful")

-- Initialize tables and vars for module
-----------------------------------------------------------------------------------------------------------------------
local autostart = {}

-- Application list function
--------------------------------------------------------------------------------
function autostart.run()
	-- utils
	awful.spawn.with_shell("numlockx on")
	awful.spawn.with_shell("xxkb")
	awful.spawn.with_shell("nm-applet")
	-- awful.spawn.with_shell("compton")
	-- awful.spawn.with_shell("blueman-applet")

	-- keyboard layouts
	awful.spawn.with_shell("setxkbmap -option -option 'grp:caps_toggle,grp:switch,grp_led:caps,compose:menu' -layout 'us,ru'")

	-- screen power
	awful.spawn.with_shell("xset -dpms; xset s off")

	-- KDE apps menu cache
	awful.spawn.with_shell("kbuildsycoca6 --noincremental")

	-- apps
	awful.spawn.with_shell("thunderbird")
	awful.spawn.with_shell("yakuake")
	awful.spawn.with_shell("krusader")
	-- awful.spawn.with_shell("deadbeef")
	-- awful.spawn.with_shell("palemoon")
	-- awful.spawn.with_shell("deluge")
	-- awful.spawn.with_shell("/home/zen/git/rto-proxy-x86_64.AppImage")
end

-- Read and commands from file and spawn them
--------------------------------------------------------------------------------
function autostart.run_from_file(file_)
	local f = io.open(file_)
	for line in f:lines() do
		if line:sub(1, 1) ~= "#" then awful.spawn.with_shell(line) end
	end
	f:close()
end

-- End
-----------------------------------------------------------------------------------------------------------------------
return autostart
