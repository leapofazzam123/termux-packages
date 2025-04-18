TERMUX_PKG_HOMEPAGE=https://www.lesbonscomptes.com/recoll/index.html
TERMUX_PKG_DESCRIPTION="Full-text search for your desktop"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.34.0
TERMUX_PKG_SRCURL=https://www.lesbonscomptes.com/recoll/recoll-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=7baeaac2c79dcbff6d866f986c2d538603f25378dd71862f2cb7e775c6594668
TERMUX_PKG_DEPENDS="aspell, file, libc++, libiconv, libxapian, libxml2, libxslt, zlib"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
ac_cv_path_aspellProg=$TERMUX_PREFIX/bin/aspell
--with-file-command=$TERMUX_PREFIX/bin/file
--disable-userdoc
--disable-python-chm
--disable-python-aspell
--disable-x11mon
--disable-qtgui
"

termux_step_pre_configure() {
	LDFLAGS+=" $($CC -print-libgcc-file-name)"
	CXXFLAGS+=" -fPIC"
	_PYTHON_VERSION=$(source $TERMUX_SCRIPTDIR/packages/python/build.sh; echo $_MAJOR_VERSION)
	CPPFLAGS+=" -I${TERMUX_PREFIX}/include/python${_PYTHON_VERSION}/"

	termux_setup_python_crossenv
	pushd $TERMUX_PYTHON_CROSSENV_SRCDIR
	_CROSSENV_PREFIX=$TERMUX_PKG_BUILDDIR/python-crossenv-prefix
	python${_PYTHON_VERSION} -m crossenv \
		$TERMUX_PREFIX/bin/python${_PYTHON_VERSION} \
		${_CROSSENV_PREFIX}
	popd
	. ${_CROSSENV_PREFIX}/bin/activate
	build-pip install wheel

	echo "Applying python-recoll-setup.py.in.diff"
	sed "s|@PYTHON_VERSION@|${_PYTHON_VERSION}|g" \
		$TERMUX_PKG_BUILDER_DIR/python-recoll-setup.py.in.diff \
		| patch --silent -p1
}

termux_step_post_massage() {
	# Regression test for https://github.com/termux/termux-packages/issues/14293
	if ! readelf -d bin/recollindex | grep -E -q \
		'\(RUNPATH\).*(\[|:)'"${TERMUX_PREFIX//./\\.}"'/lib/recoll(:|\])'; then
		termux_error_exit "RUNPATH for recollindex is not properly set."
	fi
}
