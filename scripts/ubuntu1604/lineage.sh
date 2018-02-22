#!/bin/bash

# Disable IPv6 or DNS names will resolve to AAAA yet connections will fail.
sysctl net.ipv6.conf.all.disable_ipv6=1

# To allow for autmated installs, we disable interactive configuration steps.
export DEBIAN_FRONTEND=noninteractive

# Install developer tools.
apt-get --assume-yes install vim vim-nox wget curl gnupg mlocate sysstat lsof pciutils usbutils

# Install the build dependencies.
apt-get --assume-yes install bc bison build-essential curl flex g++-multilib gcc-multilib git gnupg gperf imagemagick lib32ncurses5-dev lib32readline6-dev lib32z1-dev libesd0-dev liblz4-tool libncurses5-dev libsdl1.2-dev libssl-dev libwxgtk3.0-dev libxml2 libxml2-utils lzop pngcrush rsync schedtool squashfs-tools xsltproc zip zlib1g-dev ninja-build

# Java 8 Support
apt-get --assume-yes install openjdk-8-jdk openjdk-8-jdk-headless openjdk-8-jre openjdk-8-jre-headless

# Java dependencies
apt-get --assume-yes install maven libatk-wrapper-java libatk-wrapper-java-jni libpng16-16 libsctp1

# Download the OpenJDK 1.7 packages.
curl --output openjdk-7-jre_7u121-2.6.8-2_amd64.deb https://mirrors.kernel.org/debian/pool/main/o/openjdk-7/openjdk-7-jre_7u121-2.6.8-2_amd64.deb
curl --output openjdk-7-jre-headless_7u121-2.6.8-2_amd64.deb https://mirrors.kernel.org/debian/pool/main/o/openjdk-7/openjdk-7-jre-headless_7u121-2.6.8-2_amd64.deb
curl --output openjdk-7-jdk_7u121-2.6.8-2_amd64.deb https://mirrors.kernel.org/debian/pool/main/o/openjdk-7/openjdk-7-jdk_7u121-2.6.8-2_amd64.deb
curl --output libjpeg62-turbo_1.5.1-2_amd64.deb https://mirrors.kernel.org/debian/pool/main/libj/libjpeg-turbo/libjpeg62-turbo_1.5.1-2_amd64.deb

# Install via dpkg.
dpkg -i openjdk-7-jre_7u121-2.6.8-2_amd64.deb openjdk-7-jre-headless_7u121-2.6.8-2_amd64.deb openjdk-7-jdk_7u121-2.6.8-2_amd64.deb libjpeg62-turbo_1.5.1-2_amd64.deb

# Assuming the OpenJDK has dependencies... install them here.
apt --assume-yes install -f

# Setup OpenJDK 1.7 as the default, which is required for the 13.0 branch.
update-java-alternatives -s java-1.7.0-openjdk-amd64

# Delete the downloaded Java 7 packages.
rm --force openjdk-7-jre_7u121-2.6.8-2_amd64.deb openjdk-7-jre-headless_7u121-2.6.8-2_amd64.deb openjdk-7-jdk_7u121-2.6.8-2_amd64.deb libjpeg62-turbo_1.5.1-2_amd64.deb

# Enable the source code repositories.
sed -i -e "s|.*deb-src |deb-src |g" /etc/apt/sources.list
apt-get --assume-yes update

# Ensure the dependencies required to compile git are available.
apt-get --assume-yes install build-essential fakeroot dpkg-dev
apt-get --assume-yes build-dep git

# The build-dep command will remove the OpenSSL version of libcurl, so we have to
# install here instead.
apt-get --assume-yes install libcurl4-openssl-dev

# Download the git sourcecode.
mkdir -p $HOME/git-openssl && cd $HOME/git-openssl
apt-get source git
dpkg-source -x `find * -type f -name *.dsc`
cd `find * -maxdepth 0 -type d`

# Recompile git using OpenSSL instead of gnutls.
sed -i -e "s|libcurl4-gnutls-dev|libcurl4-openssl-dev|g" debian/control
sed -i -e "/TEST[ ]*=test/d" debian/rules
dpkg-buildpackage -rfakeroot -b

# Insall the new version.
dpkg -i `find ../* -type f -name *amd64.deb`

# Cleanup the git build directory.
cd $HOME && rm --force --recursive $HOME/git-openssl

# Download the Android tools.
curl --output platform-tools-latest-linux.zip https://dl.google.com/android/repository/platform-tools-latest-linux.zip

# Install the platform tools.
unzip platform-tools-latest-linux.zip -d /usr/local/

# Delete the downloaded tools archive.
rm --force platform-tools-latest-linux.zip

# Ensure the platform tools are in the binary search path.
printf "PATH=/usr/local/platform-tools/:$PATH\n" > /etc/profile.d/platform-tools.sh

# Install the repo utility.
curl https://storage.googleapis.com/git-repo-downloads/repo > /usr/bin/repo
chmod a+x /usr/bin/repo

# Setup the android udev rules.
cat <<-EOF | base64 --decode > /etc/udev/rules.d/51-android.rules
IyBUaGVzZSBydWxlcyByZWZlcjogaHR0cHM6Ly9kZXZlbG9wZXIuYW5kcm9pZC5jb20vc3R1ZGlv
L3J1bi9kZXZpY2UuaHRtbAojIGFuZCBpbmNsdWRlIG1hbnkgc3VnZ2VzdGlvbnMgZnJvbSBBcmNo
IExpbnV4LCBHaXRIdWIgYW5kIG90aGVyIENvbW11bml0aWVzLgojIExhdGVzdCB2ZXJzaW9uIGNh
biBiZSBmb3VuZCBhdDogaHR0cHM6Ly9naXRodWIuY29tL00wUmYzMC9hbmRyb2lkLXVkZXYtcnVs
ZXMKCiMgU2tpcCB0aGlzIHNlY3Rpb24gYmVsb3cgaWYgdGhpcyBkZXZpY2UgaXMgbm90IGNvbm5l
Y3RlZCBieSBVU0IKU1VCU1lTVEVNIT0idXNiIiwgR09UTz0iYW5kcm9pZF91c2JfcnVsZXNfZW5k
IgoKTEFCRUw9ImFuZHJvaWRfdXNiX3J1bGVzX2JlZ2luIgojIERldmljZXMgbGlzdGVkIGhlcmUg
aW4gYW5kcm9pZF91c2JfcnVsZXNfe2JlZ2luLi4uZW5kfSBhcmUgY29ubmVjdGVkIGJ5IFVTQgoj
CUFjZXIKQVRUUntpZFZlbmRvcn0hPSIwNTAyIiwgR09UTz0ibm90X0FjZXIiCkVOVnthZGJfdXNl
cn09InllcyIKIwkJSWNvbmlhIFRhYiBBMS04MzAKQVRUUntpZFByb2R1Y3R9PT0iMzYwNCIsIEVO
VnthZGJfYWRiZmFzdH09InllcyIKIwkJSWNvbmlhIFRhYiBBNTAwCkFUVFJ7aWRQcm9kdWN0fT09
IjMzMjUiLCBFTlZ7YWRiX2FkYmZhc3R9PSJ5ZXMiCiMJCUxpcXVpZCAoMzIwMj1ub3JtYWwsMzIw
Mz1kZWJ1ZykKQVRUUntpZFByb2R1Y3R9PT0iMzIwMyIsIFNZTUxJTksrPSJhbmRyb2lkX2FkYiIK
R09UTz0iYW5kcm9pZF91c2JfcnVsZV9tYXRjaCIKTEFCRUw9Im5vdF9BY2VyIgoKIwlBY3Rpb25z
IFNlbWljb25kdWN0b3IgQ28uLCBMdGQKQVRUUntpZFZlbmRvcn09PSIxMGQ2IiwgRU5We2FkYl91
c2VyfT0ieWVzIgojCQlEZW52ZXIgVEFEIDcwMTExCkFUVFJ7aWRQcm9kdWN0fT09IjBjMDIiLCBT
WU1MSU5LKz0iYW5kcm9pZF9hZGIiCgojCUFEVkFOQ0UKQVRUUntpZFZlbmRvcn09PSIwYTVjIiwg
RU5We2FkYl91c2VyfT0ieWVzIgojCQlTNQpBVFRSe2lkUHJvZHVjdH09PSJlNjgxIiwgU1lNTElO
Sys9ImFuZHJvaWRfYWRiIgoKIwlBbWF6b24gTGFiMTI2CkFUVFJ7aWRWZW5kb3J9PT0iMTk0OSIs
IEVOVnthZGJfdXNlcn09InllcyIKIwkJQW1hem9uIEtpbmRsZSBGaXJlCkFUVFJ7aWRQcm9kdWN0
fT09IjAwMDYiLCBFTlZ7YWRiX2FkYmZhc3R9PSJ5ZXMiCgojCUFyY2hvcwpBVFRSe2lkVmVuZG9y
fSE9IjBlNzkiLCBHT1RPPSJub3RfQXJjaG9zIgpFTlZ7YWRiX3VzZXJ9PSJ5ZXMiCiMJCTQzCkFU
VFJ7aWRQcm9kdWN0fT09IjE0MTciLCBFTlZ7YWRiX2FkYmZhc3R9PSJ5ZXMiCiMJCTEwMQpBVFRS
e2lkUHJvZHVjdH09PSIxNDExIiwgRU5We2FkYl9hZGJmYXN0fT0ieWVzIgojCQkxMDEgeHMKQVRU
UntpZFByb2R1Y3R9PT0iMTU0OSIsIEVOVnthZGJfYWRiZmFzdH09InllcyIKR09UTz0iYW5kcm9p
ZF91c2JfcnVsZV9tYXRjaCIKTEFCRUw9Im5vdF9BcmNob3MiCgojCUFTVVNUZUsKQVRUUntpZFZl
bmRvcn0hPSIwYjA1IiwgR09UTz0ibm90X0FzdXMiCiMJCUZhbHNlIHBvc2l0aXZlIC0gYWNjZXNz
b3J5CkFUVFJ7aWRQcm9kdWN0fT09IjE/Pz8iLCBHT1RPPSJhbmRyb2lkX3VzYl9ydWxlc19lbmQi
CkVOVnthZGJfdXNlcn09InllcyIKIwkJWmVucGhvbmUgNSAoNGM5MD1ub3JtYWwsNGM5MT1kZWJ1
Zyw0ZGFmPUZhc3Rib290KQpBVFRSe2lkUHJvZHVjdH09PSI0YzkxIiwgU1lNTElOSys9ImFuZHJv
aWRfYWRiIgpBVFRSe2lkUHJvZHVjdH09PSI0ZGFmIiwgU1lNTElOSys9ImFuZHJvaWRfZmFzdGJv
b3QiCiMJCVRlZ3JhIEFQWApBVFRSe2lkUHJvZHVjdH09PSI3MDMwIgpHT1RPPSJhbmRyb2lkX3Vz
Yl9ydWxlX21hdGNoIgpMQUJFTD0ibm90X0FzdXMiCgojCUF6cGVuIE9uZGEKQVRUUntpZFZlbmRv
cn09PSIxZjNhIiwgRU5We2FkYl91c2VyfT0ieWVzIgoKIwlCUQpBVFRSe2lkVmVuZG9yfSE9IjJh
NDciLCBHT1RPPSJub3RfQlEiCkVOVnthZGJfdXNlcn09InllcyIKIwkJQXF1YXJpcyA0LjUKQVRU
UntpZFByb2R1Y3R9PT0iMGMwMiIsIEVOVnthZGJfYWRiZmFzdH09InllcyIKQVRUUntpZFByb2R1
Y3R9PT0iMjAwOCIsIEVOVnthZGJfYWRiZmFzdH09InllcyIKR09UTz0iYW5kcm9pZF91c2JfcnVs
ZV9tYXRjaCIKTEFCRUw9Im5vdF9CUSIKCiMJRGVsbApBVFRSe2lkVmVuZG9yfT09IjQxM2MiLCBF
TlZ7YWRiX3VzZXJ9PSJ5ZXMiCgojCUZhaXJwaG9uZSAyCkFUVFJ7aWRWZW5kb3J9PT0iMmFlNSIs
IEVOVnthZGJfdXNlcn09InllcyIKCiMJRm94Y29ubgpBVFRSe2lkVmVuZG9yfT09IjA0ODkiLCBF
TlZ7YWRiX3VzZXJ9PSJ5ZXMiCiMJCUNvbW10aXZhIFo3MSwgR2Vla3NwaG9uZSBPbmUKQVRUUntp
ZFZlbmRvcn09PSIwNDg5IiwgQVRUUntpZFByb2R1Y3R9PT0iYzAwMSIsIFNZTUxJTksrPSJhbmRy
b2lkX2FkYiIKCiMJRnVqaXRzdS9GdWppdHN1IFRvc2hpYmEKQVRUUntpZFZlbmRvcn09PSIwNGM1
IiwgRU5We2FkYl91c2VyfT0ieWVzIgoKIwlGdXpob3UgUm9ja2NoaXAgRWxlY3Ryb25pY3MKQVRU
UntpZFZlbmRvcn09PSIyMjA3IiwgRU5We2FkYl91c2VyfT0ieWVzIgojCQlNZWRpYWNvbSBTbWFy
dHBhZCA3MTVpCkFUVFJ7aWRWZW5kb3J9PT0iMjIwNyIsIEFUVFJ7aWRQcm9kdWN0fT09IjAwMDAi
LCBTWU1MSU5LKz0iYW5kcm9pZF9hZGIiCiMJCVViaXNsYXRlIDdDaQpBVFRSe2lkVmVuZG9yfT09
IjIyMDciLCBBVFRSe2lkUHJvZHVjdH09PSIwMDEwIiwgU1lNTElOSys9ImFuZHJvaWRfYWRiIgoK
IwlHYXJtaW4tQXN1cwpBVFRSe2lkVmVuZG9yfT09IjA5MWUiLCBFTlZ7YWRiX3VzZXJ9PSJ5ZXMi
CgojCUdvb2dsZQpBVFRSe2lkVmVuZG9yfSE9IjE4ZDEiLCBHT1RPPSJub3RfR29vZ2xlIgpFTlZ7
YWRiX3VzZXJ9PSJ5ZXMiCiMgICAgICAgICAgICAgICBOZXh1cyA2UCAoNGVlMD1mYXN0Ym9vdCkK
QVRUUntpZFByb2R1Y3R9PT0iNGVlNyIsIFNZTUxJTksrPSJhbmRyb2lkX2FkYiIKIwkJTmV4dXMg
NCwgTmV4dXMgNyAyMDEzCkFUVFJ7aWRQcm9kdWN0fT09IjRlZTIiLCBTWU1MSU5LKz0iYW5kcm9p
ZF9hZGIiCkFUVFJ7aWRQcm9kdWN0fT09IjRlZTAiLCBTWU1MSU5LKz0iYW5kcm9pZF9mYXN0Ym9v
dCIKIwkJTmV4dXMgNwpBVFRSe2lkUHJvZHVjdH09PSI0ZTQyIiwgU1lNTElOSys9ImFuZHJvaWRf
YWRiIgpBVFRSe2lkUHJvZHVjdH09PSI0ZTQwIiwgU1lNTElOSys9ImFuZHJvaWRfZmFzdGJvb3Qi
CiMJCU5leHVzIDUsIE5leHVzIDEwCkFUVFJ7aWRQcm9kdWN0fT09IjRlZTEiLCBFTlZ7YWRiX2Fk
YmZhc3R9PSJ5ZXMiCiMJCU5leHVzIFMKQVRUUntpZFByb2R1Y3R9PT0iNGUyMSIKQVRUUntpZFBy
b2R1Y3R9PT0iNGUyMiIsIFNZTUxJTksrPSJhbmRyb2lkX2FkYiIKQVRUUntpZFByb2R1Y3R9PT0i
NGUyMCIsIFNZTUxJTksrPSJhbmRyb2lkX2Zhc3Rib290IgojCQlHYWxheHkgTmV4dXMKQVRUUntp
ZFByb2R1Y3R9PT0iNGUzMCIsIEVOVnthZGJfYWRiZmFzdH09InllcyIKIwkJTmV4dXMgT25lICg0
ZTExPW5vcm1hbCw0ZTEyPWRlYnVnLDBmZmY9ZGVidWcpCkFUVFJ7aWRQcm9kdWN0fT09IjRlMTIi
LCBTWU1MSU5LKz0iYW5kcm9pZF9hZGIiCkFUVFJ7aWRQcm9kdWN0fT09IjBmZmYiLCBTWU1MSU5L
Kz0iYW5kcm9pZF9mYXN0Ym9vdCIKIwkJR2VuZXJpYyBhbmQgdW5zcGVjaWZpZWQgZGVidWcgaW50
ZXJmYWNlCkFUVFJ7aWRQcm9kdWN0fT09ImQwMGQiLCBTWU1MSU5LKz0iYW5kcm9pZF9mYXN0Ym9v
dCIKIwkJSW5jbHVkZTogU2Ftc3VuZyBHYWxheHkgTmV4dXMgKEdTTSkKQVRUUntpZFByb2R1Y3R9
PT0iNGUzMCIsIFNZTUxJTksrPSJhbmRyb2lkX2Zhc3Rib290IgojCQlSZWNvdmVyeSBhZGIgZW50
cnkgZm9yIE5leHVzIEZhbWlseSAob3JpZyBkMDAxLCBPUDMgaGFzIDE4ZDE6ZDAwMikKQVRUUntp
ZFByb2R1Y3R9PT0iZDAwPyIsIFNZTUxJTksrPSJhbmRyb2lkX2FkYiIKR09UTz0iYW5kcm9pZF91
c2JfcnVsZV9tYXRjaCIKTEFCRUw9Im5vdF9Hb29nbGUiCgojCUhhaWVyCkFUVFJ7aWRWZW5kb3J9
PT0iMjAxZSIsIEVOVnthZGJfdXNlcn09InllcyIKCiMJSGlzZW5zZQpBVFRSe2lkVmVuZG9yfT09
IjEwOWIiLCBFTlZ7YWRiX3VzZXJ9PSJ5ZXMiCgojCUhvbmV5d2VsbC9Gb3hjb25uCkFUVFJ7aWRW
ZW5kb3J9IT0iMGMyZSIsIEdPVE89Im5vdF9Ib25leXdlbGwiCkVOVnthZGJfdXNlcn09InllcyIK
IwkJRDcwZQpBVFRSe2lkUHJvZHVjdH09PSIwYmEzIiwgU1lNTElOSys9ImFuZHJvaWRfYWRiIgpH
T1RPPSJhbmRyb2lkX3VzYl9ydWxlX21hdGNoIgpMQUJFTD0ibm90X0hvbmV5d2VsbCIKCiMJSFRD
CkFUVFJ7aWRWZW5kb3J9IT0iMGJiNCIsIEdPVE89Im5vdF9IVEMiCkVOVnthZGJfdXNlcn09Inll
cyIKIwkJZmFzdGJvb3QgbW9kZSBlbmFibGVkCkFUVFJ7aWRQcm9kdWN0fT09IjBmZmYiLCBFTlZ7
YWRiX2FkYmZhc3R9PSJ5ZXMiLCBHT1RPPSJhbmRyb2lkX3VzYl9ydWxlX21hdGNoIgojCQlDaGFD
aGEKQVRUUntpZFByb2R1Y3R9PT0iMGNiMiIsIEVOVnthZGJfYWRiZmFzdH09InllcyIKIwkJRGVz
aXJlIChCcmF2bykKQVRUUntpZFByb2R1Y3R9PT0iMGM4NyIsIFNZTUxJTksrPSJhbmRyb2lkX2Fk
YiIKIwkJRGVzaXJlIEhECkFUVFJ7aWRQcm9kdWN0fT09IjBjYTIiLCBTWU1MSU5LKz0iYW5kcm9p
ZF9hZGIiCiMJCURlc2lyZSBTIChTYWdhKQpBVFRSe2lkUHJvZHVjdH09PSIwY2FiIiwgU1lNTElO
Sys9ImFuZHJvaWRfYWRiIgojCQlEZXNpcmUgWgpBVFRSe2lkUHJvZHVjdH09PSIwYzkxIiwgRU5W
e2FkYl9hZGJmYXN0fT0ieWVzIgojCQlFdm8gU2hpZnQKQVRUUntpZFByb2R1Y3R9PT0iMGNhNSIs
IFNZTUxJTksrPSJhbmRyb2lkX2FkYiIKIwkJRzEKQVRUUntpZFByb2R1Y3R9PT0iMGMwMSIsIEVO
VnthZGJfYWRiZmFzdH09InllcyIKIwkJSEQyCkFUVFJ7aWRQcm9kdWN0fT09IjBjMDIiLCBFTlZ7
YWRiX2FkYmZhc3R9PSJ5ZXMiCiMJCUhlcm8gSDIwMDAKQVRUUntpZFByb2R1Y3R9PT0iMDAwMSIs
IEVOVnthZGJfYWRiZmFzdH09InllcyIKIwkJSGVybyAoR1NNKSwgRGVzaXJlCkFUVFJ7aWRQcm9k
dWN0fT09IjBjOTkiLCBTWU1MSU5LKz0iYW5kcm9pZF9hZGIiCiMJCUhlcm8gKENETUEpCkFUVFJ7
aWRQcm9kdWN0fT09IjBjOWEiLCBTWU1MSU5LKz0iYW5kcm9pZF9hZGIiCiMJCUluY3JlZGlibGUK
QVRUUntpZFByb2R1Y3R9PT0iMGM5ZSIsIFNZTUxJTksrPSJhbmRyb2lkX2FkYiIKIwkJSW5jcmVk
aWJsZSByZXYgMDAwMgpBVFRSe2lkUHJvZHVjdH09PSIwYzhkIiwgU1lNTElOSys9ImFuZHJvaWRf
YWRiIgojCQlNeVRvdWNoIDRHCkFUVFJ7aWRQcm9kdWN0fT09IjBjOTYiLCBTWU1MSU5LKz0iYW5k
cm9pZF9hZGIiCiMJCU9uZSAobTcpICYmIE9uZSAobTgpCkFUVFJ7aWRQcm9kdWN0fT09IjBjOTMi
CiMJCVNlbnNhdGlvbgpBVFRSe2lkUHJvZHVjdH09PSIwZjg3IiwgU1lNTElOSys9ImFuZHJvaWRf
YWRiIgpBVFRSe2lkUHJvZHVjdH09PSIwZmYwIiwgU1lNTElOSys9ImFuZHJvaWRfZmFzdGJvb3Qi
CiMJCU9uZSBWCkFUVFJ7aWRQcm9kdWN0fT09IjBjZTUiLCBTWU1MSU5LKz0iYW5kcm9pZF9hZGIi
CiMJCVNsaWRlCkFUVFJ7aWRQcm9kdWN0fT09IjBlMDMiLCBTWU1MSU5LKz0iYW5kcm9pZF9hZGIi
CiMJCVRhdG9vLCBEcmVhbSwgQURQMSwgRzEsIE1hZ2ljCkFUVFJ7aWRQcm9kdWN0fT09IjBjMDEi
CkFUVFJ7aWRQcm9kdWN0fT09IjBjMDIiLCBFTlZ7YWRiX2FkYmZhc3R9PSJ5ZXMiCiMJCVZpc2lv
bgpBVFRSe2lkUHJvZHVjdH09PSIwYzkxIiwgU1lNTElOSys9ImFuZHJvaWRfYWRiIgojCQlXaWxk
ZmlyZQpBVFRSe2lkUHJvZHVjdH09PSIwYzhiIiwgRU5We2FkYl9hZGJmYXN0fT0ieWVzIgojCQlX
aWxkZmlyZSBTCkFUVFJ7aWRQcm9kdWN0fT09IjBjODYiLCBFTlZ7YWRiX2FkYmZhc3R9PSJ5ZXMi
CiMJCVpvcG8gWlA5MDAsIEZhaXJwaG9uZQpBVFRSe2lkUHJvZHVjdH09PSIwYzAzIiwgRU5We2Fk
Yl9hZGJmYXN0fT0ieWVzIgojCQlab3BvIEMyCkFUVFJ7aWRQcm9kdWN0fT09IjIwMDgiLCBTWU1M
SU5LKz0ibGlibXRwLSVrIiwgRU5We0lEX01UUF9ERVZJQ0V9PSIxIiwgRU5We0lEX01FRElBX1BM
QVlFUn09IjEiCkdPVE89ImFuZHJvaWRfdXNiX3J1bGVfbWF0Y2giCkxBQkVMPSJub3RfSFRDIgoK
IwlIdWF3ZWkKQVRUUntpZFZlbmRvcn0hPSIxMmQxIiwgR09UTz0ibm90X0h1YXdlaSIKRU5We2Fk
Yl91c2VyfT0ieWVzIgojCQlJREVPUwpBVFRSe2lkUHJvZHVjdH09PSIxMDM4IiwgRU5We2FkYl9h
ZGJmYXN0fT0ieWVzIgojCQlVODg1MCBWaXNpb24KQVRUUntpZFByb2R1Y3R9PT0iMTAyMSIsIEVO
VnthZGJfYWRiZmFzdH09InllcyIKIwkJSGlLZXkgYWRiCkFUVFJ7aWRQcm9kdWN0fT09IjEwNTci
LCBTWU1MSU5LKz0iYW5kcm9pZF9hZGIiCiMJCUhpS2V5IHVzYm5ldApBVFRSe2lkUHJvZHVjdH09
PSIxMDUwIiwgU1lNTElOSys9ImFuZHJvaWRfYWRiIgojCQlNZWRpYVBhZCBNMi1BMDFMCkFUVFJ7
aWRQcm9kdWN0fT09IjEwNTIiLCBTWU1MSU5LKz0iYW5kcm9pZF9hZGIiCiMJCUh1YXdlaSBXYXRj
aApBVFRSe2lkUHJvZHVjdH09PSIxYzJjIiwgU1lNTElOSys9ImFuZHJvaWRfYWRiIgpHT1RPPSJh
bmRyb2lkX3VzYl9ydWxlX21hdGNoIgpMQUJFTD0ibm90X0h1YXdlaSIKCiMJSW50ZWwKQVRUUntp
ZFZlbmRvcn09PSI4MDg3IiwgRU5We2FkYl91c2VyfT0ieWVzIgojCQlHZWVrc3Bob25lIFJldm9s
dXRpb24KQVRUUntpZFZlbmRvcn09PSI4MDg3IiwgQVRUUntpZFByb2R1Y3R9PT0iMGExNiIsIFNZ
TUxJTksrPSJhbmRyb2lkX2FkYiIKCiMJSVVOSQpBVFRSe2lkVmVuZG9yfSE9IjI3MWQiLCBHT1RP
PSJub3RfSVVOSSIKRU5We2FkYl91c2VyfT0ieWVzIgojCQlVMwpBVFRSe2lkUHJvZHVjdH09PSJi
ZjM5IiwgU1lNTElOSys9ImFuZHJvaWRfYWRiIgpHT1RPPSJhbmRyb2lkX3VzYl9ydWxlX21hdGNo
IgpMQUJFTD0ibm90X0lVTkkiCgojCUstVG91Y2gKQVRUUntpZFZlbmRvcn09PSIyNGUzIiwgRU5W
e2FkYl91c2VyfT0ieWVzIgoKIwlLVCBUZWNoCkFUVFJ7aWRWZW5kb3J9PT0iMjExNiIsIEVOVnth
ZGJfdXNlcn09InllcyIKCiMJS3lvY2VyYQpBVFRSe2lkVmVuZG9yfT09IjA0ODIiLCBFTlZ7YWRi
X3VzZXJ9PSJ5ZXMiCgojCUxlbm92bwpBVFRSe2lkVmVuZG9yfT09IjE3ZWYiLCBFTlZ7YWRiX3Vz
ZXJ9PSJ5ZXMiCgojCUxlVHYKQVRUUntpZFZlbmRvcn0hPSIyYjBlIiwgR09UTz0ibm90X2xldHYi
CkVOVnthZGJfdXNlcn09InllcyIKIyAgIExFWDcyMCBMZUVjbyBQcm8zIDZHQiAoNjEwYz1ub3Jt
YWwsNjEwZD1kZWJ1ZywgNjEwYj1jYW1lcmEpCkFUVFJ7aWRQcm9kdWN0fT09IjYxMGQiLCBFTlZ7
YWRiX2Zhc3Rib290fT0ieWVzIgpHT1RPPSJhbmRyb2lkX3VzYl9ydWxlX21hdGNoIgpMQUJFTD0i
bm90X2xldHYiCgojCUxHCkFUVFJ7aWRWZW5kb3J9IT0iMTAwNCIsIEdPVE89Im5vdF9MRyIKRU5W
e2FkYl91c2VyfT0ieWVzIgojCQlBbGx5LCBWb3J0ZXgsIFA1MDAsIFA1MDBoCkFUVFJ7aWRQcm9k
dWN0fT09IjYxOGYiCkFUVFJ7aWRQcm9kdWN0fT09IjYxOGUiLCBTWU1MSU5LKz0iYW5kcm9pZF9h
ZGIiCiMJCUcyIEQ4MDIKQVRUUntpZFByb2R1Y3R9PT0iNjFmMSIsIFNZTUxJTksrPSJhbmRyb2lk
X2FkYiIKIwkJRzIgRDgwMwpBVFRSe2lkUHJvZHVjdH09PSI2MThjIiwgU1lNTElOSys9ImFuZHJv
aWRfYWRiIgojCQlHMiBEODAzIHJvZ2VycwpBVFRSe2lkUHJvZHVjdH09PSI2MzFmIiwgU1lNTElO
Sys9ImFuZHJvaWRfYWRiIgojCQlHMiBtaW5pIEQ2MjByIChQVFApCkFUVFJ7aWRQcm9kdWN0fT09
IjYzMWQiLCBTWU1MSU5LKz0iYW5kcm9pZF9hZGIiCiMJCUczIEQ4NTUKQVRUUntpZFByb2R1Y3R9
PT0iNjMzZSIsIFNZTUxJTksrPSJhbmRyb2lkX2FkYiIKIwkJT3B0aW11cyBMVEUKQVRUUntpZFBy
b2R1Y3R9PT0iNjMxNSIsIFNZTUxJTksrPSJhbmRyb2lkX2FkYiIKQVRUUntpZFByb2R1Y3R9PT0i
NjFmOSIsIFNZTUxJTksrPSJsaWJtdHAtJWsiLCBFTlZ7SURfTVRQX0RFVklDRX09IjEiLCBFTlZ7
SURfTUVESUFfUExBWUVSfT0iMSIKIwkJT3B0aW11cyBPbmUKQVRUUntpZFByb2R1Y3R9PT0iNjFj
NSIsIFNZTUxJTksrPSJhbmRyb2lkX2FkYiIKIwkJU3dpZnQgR1Q1NDAKQVRUUntpZFByb2R1Y3R9
PT0iNjFiNCIsIFNZTUxJTksrPSJhbmRyb2lkX2FkYiIKIwkJUDUwMCBDTTEwCkFUVFJ7aWRQcm9k
dWN0fT09IjYxYTYiLCBTWU1MSU5LKz0iYW5kcm9pZF9hZGIiCiMJCTRYIEhEIFA4ODAKQVRUUntp
ZFByb2R1Y3R9PT0iNjFmOSIsIFNZTUxJTksrPSJhbmRyb2lkX2FkYiIKR09UTz0iYW5kcm9pZF91
c2JfcnVsZV9tYXRjaCIKTEFCRUw9Im5vdF9MRyIKCiMJTWljcm9tYXgKQVRUUntpZFZlbmRvcn0h
PSIyYTk2IiwgR09UTz0ibm90X01pY3JvbWF4IgpFTlZ7YWRiX3VzZXJ9PSJ5ZXMiCiMJCVA3MDIK
QVRUUntpZFByb2R1Y3R9PT0iMjAxZCIsIFNZTUxJTksrPSJhbmRyb2lkX2FkYiIsIFNZTUxJTksr
PSJhbmRyb2lkX2Zhc3Rib290IgpHT1RPPSJhbmRyb2lkX3VzYl9ydWxlX21hdGNoIgpMQUJFTD0i
bm90X01pY3JvbWF4IgoKIwlNb3Rvcm9sYQpBVFRSe2lkVmVuZG9yfSE9IjIyYjgiLCBHT1RPPSJu
b3RfTW90b3JvbGEiCkVOVnthZGJfdXNlcn09InllcyIKIwkJQ0xJUSBYVC9RdWVuY2gKQVRUUntp
ZFByb2R1Y3R9PT0iMmQ2NiIKIwkJRGVmeS9NQjUyNQpBVFRSe2lkUHJvZHVjdH09PSI0MjhjIgoj
CQlEcm9pZApBVFRSe2lkUHJvZHVjdH09PSI0MWRiIgojCQlYb29tIElEIDEKQVRUUntpZFByb2R1
Y3R9PT0iNzBhOCIsIEVOVnthZGJfYWRiZmFzdH09InllcyIKIwkJWG9vbSBJRCAyCkFUVFJ7aWRQ
cm9kdWN0fT09IjcwYTkiLCBFTlZ7YWRiX2FkYmZhc3R9PSJ5ZXMiCiMJCVJhenIgWFQ5MTIKQVRU
UntpZFByb2R1Y3R9PT0iNDM2MiIsIEVOVnthZGJfYWRiZmFzdH09InllcyIKIwkJTW90byBYVDEw
NTIKQVRUUntpZFByb2R1Y3R9PT0iMmU4MyIsIEVOVnthZGJfYWRiZmFzdH09InllcyIKIwkJTW90
byBFL0cKQVRUUntpZFByb2R1Y3R9PT0iMmU3NiIsIEVOVnthZGJfYWRiZmFzdH09InllcyIKIwkJ
TW90byBFL0cgKER1YWwgU0lNKQpBVFRSe2lkUHJvZHVjdH09PSIyZTgwIiwgRU5We2FkYl9hZGJm
YXN0fT0ieWVzIgojCQlNb3RvIEUvRyAoR2xvYmFsIEdTTSkKQVRUUntpZFByb2R1Y3R9PT0iMmU4
MiIsIEVOVnthZGJfYWRiZmFzdH09InllcyIKR09UTz0iYW5kcm9pZF91c2JfcnVsZV9tYXRjaCIK
TEFCRUw9Im5vdF9Nb3Rvcm9sYSIKCiMJTVRLCkFUVFJ7aWRWZW5kb3J9PT0iMGU4ZCIsIEVOVnth
ZGJfdXNlcn09InllcyIKCiMJTkVDCkFUVFJ7aWRWZW5kb3J9PT0iMDQwOSIsIEVOVnthZGJfdXNl
cn09InllcyIKCiMJTm9raWEgWApBVFRSe2lkVmVuZG9yfT09IjA0MjEiLCBFTlZ7YWRiX3VzZXJ9
PSJ5ZXMiCgojCU5vb2sKQVRUUntpZFZlbmRvcn09PSIyMDgwIiwgRU5We2FkYl91c2VyfT0ieWVz
IgoKIwlOdmlkaWEKQVRUUntpZFZlbmRvcn09PSIwOTU1IiwgRU5We2FkYl91c2VyfT0ieWVzIgoj
ICAgICAgICAgICAgICAgQXVkaSBTRElTIFJlYXIgU2VhdCBFbnRlcnRhaW5tZW50IFRhYmxldApB
VFRSe2lkUHJvZHVjdH09PSI3MDAwIiwgU1lNTElOSys9ImFuZHJvaWRfZmFzdGJvb3QiCgojCU9w
cG8KQVRUUntpZFZlbmRvcn09PSIyMmQ5IiwgRU5We2FkYl91c2VyfT0ieWVzIgojCQlGaW5kIDUK
QVRUUntpZFByb2R1Y3R9PT0iMjc2NyIsIFNZTUxJTksrPSJhbmRyb2lkX2FkYiIKQVRUUntpZFBy
b2R1Y3R9PT0iMjc2NCIsIFNZTUxJTksrPSJsaWJtdHAtJWsiLCBFTlZ7SURfTVRQX0RFVklDRX09
IjEiLCBFTlZ7SURfTUVESUFfUExBWUVSfT0iMSIKCiMJT1RHVgpBVFRSe2lkVmVuZG9yfT09IjIy
NTciLCBFTlZ7YWRiX3VzZXJ9PSJ5ZXMiCgojCVBhbnRlY2gKQVRUUntpZFZlbmRvcn09PSIxMGE5
IiwgRU5We2FkYl91c2VyfT0ieWVzIgoKIwlQZWdhdHJvbgpBVFRSe2lkVmVuZG9yfT09IjFkNGQi
LCBFTlZ7YWRiX3VzZXJ9PSJ5ZXMiCgojCVBoaWxpcHMKQVRUUntpZFZlbmRvcn09PSIwNDcxIiwg
RU5We2FkYl91c2VyfT0ieWVzIgoKIwlQTUMtU2llcnJhCkFUVFJ7aWRWZW5kb3J9PT0iMDRkYSIs
IEVOVnthZGJfdXNlcn09InllcyIKCiMJUXVhbGNvbW0KQVRUUntpZFZlbmRvcn0hPSIwNWM2Iiwg
R09UTz0ibm90X1F1YWxjb21tIgpFTlZ7YWRiX3VzZXJ9PSJ5ZXMiCiMJCUdlZWtzcGhvbmUgWmVy
bwpBVFRSe2lkUHJvZHVjdH09PSI5MDI1IiwgU1lNTElOSys9ImFuZHJvaWRfYWRiIgojCQlPbmVQ
bHVzIE9uZQpBVFRSe2lkUHJvZHVjdH09PSI2NzY/IiwgU1lNTElOSys9ImFuZHJvaWRfYWRiIgoj
CQlPbmVQbHVzIFR3bwpBVFRSe2lkUHJvZHVjdH09PSI5MDExIiwgU1lNTElOSys9ImFuZHJvaWRf
YWRiIgojCQlPbmVQbHVzIDMKQVRUUntpZFByb2R1Y3R9PT0iOTAwZSIsIFNZTUxJTksrPSJhbmRy
b2lkX2FkYiIKIwkJT25lUGx1cyAzVApBVFRSe2lkUHJvZHVjdH09PSI2NzZjIiwgU1lNTElOSys9
ImFuZHJvaWRfYWRiIgpHT1RPPSJhbmRyb2lkX3VzYl9ydWxlX21hdGNoIgpMQUJFTD0ibm90X1F1
YWxjb21tIgoKIwlTSyBUZWxlc3lzCkFUVFJ7aWRWZW5kb3J9PT0iMWY1MyIsIEVOVnthZGJfdXNl
cn09InllcyIKCiMJU2Ftc3VuZwpBVFRSe2lkVmVuZG9yfSE9IjA0ZTgiLCBHT1RPPSJub3RfU2Ft
c3VuZyIKIwkJRmFsc2UgcG9zaXRpdmUgcHJpbnRlcgpBVFRSe2lkUHJvZHVjdH09PSIzPz8/Iiwg
R09UTz0iYW5kcm9pZF91c2JfcnVsZXNfZW5kIgpFTlZ7YWRiX3VzZXJ9PSJ5ZXMiCiMJCUdhbGF4
eSBpNTcwMApBVFRSe2lkUHJvZHVjdH09PSI2ODFjIiwgRU5We2FkYl9hZGJmYXN0fT0ieWVzIgoj
CQlHYWxheHkgaTU4MDAgKDY4MWM9ZGVidWcsNjYwMT1mYXN0Ym9vdCw2OGEwPW1lZGlhcGxheWVy
KQpBVFRSe2lkUHJvZHVjdH09PSI2ODFjIiwgU1lNTElOSys9ImFuZHJvaWRfYWRiIgpBVFRSe2lk
UHJvZHVjdH09PSI2NjAxIiwgU1lNTElOSys9ImFuZHJvaWRfZmFzdGJvb3QiCkFUVFJ7aWRQcm9k
dWN0fT09IjY4YTkiLCBTWU1MSU5LKz0ibGlibXRwLSVrIiwgRU5We0lEX01UUF9ERVZJQ0V9PSIx
IiwgRU5We0lEX01FRElBX1BMQVlFUn09IjEiCiMJCUdhbGF4eSBpNzUwMApBVFRSe2lkUHJvZHVj
dH09PSI2NjQwIiwgRU5We2FkYl9hZGJmYXN0fT0ieWVzIgojCQlHYWxheHkgaTkwMDAgUywgaTkz
MDAgUzMKQVRUUntpZFByb2R1Y3R9PT0iNjYwMSIsIFNZTUxJTksrPSJhbmRyb2lkX2FkYiIKQVRU
UntpZFByb2R1Y3R9PT0iNjg1ZCIsIE1PREU9IjA2NjAiCkFUVFJ7aWRQcm9kdWN0fT09IjY4YzMi
LCBNT0RFPSIwNjYwIgojCQlHYWxheHkgQWNlIChTNTgzMCkgIkNvb3BlciIKQVRUUntpZFByb2R1
Y3R9PT0iNjg5ZSIsIEVOVnthZGJfYWRiZmFzdH09InllcyIKIwkJR2FsYXh5IFRhYgpBVFRSe2lk
UHJvZHVjdH09PSI2ODc3IiwgRU5We2FkYl9hZGJmYXN0fT0ieWVzIgojCQlHYWxheHkgTmV4dXMg
KEdTTSkKQVRUUntpZFByb2R1Y3R9PT0iNjg1YyIKIwkJR2FsYXh5IENvcmUsIFRhYiAxMC4xLCBp
OTEwMCBTMiwgaTkzMDAgUzMsIE41MTAwIE5vdGUgKDguMCksIEdhbGF4eSBTMyBTSFctTTQ0MFMg
M0cgKEtvcmVhIG9ubHkpCkFUVFJ7aWRQcm9kdWN0fT09IjY4NjAiLCBTWU1MSU5LKz0iYW5kcm9p
ZF9hZGIiCkFUVFJ7aWRQcm9kdWN0fT09IjY4NWUiLCBFTlZ7YWRiX2FkYmZhc3R9PSJ5ZXMiCiMJ
CUdhbGF4eSBpOTMwMCBTMwpBVFRSe2lkUHJvZHVjdH09PSI2ODY2IiwgU1lNTElOSys9ImxpYm10
cC0layIsIEVOVntJRF9NVFBfREVWSUNFfT0iMSIsIEVOVntJRF9NRURJQV9QTEFZRVJ9PSIxIgoj
CQlHYWxheHkgUzQgR1QtSTk1MDAKQVRUUntpZFByb2R1Y3R9PT0iNjg1ZCIsIFNZTUxJTksrPSJh
bmRyb2lkX2FkYiIKR09UTz0iYW5kcm9pZF91c2JfcnVsZV9tYXRjaCIKTEFCRUw9Im5vdF9TYW1z
dW5nIgoKIwlTaGFycApBVFRSe2lkVmVuZG9yfT09IjA0ZGQiLCBFTlZ7YWRiX3VzZXJ9PSJ5ZXMi
CgojCVNvbnkKQVRUUntpZFZlbmRvcn09PSIwNTRjIiwgRU5We2FkYl91c2VyfT0ieWVzIgoKIwlT
b255IEVyaWNzc29uCkFUVFJ7aWRWZW5kb3J9IT0iMGZjZSIsIEdPVE89Im5vdF9Tb255X0VyaWNz
c29uIgpFTlZ7YWRiX3VzZXJ9PSJ5ZXMiCiMJCVhwZXJpYSBYMTAgbWluaQpBVFRSe2lkUHJvZHVj
dH09PSIzMTM3IgpBVFRSe2lkUHJvZHVjdH09PSIyMTM3IiwgU1lNTElOSys9ImFuZHJvaWRfYWRi
IgojCQlYcGVyaWEgWDEwIG1pbmkgcHJvCkFUVFJ7aWRQcm9kdWN0fT09IjMxMzgiCkFUVFJ7aWRQ
cm9kdWN0fT09IjIxMzgiLCBTWU1MSU5LKz0iYW5kcm9pZF9hZGIiCiMJCVhwZXJpYSBYOApBVFRS
e2lkUHJvZHVjdH09PSIzMTQ5IgpBVFRSe2lkUHJvZHVjdH09PSIyMTQ5IiwgU1lNTElOSys9ImFu
ZHJvaWRfYWRiIgojCQlYcGVyaWEgWDEyCkFUVFJ7aWRQcm9kdWN0fT09ImUxNGYiCkFUVFJ7aWRQ
cm9kdWN0fT09IjYxNGYiLCBTWU1MSU5LKz0iYW5kcm9pZF9hZGIiCiMJCVhwZXJpYSBBcmMgUwpB
VFRSe2lkUHJvZHVjdH09PSI0MTRmIiwgRU5We2FkYl9hZGJmYXN0fT0ieWVzIgojCQlYcGVyaWEg
TmVvIFYgKDYxNTY9ZGVidWcsMGRkZT1mYXN0Ym9vdCkKQVRUUntpZFByb2R1Y3R9PT0iNjE1NiIs
IFNZTUxJTksrPSJhbmRyb2lkX2FkYiIKQVRUUntpZFByb2R1Y3R9PT0iMGRkZSIsIFNZTUxJTksr
PSJhbmRyb2lkX2Zhc3Rib290IgojCQlYcGVyaWEgUwpBVFRSe2lkUHJvZHVjdH09PSI1MTY5Iiwg
RU5We2FkYl9hZGJmYXN0fT0ieWVzIgojCQlYcGVyaWEgU1AKQVRUUntpZFByb2R1Y3R9PT0iNjE5
NSIsIEVOVnthZGJfYWRiZmFzdH09InllcyIKIwkJWHBlcmlhIEwKQVRUUntpZFByb2R1Y3R9PT0i
NTE5MiIsIEVOVnthZGJfYWRiZmFzdH09InllcyIKIwkJWHBlcmlhIE1pbmkgUHJvCkFUVFJ7aWRQ
cm9kdWN0fT09IjAxNjYiLCBFTlZ7YWRiX2FkYmZhc3R9PSJ5ZXMiCiMJCVhwZXJpYSBWCkFUVFJ7
aWRQcm9kdWN0fT09IjAxODYiLCBFTlZ7YWRiX2FkYmZhc3R9PSJ5ZXMiCiMJCVhwZXJpYSBBY3Jv
IFMKQVRUUntpZFByb2R1Y3R9PT0iNTE3NiIsIEVOVnthZGJfYWRiZmFzdH09InllcyIKIwkJWHBl
cmlhIFoxIENvbXBhY3QKQVRUUntpZFByb2R1Y3R9PT0iNTFhNyIsIEVOVnthZGJfYWRiZmFzdH09
InllcyIKIwkJWHBlcmlhIFoyCkFUVFJ7aWRQcm9kdWN0fT09IjUxYmEiLCBFTlZ7YWRiX2FkYmZh
c3R9PSJ5ZXMiCiMJCVhwZXJpYSBaMwpBVFRSe2lkUHJvZHVjdH09PSIwMWFmIiwgRU5We2FkYl9h
ZGJmYXN0fT0ieWVzIgojCQlYcGVyaWEgWjMgQ29tcGFjdApBVFRSe2lkUHJvZHVjdH09PSIwMWJi
IiwgRU5We2FkYl9hZGJmYXN0fT0ieWVzIgojCQlYcGVyaWEgWjMrIER1YWwKQVRUUntpZFByb2R1
Y3R9PT0iNTFjOSIsIEVOVnthZGJfYWRiZmFzdH09InllcyIKR09UTz0iYW5kcm9pZF91c2JfcnVs
ZV9tYXRjaCIKTEFCRUw9Im5vdF9Tb255X0VyaWNzc29uIgoKIwlTcHJlYWR0cnVtCkFUVFJ7aWRW
ZW5kb3J9PT0iMTc4MiIsIEVOVnthZGJfdXNlcn09InllcyIKCiMJVCAmIEEgTW9iaWxlIFBob25l
cwpBVFRSe2lkVmVuZG9yfT09IjFiYmIiLCBFTlZ7YWRiX3VzZXJ9PSJ5ZXMiCiMJCUFsY2F0ZWwg
T1Q5OTFECkFUVFJ7aWRQcm9kdWN0fT09IjAwZjIiLCBTWU1MSU5LKz0iYW5kcm9pZF9hZGIiCiMJ
CUFsY2F0ZWwgT1Q2MDEyQQpBVFRSe2lkUHJvZHVjdH09PSIwMTY3IiwgU1lNTElOSys9ImFuZHJv
aWRfYWRiIgoKIwlUZWxlZXBvY2gKQVRUUntpZFZlbmRvcn09PSIyMzQwIiwgRU5We2FkYl91c2Vy
fT0ieWVzIgoKIwlUZXhhcyBJbnN0cnVtZW50cyBVc2JCb290CkFUVFJ7aWRWZW5kb3J9PT0iMDQ1
MSIsIEFUVFJ7aWRQcm9kdWN0fT09ImQwMGYiLCBFTlZ7YWRiX3VzZXJ9PSJ5ZXMiCkFUVFJ7aWRW
ZW5kb3J9PT0iMDQ1MSIsIEFUVFJ7aWRQcm9kdWN0fT09ImQwMTAiLCBFTlZ7YWRiX3VzZXJ9PSJ5
ZXMiCgojCVRvc2hpYmEKQVRUUntpZFZlbmRvcn09PSIwOTMwIiwgRU5We2FkYl91c2VyfT0ieWVz
IgoKIwlXRUFSTkVSUwpBVFRSe2lkVmVuZG9yfT09IjA1YzYiLCBFTlZ7YWRiX3VzZXJ9PSJ5ZXMi
CgojCVhpYW9NaQpBVFRSe2lkVmVuZG9yfSE9IjI3MTciLCBHT1RPPSJub3RfWGlhb01pIgpFTlZ7
YWRiX3VzZXJ9PSJ5ZXMiCiMJCU1pMkEKQVRUUntpZFByb2R1Y3R9PT0iOTA0ZSIsIFNZTUxJTksr
PSJhbmRyb2lkX2FkYiIKQVRUUntpZFByb2R1Y3R9PT0iOTAzOSIsIFNZTUxJTksrPSJhbmRyb2lk
X2FkYiIKIwkJTWkzCkFUVFJ7aWRQcm9kdWN0fT09IjAzNjgiLCBTWU1MSU5LKz0iYW5kcm9pZF9h
ZGIiCiMJCVJlZE1pIDFTIFdDRE1BIChNVFArRGVidWcpCkFUVFJ7aWRQcm9kdWN0fT09IjEyNjgi
LCBTWU1MSU5LKz0iYW5kcm9pZF9hZGIiCiMJCVJlZE1pIC8gUmVkTWkgTm90ZSBXQ0RNQSAoTVRQ
K0RlYnVnKQpBVFRSe2lkUHJvZHVjdH09PSIxMjQ4IiwgU1lNTElOSys9ImFuZHJvaWRfYWRiIgoj
CQlSZWRNaSAxUyAvIFJlZE1pIC8gUmVkTWkgTm90ZSBXQ0RNQSAoUFRQK0RlYnVnKQpBVFRSe2lk
UHJvZHVjdH09PSIxMjE4IiwgU1lNTElOSys9ImFuZHJvaWRfYWRiIgojCQlSZWRNaSAxUyAvUmVk
TWkgLyBSZWRNaSBOb3RlIFdDRE1BIChVc2IrRGVidWcpCkFUVFJ7aWRQcm9kdWN0fT09IjEyMjgi
LCBTWU1MSU5LKz0iYW5kcm9pZF9hZGIiCiMJCVJlZE1pIC8gUmVkTWkgTm90ZSA0RyBXQ0RNQSAo
TVRQK0RlYnVnKQpBVFRSe2lkUHJvZHVjdH09PSIxMzY4IiwgU1lNTElOSys9ImFuZHJvaWRfYWRi
IgojCQlSZWRNaSAvIFJlZE1pIE5vdGUgNEcgV0NETUEgKFBUUCtEZWJ1ZykKQVRUUntpZFByb2R1
Y3R9PT0iMTMxOCIsIFNZTUxJTksrPSJhbmRyb2lkX2FkYiIKIwkJUmVkTWkgLyBSZWRNaSBOb3Rl
IDRHIFdDRE1BIChVc2IrRGVidWcpCkFUVFJ7aWRQcm9kdWN0fT09IjEzMjgiLCBTWU1MSU5LKz0i
YW5kcm9pZF9hZGIiCiMJCVJlZE1pIC8gUmVkTWkgTm90ZSA0RyBDRE1BIChVc2IrRGVidWcpIC8g
TWk0YyAvIE1pNQpBVFRSe2lkUHJvZHVjdH09PSJmZjY4IiwgU1lNTElOSys9ImFuZHJvaWRfYWRi
IgpHT1RPPSJhbmRyb2lkX3VzYl9ydWxlX21hdGNoIgpMQUJFTD0ibm90X1hpYW9NaSIKCiMJWW90
YQpBVFRSe2lkVmVuZG9yfSE9IjI5MTYiLCBHT1RPPSJub3RfWW90YSIKRU5We2FkYl91c2VyfT0i
eWVzIgojICAgWW90YVBob25lMiAoZjAwMz1ub3JtYWwsOTEzOT1kZWJ1ZykKQVRUUntpZFByb2R1
Y3R9PT0iOTEzOSIsIFNZTUxJTksrPSJhbmRyb2lkX2FkYiIKR09UTz0iYW5kcm9pZF91c2JfcnVs
ZV9tYXRjaCIKTEFCRUw9Im5vdF9Zb3RhIgoKIwlXaWxleWZveApBVFRSe2lkVmVuZG9yfT09IjI5
NzAiLCBFTlZ7YWRiX3VzZXJ9PSJ5ZXMiCgojCVlVCkFUVFJ7aWRWZW5kb3J9PT0iMWViZiIsIEVO
VnthZGJfdXNlcn09InllcyIKCiMJWmVicmEKQVRUUntpZFZlbmRvcn0hPSIwNWUwIiwgR09UTz0i
bm90X1plYnJhIgpFTlZ7YWRiX3VzZXJ9PSJ5ZXMiCiMJCVRDNTUKQVRUUntpZFByb2R1Y3R9PT0i
MjEwMSIsIFNZTUxJTksrPSJhbmRyb2lkX2FkYiIKR09UTz0iYW5kcm9pZF91c2JfcnVsZV9tYXRj
aCIKTEFCRUw9Im5vdF9aZWJyYSIKCiMJWlRFCkFUVFJ7aWRWZW5kb3J9PT0iMTlkMiIsIEVOVnth
ZGJfdXNlcn09InllcyIKIwkJQmxhZGUgKDEzNTM9bm9ybWFsLDEzNTE9ZGVidWcpCkFUVFJ7aWRQ
cm9kdWN0fT09IjEzNTEiLCBTWU1MSU5LKz0iYW5kcm9pZF9hZGIiCiMJCUJsYWRlIFMgKENyZXNj
ZW50LCBPcmFuZ2UgU2FuIEZyYW5jaXNjbyAyKSAoMTM1NT1ub3JtYWwsMTM1ND1kZWJ1ZykKQVRU
UntpZFByb2R1Y3R9PT0iMTM1NCIsIFNZTUxJTksrPSJhbmRyb2lkX2FkYiIKCiMJV2lsZXlmb3gK
QVRUUntpZFZlbmRvcn09PSIyOTcwIiwgRU5We2FkYl91c2VyfT0ieWVzIgoKIwlZVQpBVFRSe2lk
VmVuZG9yfT09IjFlYmYiLCBFTlZ7YWRiX3VzZXJ9PSJ5ZXMiCgojCVpVSwpBVFRSe2lkVmVuZG9y
fT09IjJiNGMiLCBFTlZ7YWRiX3VzZXJ9PSJ5ZXMiCgojIFNraXAgb3RoZXIgdmVuZG9yIHRlc3Rz
CkxBQkVMPSJhbmRyb2lkX3VzYl9ydWxlX21hdGNoIgoKIyBTeW1saW5rIHNob3J0Y3V0cyB0byBy
ZWR1Y2UgY29kZSBpbiB0ZXN0cyBhYm92ZQpFTlZ7YWRiX2FkYmZhc3R9PT0ieWVzIiwgRU5We2Fk
Yl9hZGJ9PSJ5ZXMiLCBFTlZ7YWRiX2Zhc3R9PSJ5ZXMiCkVOVnthZGJfYWRifT09InllcyIsIEVO
VnthZGJfdXNlcn09InllcyIsIFNZTUxJTksrPSJhbmRyb2lkX2FkYiIKRU5We2FkYl9mYXN0fT09
InllcyIsIEVOVnthZGJfdXNlcn09InllcyIsIFNZTUxJTksrPSJhbmRyb2lkX2Zhc3Rib290IgoK
IyBFbmFibGUgZGV2aWNlIGFzIGEgdXNlciBkZXZpY2UgaWYgZm91bmQgKGFkZCBhbiAiYW5kcm9p
ZCIgU1lNTElOSykKRU5We2FkYl91c2VyfT09InllcyIsIE1PREU9IjA2NjAiLCBHUk9VUD0iYWRi
dXNlcnMiLCBUQUcrPSJ1YWNjZXNzIiwgU1lNTElOSys9ImFuZHJvaWQiCgojIERldmljZXMgbGlz
dGVkIGhlcmUge2JlZ2luLi4uZW5kfSBhcmUgY29ubmVjdGVkIGJ5IFVTQgpMQUJFTD0iYW5kcm9p
ZF91c2JfcnVsZXNfZW5kIgo=
EOF

groupadd adbusers
usermod -a -G adbusers root
usermod -a -G adbusers vagrant
chmod 644 /etc/udev/rules.d/51-android.rules
# chcon "system_u:object_r:udev_rules_t:s0" /etc/udev/rules.d/51-android.rules

if [[ "$PACKER_BUILD_NAME" =~ ^(lineage|lineageos)-nash-(vmware|hyperv|libvirt|virtualbox)$ ]]; then
cat <<-EOF > /home/vagrant/lineage-build.sh
#!/bin/bash

# Build Lineage for the Motorola Z2 Force by default.

export DEVICE=\${DEVICE:="nash"}
export BRANCH=\${BRANCH:="lineage-15.1"}
export VENDOR=\${VENDOR:="motorola"}
EOF
else
cat <<-EOF > /home/vagrant/lineage-build.sh
#!/bin/bash

# Build Lineage for Motorol Photon Q by default - because physical keyboards eat virtual keyboards
# for breakfast, brunch and then dinner.

export DEVICE=\${DEVICE:="xt897"}
export BRANCH=\${BRANCH:="cm-14.1"}
export VENDOR=\${VENDOR:="motorola"}
EOF
fi

cat <<-EOF > /home/vagrant/lineage-build.sh
export NAME=\${NAME:="Ladar Levison"}
export EMAIL=\${EMAIL:="ladar@lavabit.com"}

echo DEVICE=\$DEVICE
echo BRANCH=\$BRANCH
echo VENDOR=\$VENDOR
echo
echo NAME=\$NAME
echo EMAIL=\$EMAIL
echo
echo "Override the above environment variables in your Vagrantfile to alter the build configuration."
echo
echo
sleep 10

# Setup the branch and enable the distributed cache.
export USE_CCACHE=1
export TMPDIR="\$HOME/temp"
export ANDROID_CCACHE_SIZE="20G"
export ANDROID_CCACHE_DIR="\$HOME/cache"

# Jack is the Java compiler used by LineageOS 14.1+. Run this command to avoid running out of memory.
export ANDROID_JACK_VM_ARGS="-Dfile.encoding=UTF-8 -XX:+TieredCompilation -Xmx2G"

# If the environment indicates we should use Java 8 then run update alternatives to enable it.
export EXPERIMENTAL_USE_JAVA8=\${EXPERIMENTAL_USE_JAVA8:="true"}

# If the environment indicates we should use Java 7, then we enable it.
if [ "\$EXPERIMENTAL_USE_JAVA8" = "true" ]; then
  sudo update-java-alternatives -s java-1.8.0-openjdk-amd64
fi

# Make the directories.
mkdir -p \$HOME/temp && mkdir -p \$HOME/cache && mkdir -p \$HOME/android/lineage

# Goto the build root.
cd \$HOME/android/lineage

# Configure the default git username and email address.
git config --global user.name "\$NAME"
git config --global user.email "\$EMAIL"
git config --global color.ui false

# Initialize the repo and download the source code.
repo init -u https://github.com/LineageOS/android.git -b \$BRANCH
repo --color=never sync --quiet --jobs=2

# Setup the environment.
source build/envsetup.sh

# Reduce the amount of memory required during compilation.
# sed -i -e "s/-Xmx2048m/-Xmx512m/g" \$HOME/android/lineage/build/tools/releasetools/common.py

# Download and configure the environment for the device.
breakfast \$DEVICE

# # Find the latest upstream build.
# ARCHIVE=\`curl --silent https://download.lineageos.org/\$DEVICE | grep href | grep https://mirrorbits.lineageos.org/full/\$DEVICE/ | head -1 | awk -F'"' '{print \$2}'\`
#
# # Create a system dump directory.
# mkdir -p \$HOME/android/system_dump/ && cd \$HOME/android/system_dump/
#
# # Download the archive.
# curl --location --output lineage-archive.zip "\$ARCHIVE"
#
# # Extract the system blocks.
# unzip lineage-archive.zip system.transfer.list system.new.dat
#
# # Clone the sdat2img tool.
# git clone https://github.com/xpirt/sdat2img
#
# # Convert the system block file into an image.
# python sdat2img/sdat2img.py system.transfer.list system.new.dat system.img
#
# # Mount the system image.
# mkdir -p \$HOME/android/system/
# sudo mount system.img \$HOME/android/system/

# Change to the device directory and run the extraction script.
# cd \$HOME/android/lineage/device/\$VENDOR/\$DEVICE
# ./extract-files.sh \$HOME/android/system_dump/system
#
# # Unmount the system dump.
# sudo umount \$HOME/android/system_dump/system
# rm -rf \$HOME/android/system_dump/

# Extract the vendor specific blobs.
mkdir -p \$HOME/android/vendor/system/
tar -xzv -C \$HOME/android/vendor/ -f \$HOME/system-blobs.tar.gz

# Change to the device directory and run the extraction script.
cd \$HOME/android/lineage/device/\$VENDOR/\$DEVICE
./extract-files.sh \$HOME/android/vendor/system/

# Cleanup the vendor blob files.
rm -rf \$HOME/android/vendor/

# Setup the environment.
cd \$HOME/android/lineage/ && source build/envsetup.sh
breakfast \$DEVICE

# Setup the cache.
cd \$HOME/android/lineage/
prebuilts/misc/linux-x86/ccache/ccache -M 20G

# Start the build.
croot
brunch \$DEVICE

# Calculate the filename.
BUILDSTAMP=\`date +'%Y%m%d'\`
DIRIMAGE="\$HOME/android/lineage/out/target/product/\$DEVICE"
SYSIMAGE="\$DIRIMAGE/lineage-14.1-\$BUILDSTAMP-UNOFFICIAL-\$DEVICE.zip"
SYSIMAGESUM="\$DIRIMAGE/lineage-14.1-\$BUILDSTAMP-UNOFFICIAL-\$DEVICE.zip.md5sum"
#RECIMAGE="lineage-\$BUILDVERSION-\$BUILDSTAMP-UNOFFICIAL-\$DEVICE-recovery.img"

# Verify the image checksum.
md5sum -c "\$SYSIMAGESUM"

# See what the output directory holds.
ls -alh "\$SYSIMAGE" "\$SYSIMAGESUM"

# Push the new system image to the device.
# adb push "\$SYSIMAGE" /sdcard/
env > ~/env.txt
EOF

chown vagrant:vagrant /home/vagrant/system-blobs.tar.gz
chown vagrant:vagrant /home/vagrant/lineage-build.sh
chmod +x /home/vagrant/lineage-build.sh

# Customize the message of the day
printf "Lineage Development Environment\nTo download and compile Lineage, just execute the lineage-build.sh script.\n\n" > /etc/motd
