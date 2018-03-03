declare-option -docstring ' engine name when ibus is on
You can get the engine name by following steps
1. put \'ibus engine\' on shell command line 
2. turn ibus on (press hot key)
3. press enter' \
str ibus_on ''

declare-option  -docstring ' engine name when ibus is off
You can get the engine name by running \'ibus engine\'' \
str ibus_off 'xkb:us::eng'

declare-option  -hidden bool ibus_was_on false

define-command ibus-turn-on %{ %sh{
	ibus engine $kak_opt_ibus_on
}}

define-command ibus-turn-off %{ %sh{
	ibus engine $kak_opt_ibus_off
}}

define-command -hidden ibus-turn-off-with-state %{ %sh{
	state=`ibus engine`
	if [ $state = $kak_opt_ibus_on ] ; then
		echo 'set-option global ibus_was_on true'
	else
		echo 'set-option global ibus_was_on false'
	fi
	echo 'ibus-turn-off'
}}

define-command -hidden ibus-restore-state %{ %sh{
	[ $kak_opt_ibus_was_on = true ] && echo 'ibus-turn-on'
}}

define-command  -docstring 'Turn off ibus when you go back normal mode.
Turn on ibus when you enter insert mode,
if it was on when you left insert mode last time.
To use this feature correctly, you should set option \'ibus_on\'' \
setup-ibus-auto-switch %{
	remove-hooks global ibus
	hook -group ibus global ModeChange insert:normal %{ ibus-turn-off-with-state }
	hook -group ibus global ModeChange normal:insert %{ ibus-restore-state }
	hook -group ibus global ModeChange prompt:normal %{ ibus-turn-off }
}

define-command -docstring 'turn off ibus when you go back normal mode.' \
setup-ibus-auto-off %{
	remove-hooks global ibus
	hook -group ibus global ModeChange insert:normal %{ ibus-turn-off }
	hook -group ibus global ModeChange prompt:normal %{ ibus-turn-off }
}
