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
-- every program starts only if it's installed, so the same list works on all machines
local function run(cmd)
	local prog = cmd:match("^(%S+)")
	awful.spawn.with_shell(string.format("command -v %s >/dev/null && %s", prog, cmd))
end

function autostart.run()
	-- utils
	run("numlockx on")
	run("xxkb")
	run("nm-applet")
	-- run("blueman-applet")

	-- keyboard layouts
	run("setxkbmap -option -option 'grp:caps_toggle,grp:switch,grp_led:caps,compose:menu' -layout 'us,ru'")

	-- KDE apps menu cache (Plasma 6 / Plasma 5)
	awful.spawn.with_shell("kbuildsycoca6 --noincremental 2>/dev/null || kbuildsycoca5 --noincremental 2>/dev/null")

	-- apps
	run("thunderbird")
	run("yakuake")
	run("krusader")
	-- run("deadbeef")
	-- run("palemoon")
	-- run("deluge")
end

-- Session services: called on every awesome start and restart (Mod4+Ctrl+r),
-- each one is started only if it isn't running yet
--------------------------------------------------------------------------------
function autostart.services()
	-- polkit agent, so apps can ask for the admin password (Discover, partition manager, ...)
	awful.spawn.with_shell(
		"pgrep -u $USER -x 'polkit-kde-auth|polkit-gnome-au' >/dev/null || for a in"
		.. " /usr/lib/x86_64-linux-gnu/libexec/polkit-kde-authentication-agent-1"
		.. " /usr/libexec/polkit-kde-authentication-agent-1"
		.. " /usr/lib/polkit-kde-authentication-agent-1"
		.. " /usr/lib/policykit-1-gnome/polkit-gnome-authentication-agent-1"
		.. " /usr/libexec/polkit-gnome-authentication-agent-1;"
		.. " do [ -x \"$a\" ] && { \"$a\" & break; }; done"
	)

	-- CopyQ clipboard manager; also keep text selected with the mouse in its history
	awful.spawn.with_shell(
		"command -v copyq >/dev/null && { pgrep -u $USER -x copyq >/dev/null || { copyq & sleep 3; };"
		.. " copyq config check_selection true >/dev/null; }"
	)
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
