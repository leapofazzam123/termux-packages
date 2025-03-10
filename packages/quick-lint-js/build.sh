TERMUX_PKG_HOMEPAGE=https://quick-lint-js.com/
TERMUX_PKG_DESCRIPTION="Finds bugs in JavaScript programs"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.10.0"
TERMUX_PKG_SRCURL=git+https://github.com/quick-lint/quick-lint-js
TERMUX_PKG_GIT_BRANCH=$TERMUX_PKG_VERSION
TERMUX_PKG_DEPENDS="libc++"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="-DBUILD_TESTING=OFF"
TERMUX_PKG_AUTO_UPDATE=true
