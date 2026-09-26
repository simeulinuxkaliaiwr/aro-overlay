# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit git-r3 meson optfeature xdg

DESCRIPTION="Minimal tiling Wayland compositor with spring animations"
HOMEPAGE="https://github.com/simeulinuxkaliaiwr/aro"
EGIT_REPO_URI="https://github.com/simeulinuxkaliaiwr/aro.git"

LICENSE="MIT"
SLOT="0"
IUSE="effects +wallpaper X"

DEPEND="
	dev-libs/libinput:=
	dev-libs/wayland
	gui-libs/wlroots:0.20[X?]
	x11-libs/cairo
	x11-libs/libdrm
	x11-libs/libxkbcommon
	x11-libs/pango
	x11-libs/pixman
	effects? (
		gui-libs/scenefx:0.5
		media-libs/libglvnd
	)
	X? (
		x11-libs/libxcb:=
		x11-libs/xcb-util-wm
	)
	wallpaper? ( x11-libs/gdk-pixbuf:2 )
"
RDEPEND="
	${DEPEND}
	X? ( x11-base/xwayland )
"
BDEPEND="
	dev-libs/wayland-protocols
	dev-util/wayland-scanner
	virtual/pkgconfig
"

src_configure() {
	local emesonargs=(
		$(meson_use effects)
		$(meson_feature X xwayland)
		$(meson_feature wallpaper)
	)
	meson_src_configure
}

src_install() {
	meson_src_install

	# gentoo keeps docs under ${PF}; left uncompressed so it can be copied as is
	dodir /usr/share/doc/${PF}
	mv "${ED}"/usr/share/doc/aro/config.example "${ED}"/usr/share/doc/${PF}/ || die
	rmdir "${ED}"/usr/share/doc/aro || die
	docompress -x /usr/share/doc/${PF}/config.example
}

pkg_postinst() {
	xdg_pkg_postinst

	optfeature "screen sharing and screenshots" gui-libs/xdg-desktop-portal-wlr
	optfeature "file pickers and other portal dialogs" sys-apps/xdg-desktop-portal-gtk
	optfeature "SVG wallpapers, including the default one" gnome-base/librsvg
	optfeature "the default terminal (mod+Return)" gui-apps/foot
	optfeature "the default launcher (mod+d)" gui-apps/fuzzel

	elog "To start from the example config:"
	elog "    mkdir -p ~/.config/aro"
	elog "    cp /usr/share/doc/${PF}/config.example ~/.config/aro/config"
	elog "Without systemd, start aro inside a D-Bus session so portals work:"
	elog "    dbus-run-session aro"
}
