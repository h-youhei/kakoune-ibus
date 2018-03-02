# IBus controller for Kakoune
## Feature
Turn off ibus when you go back normal mode.

If you want, restore ibus state when you re-enter insert mode.

## Install
clone this repository, symlink ibus.kak to your autoload directory.

write `setup-ibus-auto-switch` or `setup-ibus-auto-off` in your kakrc.

`setup-ibus-auto-off` do only turn off.

`setup-ibus-auto-switch` do both turn off and restore.

To use `setup-ibus-auto-switch`, you should set option `ibus_on`.

`ibus_on` is the engine name when ibus is on.

You can get the engine name following steps.

1. put `ibus engine` on shell command line
2. turn on ibus by pressing hot key
3. press enter

If your keyboard layout is not 'us', you also have to set option `ibus_off`.

You can get the layout name by running `ibus engine`.
