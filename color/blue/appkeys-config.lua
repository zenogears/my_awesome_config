-----------------------------------------------------------------------------------------------------------------------
--                                        Third-party applications keys sheet                                        --
-----------------------------------------------------------------------------------------------------------------------
-- Tables for the per-application hotkeys helper (Mod4+Control+F1 with an app focused).
-- Key is the lowercase window class. The lists are purely descriptive, they don't change app settings.

local appkeys = {}

appkeys["konsole"] = {
	style = { column = 2, geometry = { width = 1100 } },
	pack = {
		{ { "Control", "Shift" }, "t", nil, { description = "New tab", group = "Tabs" } },
		{ { "Control", "Shift" }, "w", nil, { description = "Close tab", group = "Tabs" } },
		{ { "Shift" }, "Right", nil, { description = "Next tab", group = "Tabs" } },
		{ { "Shift" }, "Left", nil, { description = "Previous tab", group = "Tabs" } },
		{ { "Control", "Shift" }, "Right", nil, { description = "Move tab right", group = "Tabs" } },
		{ { "Control", "Shift" }, "Left", nil, { description = "Move tab left", group = "Tabs" } },
		{ { "Control", "Shift" }, "n", nil, { description = "New window", group = "Window" } },
		{ { "Control" }, "(", nil, { description = "Split view left/right", group = "Window" } },
		{ { "Control" }, ")", nil, { description = "Split view top/bottom", group = "Window" } },
		{ { "Control", "Shift" }, "m", nil, { description = "Show/hide menubar", group = "Window" } },
		{ { "Control", "Shift" }, "c", nil, { description = "Copy", group = "Edit" } },
		{ { "Control", "Shift" }, "v", nil, { description = "Paste", group = "Edit" } },
		{ { "Control", "Shift" }, "f", nil, { description = "Find", group = "Edit" } },
		{ { "Control" }, "+", nil, { description = "Bigger font", group = "Edit" } },
		{ { "Control" }, "-", nil, { description = "Smaller font", group = "Edit" } },
		{ { "Control" }, "c", nil, { description = "Terminate the command", group = "Shell" } },
		{ { "Control" }, "z", nil, { description = "Suspend the command", group = "Shell" } },
		{ { "Control" }, "l", nil, { description = "Clear the screen", group = "Shell" } },
		{ { "Control" }, "r", nil, { description = "Search command history", group = "Shell" } },
		{ { "Alt" }, ".", nil, { description = "Insert last word of previous command", group = "Shell" } },
		{ { "Control" }, "a", nil, { description = "Go to line start", group = "Shell" } },
		{ { "Control" }, "e", nil, { description = "Go to line end", group = "Shell" } },
		{ { "Control" }, "u", nil, { description = "Delete to line start", group = "Shell" } },
		{ { "Control" }, "k", nil, { description = "Delete to line end", group = "Shell" } },
		{ { "Control" }, "w", nil, { description = "Delete previous word", group = "Shell" } },
	}
}

appkeys["yakuake"] = {
	style = { column = 2, geometry = { width = 1100 } },
	pack = {
		{ {}, "F12", nil, { description = "Open/retract Yakuake", group = "Window" } },
		{ { "Control", "Shift" }, "t", nil, { description = "New session", group = "Sessions" } },
		{ { "Control", "Shift" }, "w", nil, { description = "Close session", group = "Sessions" } },
		{ { "Shift" }, "Right", nil, { description = "Next session", group = "Sessions" } },
		{ { "Shift" }, "Left", nil, { description = "Previous session", group = "Sessions" } },
		{ { "Control", "Shift" }, "Right", nil, { description = "Move session right", group = "Sessions" } },
		{ { "Control", "Shift" }, "Left", nil, { description = "Move session left", group = "Sessions" } },
		{ { "Control", "Shift" }, "c", nil, { description = "Copy", group = "Edit" } },
		{ { "Control", "Shift" }, "v", nil, { description = "Paste", group = "Edit" } },
		{ { "Control" }, "c", nil, { description = "Terminate the command", group = "Shell" } },
		{ { "Control" }, "z", nil, { description = "Suspend the command", group = "Shell" } },
		{ { "Control" }, "l", nil, { description = "Clear the screen", group = "Shell" } },
		{ { "Control" }, "r", nil, { description = "Search command history", group = "Shell" } },
		{ { "Alt" }, ".", nil, { description = "Insert last word of previous command", group = "Shell" } },
		{ { "Control" }, "a", nil, { description = "Go to line start", group = "Shell" } },
		{ { "Control" }, "e", nil, { description = "Go to line end", group = "Shell" } },
		{ { "Control" }, "u", nil, { description = "Delete to line start", group = "Shell" } },
		{ { "Control" }, "k", nil, { description = "Delete to line end", group = "Shell" } },
		{ { "Control" }, "w", nil, { description = "Delete previous word", group = "Shell" } },
	}
}

appkeys["krusader"] = {
	style = { column = 1, geometry = { width = 640 } },
	pack = {
		{ {}, "F3", nil, { description = "View file", group = "Files" } },
		{ {}, "F4", nil, { description = "Edit file", group = "Files" } },
		{ {}, "F5", nil, { description = "Copy to other panel", group = "Files" } },
		{ {}, "F6", nil, { description = "Move to other panel", group = "Files" } },
		{ {}, "F7", nil, { description = "New folder", group = "Files" } },
		{ {}, "F8", nil, { description = "Delete", group = "Files" } },
		{ {}, "F10", nil, { description = "Quit", group = "Files" } },
		{ {}, "Tab", nil, { description = "Switch panel", group = "Panels" } },
		{ { "Control" }, "u", nil, { description = "Swap panels", group = "Panels" } },
		{ {}, "Insert", nil, { description = "Select file and move down", group = "Selection" } },
		{ {}, "Backspace", nil, { description = "Go to parent folder", group = "Navigation" } },
	}
}

appkeys["thunderbird"] = {
	style = { column = 1, geometry = { width = 640 } },
	pack = {
		{ {}, "F5", nil, { description = "Get new messages", group = "Mail" } },
		{ { "Control" }, "n", nil, { description = "Write a message", group = "Mail" } },
		{ { "Control" }, "r", nil, { description = "Reply", group = "Mail" } },
		{ { "Control", "Shift" }, "r", nil, { description = "Reply to all", group = "Mail" } },
		{ { "Control" }, "l", nil, { description = "Forward", group = "Mail" } },
		{ { "Control" }, "Return", nil, { description = "Send (in compose window)", group = "Mail" } },
		{ {}, "Delete", nil, { description = "Delete message", group = "Mail" } },
		{ {}, "m", nil, { description = "Toggle read/unread", group = "Marks" } },
		{ {}, "s", nil, { description = "Star (flag) message", group = "Marks" } },
		{ {}, "j", nil, { description = "Mark as junk", group = "Marks" } },
		{ { "Shift" }, "j", nil, { description = "Mark as not junk", group = "Marks" } },
		{ {}, "n", nil, { description = "Next unread message", group = "Navigation" } },
		{ { "Control", "Shift" }, "k", nil, { description = "Quick filter", group = "Search" } },
		{ { "Control" }, "k", nil, { description = "Search all messages", group = "Search" } },
	}
}

appkeys["firefox-esr-esr140"] = {
	style = { column = 2, geometry = { width = 1100 } },
	pack = {
		{ { "Control" }, "t", nil, { description = "New tab", group = "Tabs" } },
		{ { "Control" }, "w", nil, { description = "Close tab", group = "Tabs" } },
		{ { "Control", "Shift" }, "t", nil, { description = "Reopen closed tab", group = "Tabs" } },
		{ { "Control" }, "Tab", nil, { description = "Next tab", group = "Tabs" } },
		{ { "Control", "Shift" }, "Tab", nil, { description = "Previous tab", group = "Tabs" } },
		{ { "Control" }, "l", nil, { description = "Focus address bar", group = "Navigation" } },
		{ { "Alt" }, "Left", nil, { description = "Back", group = "Navigation" } },
		{ { "Alt" }, "Right", nil, { description = "Forward", group = "Navigation" } },
		{ {}, "F5", nil, { description = "Reload", group = "Navigation" } },
		{ { "Control" }, "F5", nil, { description = "Reload without cache", group = "Navigation" } },
		{ { "Control" }, "f", nil, { description = "Find in page", group = "Page" } },
		{ { "Control" }, "d", nil, { description = "Bookmark page", group = "Page" } },
		{ { "Control" }, "+", nil, { description = "Zoom in", group = "Page" } },
		{ { "Control" }, "-", nil, { description = "Zoom out", group = "Page" } },
		{ { "Control" }, "0", nil, { description = "Reset zoom", group = "Page" } },
		{ {}, "F11", nil, { description = "Fullscreen", group = "Window" } },
		{ {}, "F12", nil, { description = "Developer tools", group = "Window" } },
		{ { "Control", "Shift" }, "p", nil, { description = "New private window", group = "Window" } },
	}
}

appkeys["firefox-esr"] = appkeys["firefox-esr-esr140"]

appkeys["firefox"] = appkeys["firefox-esr-esr140"]

appkeys["brave-browser"] = {
	style = { column = 2, geometry = { width = 1100 } },
	pack = {
		{ { "Control" }, "t", nil, { description = "New tab", group = "Tabs" } },
		{ { "Control" }, "w", nil, { description = "Close tab", group = "Tabs" } },
		{ { "Control", "Shift" }, "t", nil, { description = "Reopen closed tab", group = "Tabs" } },
		{ { "Control" }, "Tab", nil, { description = "Next tab", group = "Tabs" } },
		{ { "Control", "Shift" }, "Tab", nil, { description = "Previous tab", group = "Tabs" } },
		{ { "Control" }, "l", nil, { description = "Focus address bar", group = "Navigation" } },
		{ { "Alt" }, "Left", nil, { description = "Back", group = "Navigation" } },
		{ { "Alt" }, "Right", nil, { description = "Forward", group = "Navigation" } },
		{ {}, "F5", nil, { description = "Reload", group = "Navigation" } },
		{ { "Control" }, "F5", nil, { description = "Reload without cache", group = "Navigation" } },
		{ { "Control" }, "f", nil, { description = "Find in page", group = "Page" } },
		{ { "Control" }, "+", nil, { description = "Zoom in", group = "Page" } },
		{ { "Control" }, "-", nil, { description = "Zoom out", group = "Page" } },
		{ { "Control" }, "0", nil, { description = "Reset zoom", group = "Page" } },
		{ {}, "F11", nil, { description = "Fullscreen", group = "Window" } },
		{ {}, "F12", nil, { description = "Developer tools", group = "Window" } },
		{ { "Control", "Shift" }, "n", nil, { description = "New private window", group = "Window" } },
		{ { "Control" }, "h", nil, { description = "History", group = "Window" } },
	}
}

return appkeys
