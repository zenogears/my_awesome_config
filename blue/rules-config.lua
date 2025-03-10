-----------------------------------------------------------------------------------------------------------------------
--                                                Rules config                                                       --
-----------------------------------------------------------------------------------------------------------------------

-- Grab environment
local awful =require("awful")
local beautiful = require("beautiful")
local redtitle = require("redflat.titlebar")

-- Initialize tables and vars for module
-----------------------------------------------------------------------------------------------------------------------
local rules = {}

rules.base_properties = {
	border_width     = beautiful.border_width,
	border_color     = beautiful.border_normal,
	focus            = awful.client.focus.filter,
	raise            = true,
	size_hints_honor = false,
	screen           = awful.screen.preferred,
}

rules.floating_any = {
	class = {
		"Clipflap", "Run.py",
	},
	role = { "AlarmWindow", "pop-up", },
	type = { "dialog" }
}

rules.titlebar_exeptions = {
	class = { "Cavalcade", "Clipflap", "Steam", "Qemu-system-x86_64" }
}

rules.maximized = {
	class = { "Emacs24" }
}

-- Build rule table
-----------------------------------------------------------------------------------------------------------------------
function rules:init(args)

	local args = args or {}
	self.base_properties.keys = args.hotkeys.keys.client
	self.base_properties.buttons = args.hotkeys.mouse.client


	-- Build rules
	--------------------------------------------------------------------------------
	self.rules = {
		{
			rule       = {},
			properties = args.base_properties or self.base_properties
		},
		{
			rule_any   = args.floating_any or self.floating_any,
			properties = { floating = true }
		},
		{
			rule_any   = self.maximized,
			callback = function(c)
				c.maximized = true
				redtitle.cut_all({ c })
				c.height = c.screen.workarea.height - 2 * c.border_width
			end
		},
		{
			rule_any   = { type = { "normal", "dialog" }},
			except_any = self.titlebar_exeptions,
			properties = { titlebars_enabled = true }
		},
		{
			rule_any   = { type = { "normal" }},
			properties = { placement = awful.placement.no_overlap + awful.placement.no_offscreen }
		},

                { rule = { class = "Navigator" },
                properties = { tag = awful.screen.focused().tags[1] } },

                { rule = { class = "krusader" },
                properties = { tag = awful.screen.focused().tags[1] } },

                { rule = { class = "Thunderbird" },
                properties = { tag = awful.screen.focused().tags[2] } },

                { rule = { class = "thunderbird" },
                properties = { tag = awful.screen.focused().tags[2] } },

                { rule = { class = "Mail" },
                properties = { tag = awful.screen.focused().tags[2] } },

                { rule = { class = "rto-proxy" },
                properties = { tag = awful.screen.focused().tags[4] } },

                { rule = { class = "TelegramDesktop" },
                properties = { tag = awful.screen.focused().tags[3] } },

                { rule = { class = "Deluge" },
                properties = { tag = awful.screen.focused().tags[4] } },

                { rule = { class = "Brave-browser" },
                properties = { tag = awful.screen.focused().tags[4] } },


	}


	-- Set rules
	--------------------------------------------------------------------------------
	awful.rules.rules = rules.rules
end

-- End
-----------------------------------------------------------------------------------------------------------------------
return rules
