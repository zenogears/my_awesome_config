-----------------------------------------------------------------------------------------------------------------------
--                                                   Blue theme                                                      --
-----------------------------------------------------------------------------------------------------------------------
local awful = require("awful")

-- This theme was inherited from another with overwriting some values
-- Check parent theme to find full settings list and its description
local theme = require("themes/colored/theme")


-- Color scheme
-----------------------------------------------------------------------------------------------------------------------
-- "Steel & crimson": cool steel-teal tuned to the wallpaper, crimson accent from the wing
theme.color.main      = "#2A7C99"  -- steel teal (active elements)
theme.color.urgent    = "#C0303A"  -- crimson (urgent / alerts)
theme.color.gray      = "#56606A"
theme.color.bg        = "#14171A"
theme.color.bg_second = "#181C20"
theme.color.wibox     = "#1D2125"
theme.color.icon      = "#A6B0B7"
theme.color.text      = "#B8BFC4"
theme.color.highlight = "#EBEDEE"
theme.color.border    = "#363D44"

theme.color.shadow1   = "#121518"
theme.color.shadow2   = "#2E353B"
theme.color.shadow3   = "#1A1E22"
theme.color.shadow4   = "#727D86"

theme.color.button    = "#56606A"
theme.color.pressed   = "#363D44"

theme.color.desktop_gray = "#5C666E"  -- tuned for dark desktop cards
theme.color.desktop_icon = "#76808A"


-- Common
-----------------------------------------------------------------------------------------------------------------------
theme.path = awful.util.get_configuration_dir() .. "themes/blue"

-- Main config
--------------------------------------------------------------------------------
theme.panel_height = 36 -- panel height
theme.border_width = 3  -- window border width
theme.useless_gap  = 6  -- useless gap

-- Hotkeys helper fonts: compact enough for two columns on a 1280px wide screen
-- (Iosevka Term isn't installed here, so keys use a local monospace)
theme.fonts.hotkeys.main  = "Roboto 13"
theme.fonts.hotkeys.key   = "Ubuntu Sans Mono 13"
theme.fonts.hotkeys.title = "Roboto bold 14"
-- local copy: /mnt/oldhome may be not mounted at login (original: /mnt/oldhome/zen/Изображения/02690-...girl with pistols.png)
theme.wallpaper    = theme.path .. "/wallpaper/girl-with-pistols.png"
theme.wallpaper_offset = { x = 0, y = -100 } -- 1280x1024 picture on 1920x1080: keep the head, crop the floor

-- Setup parent theme settings
--------------------------------------------------------------------------------
theme:update()


-- Popups sized for a 1920x1080 screen
theme.float.hotkeys.geometry = { width = 1500 }
theme.float.hotkeys.heights  = { key = 23, title = 27 }
theme.float.keychain.keytip  = { geometry = { width = 1100 }, column = 2 }
theme.float.qlaunch.geometry = { width = 1400, height = 170 }
theme.service.navigator.keytip["grid"]    = { geometry = { width = 1100 }, column = 2, exit = true }
theme.service.navigator.keytip["usermap"] = { geometry = { width = 1100 }, column = 2, exit = true }

-- Icons: ACYLS copy recolored to the theme's steel-teal (~/.icons/ACYLS-steel)
theme.service.dfparser.icons.theme = theme.homedir .. "/.icons/ACYLS-steel"


-- Desktop config
-----------------------------------------------------------------------------------------------------------------------

-- Desktop widgets placement
--------------------------------------------------------------------------------
-- Desktop layout tuned for 1920x1080, work PC (see color/blue/desktop-config.lua).
-- Widgets live on translucent dark "cards" so they read well on any part of the wallpaper.
-- Two columns: the left one grows from the left edge, the right one from the right edge,
-- the middle stays free for the wallpaper art. Every card is a list of { widget name, height }.
theme.desktop.card = {
	bg      = "#14171Ad8", -- pseudo-transparent, works without a compositor
	padding = 14,          -- space between card edge and widgets
	spacing = 10,          -- space between widgets inside one card
}

theme.desktop.columns = {
	edge  = { x = 36, y = 30 }, -- screen edge to card edge
	gap   = 16,                 -- space between cards
	width = 520,                -- widget width (card is wider by 2 * padding)
	left  = {
		{ { "cpumem", 150 } },
		{ { "transm", 150 } },
		{ { "disks", 196 } },
		{ { "thermal", 18 }, { "hddtherm", 18 } },
	},
	right = {
		{ { "netspeed", 176 } },
		{ { "ssdspeed", 176 } },
		{ { "hddspeed", 176 } },
	},
}

-- Desktop widgets
--------------------------------------------------------------------------------
-- individual widget settings doesn't used by redflat module
-- but grab directly from rc-files to rewrite base style
theme.individual.desktop = { speedmeter = {}, multimeter = {}, multiline = {}, singleline = {} }

-- Speedmeter (base widget)
theme.desktop.speedmeter.normal.images = { theme.path .. "/desktop/up.svg", theme.path .. "/desktop/down.svg" }

-- Speedmeter drive (individual widget)
theme.individual.desktop.speedmeter.drive = {
	unit   = { { "B", -1 }, { "KB", 2 }, { "MB", 2048 } },
}

-- Multimeter (base widget)
theme.desktop.multimeter.lines.show = { label = false, tooltip = false, text = true }

-- Multimeter cpu and ram (individual widget)
theme.individual.desktop.multimeter.cpumem = {
	labels = { "RAM", "SWAP" },
	icon   = { image = theme.path .. "/desktop/bstar.svg" }
}

-- Multimeter transmission info (individual widget)
theme.individual.desktop.multimeter.transmission = {
	labels = { "SEED", "DNLD" },
	unit   = { { "KB", -1 }, { "MB", 1024^1 } },
	icon   = { image = theme.path .. "/desktop/skull.svg" }
}

-- Multilines disks (individual widget)
theme.individual.desktop.multiline.disks = {
	unit  = { { "KB", 1 }, { "MB", 1024^1 }, { "GB", 1024^2 } },
	lines = { show = { text = false } },
}

-- Singleline temperature (individual widget)
theme.individual.desktop.singleline.thermal = {
	icon  = theme.path .. "/desktop/star.svg",
	unit  = { { "°", -1 } },
	lbox  = { draw = "by_width", width = 50, color = "#8A949B" },
	-- lighter label/value gray so text reads on the dark part of the wallpaper
	color = { main = theme.color.main, gray = "#8A949B", icon = "#8A949B",
	          urgent = theme.color.urgent, wibox = theme.color.bg .. "00" },
}


-- Panel widgets
-----------------------------------------------------------------------------------------------------------------------

-- individual margins for panel widgets
--------------------------------------------------------------------------------
theme.widget.wrapper = {
	layoutbox   = { 12, 10, 6, 6 },
	textclock   = { 10, 10, 0, 0 },
	volume      = { 10, 10, 5, 5 },
	network     = { 10, 10, 5, 5 },
	cpuram      = { 10, 10, 5, 5 },
	keyboard    = { 10, 10, 4, 4 },
	mail        = { 10, 10, 4, 4 },
	battery     = { 8, 10, 7, 7 },
	tray        = { 8, 8, 7, 7 },
	tasklist    = { 4, 0, 0, 0 }, -- centering tasklist widget
}

-- Various widgets style tuning
------------------------------------------------------------
theme.widget.tasklist.char_digit = 5
theme.widget.tasklist.task = theme.gauge.task.blue


-- Notifications (naughty)
-----------------------------------------------------------------------------------------------------------------------
-- fixed width so long text wraps instead of stretching across the screen, height is auto
local notify_shape = function(cr, w, h) require("gears").shape.rounded_rect(cr, w, h, 4) end

theme.naughty = {}

theme.naughty.base = {
	position     = "top_right",
	timeout      = 10,
	margin       = 14,
	width        = 440,
	max_height   = 320,
	icon_size    = 48,
	font         = theme.fonts.main,
	bg           = theme.color.wibox,
	fg           = theme.color.text,
	border_width = 2,
	border_color = theme.color.main,
	shape        = notify_shape,
}

theme.naughty.normal = {}

theme.naughty.low = {
	timeout      = 5,
	fg           = theme.color.icon,
	border_color = theme.color.border,
}

theme.naughty.critical = {
	timeout      = 0,
	fg           = theme.color.highlight,
	border_color = theme.color.urgent,
}

-- End
-----------------------------------------------------------------------------------------------------------------------
return theme
