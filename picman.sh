sudo apt install build-essential libxext-dev libxcb1-dev libxcb-damage0-dev libxcb-xfixes0-dev libxcb-shape0-dev libxcb-render-util0-dev libxcb-render0-dev libxcb-randr0-dev libxcb-composite0-dev libxcb-image0-dev libxcb-present-dev libxcb-xinerama0-dev libxcb-glx0-dev libpixman-1-dev libdbus-1-dev libconfig-dev libgl1-mesa-dev  libpcre2-dev  libevdev-dev uthash-dev libev-dev libpcre3-dev libx11-xcb-dev ninja-build meson
git clone https://github.com/yshui/picom.git && cd picom/
git submodule update --init --recursive
meson --buildtype=release . build
ninja -C build
ninja -C build install

git clone https://github.com/nwg-piotr/psuinfo.git && cd psuinfo/
sudo cp -r {psuinfo,icons} /usr/bin

git clone https://github.com/firecat53/networkmanager-dmenu.git && cd networkmanager-dmenu/
sudo cp networkmanager_dmenu /usr/bin
