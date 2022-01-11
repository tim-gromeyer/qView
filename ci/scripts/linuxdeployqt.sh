#!/usr/bin/bash

if [ $0 != "" ]; then
        VERSION=$0
else
        VERSION=$(LC_ALL=C sed -n -e '/^VERSION/p' qView.pro)
        VERSION=${VERSION: -3}
fi

echo VERSION was set to $VERSION
if [[ $1 == *"-extra-plugins"* ]]; then
        PLUGINS=$1
fi

wget -c -nv "https://github.com/probonopd/linuxdeployqt/releases/download/continuous/linuxdeployqt-continuous-x86_64.AppImage"
chmod a+x linuxdeployqt-continuous-x86_64.AppImage

mkdir -p bin/appdir/usr
make install INSTALL_ROOT=bin/appdir
cp dist/linux/hicolor/scalable/apps/com.interversehq.qView.svg bin/appdir/
cd bin
rm qview
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/lib/
../linuxdeployqt-continuous-x86_64.AppImage appdir/usr/share/applications/com.interversehq.qView.desktop -appimage -updateinformation="gh-releases-zsync|jurplel|qView|latest|qView-*x86_64.AppImage.zsync" $PLUGINS

if [ $0 != "" ]; then
    mv *.AppImage qView-nightly-$(buildNumString)-x86_64.AppImage
else
    mv *.AppImage qView-$VERSION-x86_64.AppImage
fi
rm -r appdir