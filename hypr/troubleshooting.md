# Hyprland Configuration Troubleshooting

This file records known differences between `hyprland.conf` and the Lua configuration.

## QT platform selection

The legacy configuration ends with `QT_QPA_PLATFORM=wayland`, because
`hypr.d/05-theme.conf` overrides the earlier `wayland;xcb` value.

The Lua configuration sets `QT_QPA_PLATFORM=wayland;xcb` in
`hypr.d/05-theme.lua`. If Qt applications behave differently between the two
configurations, check this value first.

## Fullscreen bindings

The legacy configuration uses two different fullscreen modes:

- `SUPER+F`: `fullscreen, 1`
- `SUPER+SHIFT+F`: `fullscreen, 0`

The Lua configuration currently calls `hl.dsp.window.fullscreen()` for both
bindings. If these shortcuts do not provide the same mode-specific behavior,
the Lua bindings need explicit fullscreen mode arguments.

## Dark theme command timing

The legacy configuration runs the dark-theme command with `exec` while the
configuration is processed. The Lua configuration registers it for the
`config.reloaded` event in `hypr.d/05-theme.lua`.

If the dark theme is not applied after starting Hyprland, but is applied after
reloading the configuration, the event handler is not running during initial
startup. In that case, add an equivalent startup invocation while retaining the
reload handler.
