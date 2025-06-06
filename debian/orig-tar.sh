#!/bin/bash
set -x
# Called from uscan with parameters:
# --upstream-version <release>
set -e

UPSTREAM_VERSION="$2"
#MANGLED_UPSTREAM_VERSION="$(echo "$UPSTREAM_VERSION" | sed 's/-\(alpha\|pre\)/~\1/')+repack"
MANGLED_UPSTREAM_VERSION="$UPSTREAM_VERSION+repack"

PACKAGE=med-fichier
DOWNLOADED_TARBALL=../${PACKAGE}_${UPSTREAM_VERSION}.orig.tar.gz

DEBIAN_SOURCE_DIR="$PACKAGE-$MANGLED_UPSTREAM_VERSION"
TAR="../${PACKAGE}_$MANGLED_UPSTREAM_VERSION.orig.tar.gz"

# extract the upstream archive
mkdir $DEBIAN_SOURCE_DIR
tar xf $DOWNLOADED_TARBALL -C $DEBIAN_SOURCE_DIR --strip 1

# Remove doxygen generated files
# After html-clean and maintainer-clean-local of doc/html.dox/Makefile.am
pushd $DEBIAN_SOURCE_DIR/doc/html.dox
rm -f *.html *.jpg *.gif *.png *.map *.css *.md5 *.dot *.svg *.js htmllistfile1.am.tmp htmllistfile2.am.tmp htmllistfile3.am.tmp med.tag
rm htmllistfile1.am && touch htmllistfile1.am
rm htmllistfile2.am && touch htmllistfile2.am
rm htmllistfile3.am && touch htmllistfile3.am
popd

# repack into orig.tar.gz
tar -c -z -f "$TAR" "$DEBIAN_SOURCE_DIR/"
rm -rf "$DEBIAN_SOURCE_DIR" "$(readlink -f "$DOWNLOADED_TARBALL")" "$DOWNLOADED_TARBALL"

echo "$PACKAGE: cleaned docs and renamed archive to $(basename "$TAR")"
