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

theme.color.desktop_gray = "#3A4148"
theme.color.desktop_icon = "#5E6870"


-- Common
-----------------------------------------------------------------------------------------------------------------------
theme.path = awful.util.get_configuration_dir() .. "themes/blue"

-- Main config
--------------------------------------------------------------------------------
theme.panel_height = 36 -- panel height
theme.border_width = 3  -- window border width
theme.useless_gap  = 6  -- useless gap

-- Iosevka Term isn't installed here, use a local monospace for hotkeys helper keys
theme.fonts.hotkeys.key = "Ubuntu Sans Mono 14"
-- theme.wallpaper    = theme.path .. "/wallpaper/custom.png"
theme.wallpaper    = "/mnt/oldhome/zen/Изображения/02690-1273271716-girl with pistols.png"

-- Setup parent theme settings
--------------------------------------------------------------------------------
theme:update()


-- Desktop config
-----------------------------------------------------------------------------------------------------------------------

-- Desktop widgets placement
--------------------------------------------------------------------------------
theme.desktop.grid = {
	width  = { 520, 520, 520 },
	height = { 180, 160, 160, 138, 18 },
	edge   = { width = { 60, 60 }, height = { 40, 40 } }
}

theme.desktop.places = {
	netspeed = { 1, 1 },
	ssdspeed = { 2, 1 },
	hddspeed = { 3, 1 },
	cpumem   = { 1, 2 },
	transm   = { 1, 3 },
	disks    = { 1, 4 },
	thermal  = { 1, 5 }
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
	icon = theme.path .. "/desktop/star.svg",
	unit = { { "°C", -1 } },
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

-- End
-----------------------------------------------------------------------------------------------------------------------
return theme
