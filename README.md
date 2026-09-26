# aro-overlay

Gentoo overlay for [aro](https://github.com/simeulinuxkaliaiwr/aro), a
tiling Wayland compositor.

## Adding it

```sh
eselect repository add aro git https://github.com/simeulinuxkaliaiwr/aro-overlay.git
emaint sync -r aro
echo "gui-wm/aro **" >> /etc/portage/package.accept_keywords/aro
emerge -av gui-wm/aro
```

`aro-9999` builds the latest commit, so it has no keywords; the line above
accepts it.

## USE flags

- `X`: XWayland, for X11 applications.
- `wallpaper` (default on): `aropaper`, aro's wallpaper client.
- `effects`: rounded corners and shadows. Needs `gui-libs/scenefx` from
  [GURU](https://wiki.gentoo.org/wiki/Project:GURU):

  ```sh
  eselect repository enable guru
  emaint sync -r guru
  echo "gui-libs/scenefx ~amd64" >> /etc/portage/package.accept_keywords/aro
  echo "gui-wm/aro effects" >> /etc/portage/package.use/aro
  ```

Without systemd, start aro with `dbus-run-session aro` so portals work.
