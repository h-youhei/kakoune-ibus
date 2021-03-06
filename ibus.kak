declare-option -docstring "engine name when ibus is on
You can get the engine name by following steps
1. put 'ibus engine' on shell command line
2. turn ibus on (press hot key)
3. press enter" \
str ibus_on ''

declare-option -docstring "engine name when ibus is off
You can get the engine name by running 'ibus engine'" \
str ibus_off 'xkb:us::eng'

declare-option -hidden bool ibus_was_on false

declare-option -docstring "command name that is called
when ibus is turned on" \
str ibus_callback_on ''

declare-option -docstring "command name that is called
when ibus is turned off" \
str ibus_callback_off ''

define-command ibus-turn-on %{ evaluate-commands %sh{
	ibus engine $kak_opt_ibus_on
	if [ -n "$kak_opt_ibus_callback_on" ]; then
		echo $kak_opt_ibus_callback_on
	else
		echo nop
	fi
}}

define-command ibus-turn-off %{ evaluate-commands %sh{
	ibus engine $kak_opt_ibus_off
	if [ -n "$kak_opt_ibus_callback_off" ]; then
		echo $kak_opt_ibus_callback_off
	else
		echo nop
	fi
}}

define-command -hidden ibus-turn-off-with-state %{ evaluate-commands %sh{
	state=`ibus engine`
	if [ $state = $kak_opt_ibus_on ] ; then
		echo 'set-option buffer ibus_was_on true'
		echo 'ibus-turn-off'
	else
		echo 'set-option buffer ibus_was_on false'
	fi
}}

define-command -hidden ibus-restore-state %{ evaluate-commands %sh{
	if [ $kak_opt_ibus_was_on = true ] ; then
		echo 'ibus-turn-on'
	else
		echo nop
	fi
}}

define-command -docstring "Turn off ibus when you go back normal mode.
Turn on ibus when you enter insert mode,
if it was on when you left insert mode last time.
To use this feature correctly, you should set option 'ibus_on'" \
setup-ibus-auto-switch %{
	remove-hooks global ibus
	hook -group ibus global ModeChange pop:insert:normal %{ ibus-turn-off-with-state }
	hook -group ibus global ModeChange push:normal:insert %{ ibus-restore-state }
	hook -group ibus global ModeChange pop:prompt:normal %{ ibus-turn-off }
	hook -group ibus global WinDisplay .* %{ set-option buffer ibus_was_on false }
}

define-command -docstring 'turn off ibus when you go back normal mode.' \
setup-ibus-auto-off %{
	remove-hooks global ibus
	hook -group ibus global ModeChange pop:insert:normal %{ ibus-turn-off }
	hook -group ibus global ModeChange pop:prompt:normal %{ ibus-turn-off }
	hook -group ibus global WinDisplay .* %{ set-option buffer ibus_was_on false }
}
