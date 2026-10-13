-----------------------------------------------------------------------------------------------------------------------
--                                      Application aliases for tasklist widget                                      --
-----------------------------------------------------------------------------------------------------------------------
-- Key is the window class (second WM_CLASS string, see `xprop WM_CLASS`), value is the short tasklist label.
-- Apps without an alias get the first 5 letters of their class in upper case.

local appnames = {}

-- browsers
appnames["firefox-esr-esr140"   ] = "FFOX"
appnames["firefox-esr"          ] = "FFOX"
appnames["firefox"              ] = "FFOX"
appnames["Firefox"              ] = "FFOX"
appnames["Pale moon"            ] = "PALE"
appnames["Brave-browser"        ] = "BRAVE"

-- communication
appnames["thunderbird"          ] = "TBIRD"
appnames["TelegramDesktop"      ] = "TGRAM"
appnames["discord"              ] = "DISC"
appnames["com.anthropic.Claude" ] = "CLAUDE"

-- files and terminals
appnames["krusader"             ] = "KRUS"
appnames["dolphin"              ] = "DOLPH"
appnames["konsole"              ] = "KONS"
appnames["yakuake"              ] = "YAKU"
appnames["XTerm"                ] = "XTERM"

-- development
appnames["jetbrains-pycharm"    ] = "PYCH"
appnames["jetbrains-pycharm-ce" ] = "PYCH"
appnames["Code"                 ] = "CODE"
appnames["Sublime_text"         ] = "SUBL"
appnames["Godot"                ] = "GODOT"
appnames["Godot_Engine"         ] = "GODOT"
appnames["Poedit"               ] = "POED"

-- media and graphics
appnames["Deadbeef"             ] = "DBEEF"
appnames["obs"                  ] = "OBS"
appnames["Gimp"                 ] = "GIMP"
appnames["Gimp-2.10"            ] = "GIMP"
appnames["gwenview"             ] = "GWEN"
appnames["okular"               ] = "OKUL"
appnames["spectacle"            ] = "SHOT"

-- system
appnames["Pavucontrol"          ] = "PAVU"
appnames["pavucontrol"          ] = "PAVU"
appnames["copyq"                ] = "COPYQ"
appnames["steam"                ] = "STEAM"

return appnames
