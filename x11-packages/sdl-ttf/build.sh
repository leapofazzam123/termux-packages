TERMUX_PKG_HOMEPAGE=https://www.libsdl.org/projects/SDL_ttf
TERMUX_PKG_DESCRIPTION="A companion library to SDL for working with TrueType (tm) fonts"
TERMUX_PKG_LICENSE="ZLIB"
TERMUX_PKG_MAINTAINER="@Yonle"
_COMMIT=2648c22c4f9e32d05a11b32f636b1c225a1502ac
_COMMIT_DATE=20220526
TERMUX_PKG_VERSION=2.0.11-p${_COMMIT_DATE}
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=git+https://github.com/libsdl-org/SDL_ttf
TERMUX_PKG_GIT_BRANCH=SDL-1.2
TERMUX_PKG_DEPENDS="freetype, sdl"

termux_step_post_get_source() {
	git fetch --unshallow
	git checkout $_COMMIT

	local pdate="p$(git log -1 --format=%cs | sed 's/-//g')"
	if [[ "$TERMUX_PKG_VERSION" != *"${pdate}" ]]; then
		echo -n "ERROR: The version string \"$TERMUX_PKG_VERSION\" is"
		echo -n " different from what is expected to be; should end"
		echo " with \"${pdate}\"."
		return 1
	fi
}

termux_step_pre_configure() {
	LDFLAGS+=" -lm"
}
