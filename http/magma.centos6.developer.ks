install
url --url=https://mirrors.kernel.org/centos/6/os/x86_64/
repo --name=debug --baseurl=http://debuginfo.centos.org/6/x86_64/
repo --name=extras --baseurl=https://mirrors.kernel.org/centos/6/extras/x86_64/
repo --name=updates --baseurl=https://mirrors.kernel.org/centos/6/updates/x86_64/
repo --name=epel --baseurl=https://mirrors.kernel.org/fedora-epel/6/x86_64/
repo --name=epel-debuginfo --baseurl=https://mirrors.kernel.org/fedora-epel/6/SRPMS/
lang en_US.UTF-8
keyboard us
timezone US/Pacific
text
firstboot --disabled
selinux --enforcing
firewall --enabled --service=ssh --port=6000:tcp,6050:tcp,7000:tcp,7050:tcp,7500:tcp,7501:tcp,7550:tcp,7551:tcp,8000:tcp,8050:tcp,8500:tcp,8550:tcp,9000:tcp,9050:tcp,9500:tcp,9550:tcp,10000:tcp,10050:tcp,10500:tcp,10550:tcp
network --device eth0 --bootproto dhcp --noipv6 --hostname=magma.developer.local
zerombr
clearpart --all --initlabel
bootloader --location=mbr
autopart
rootpw magma
authconfig --enableshadow --passalgo=sha512
reboot --eject
xconfig --startxonboot

%packages --nobase
@core
abrt
abrt-addon-ccpp
abrt-addon-kerneloops
abrt-addon-python
abrt-cli
abrt-desktop
abrt-gui
abrt-libs
abrt-tui
abyssinica-fonts
acl
acpid
alacarte
alsa-lib
alsa-lib-devel
alsa-plugins-pulseaudio
alsa-utils
ant
ant-antlr
ant-apache-bcel
ant-apache-bsf
ant-apache-log4j
ant-apache-oro
ant-apache-regexp
ant-apache-resolver
ant-commons-logging
ant-commons-net
anthy
ant-javamail
ant-jdepend
ant-jsch
ant-junit
antlr
ant-nodeps
ant-swing
ant-trax
apache-jasper
apache-tomcat-apis
apr
apr-devel
apr-util
apr-util-devel
apr-util-ldap
archivemount
arptables_jf
arpwatch
at
atk
atk-devel
atlas
at-spi
at-spi-python
attr
audit
audit-libs
audit-libs-devel
audit-libs-python
audit-viewer
authconfig
authconfig-gtk
autoconf
autocorr-en
autofs
automake
avahi-autoipd
avahi-glib
avahi-libs
avahi-ui
avalon-framework
axis
b43-fwcutter
b43-openfwwf
babel
babl
basesystem
bash
batik
bc
bcel
bind-libs
bind-utils
binutils
binutils-devel
biosdevname
bison
blktrace
bluez
bluez-libs
boost
boost-date-time
boost-devel
boost-filesystem
boost-graph
boost-iostreams
boost-math
boost-program-options
boost-python
boost-regex
boost-serialization
boost-signals
boost-system
boost-test
boost-thread
boost-wave
brasero
brasero-libs
brasero-nautilus
bridge-utils
bsf
btparser
busybox
byacc
byzanz
bzip2
bzip2-devel
bzip2-libs
c2050
c2070
ca-certificates
cairo
cairo-devel
cairomm
c-ares
cas
cdparanoia
cdparanoia-libs
cdrdao
centos-indexhtml
centos-release
certmonger
checkpolicy
cheese
chkconfig
cifs-utils
cjet
cjkuni-fonts-common
cjkuni-uming-fonts
classpathx-jaf
classpathx-mail
cloog-ppl
cmake
compat-gcc-34
compat-gcc-34-c++
compat-gcc-34-g77
compiz
compiz-gnome
comps-extras
ConsoleKit
ConsoleKit-libs
ConsoleKit-x11
control-center
control-center-extra
control-center-filesystem
coreutils
coreutils-libs
cpio
cpp
cpuspeed
cracklib
cracklib-dicts
cracklib-python
crash
crash-gcore-command
crash-trace-command
crda
cronie
cronie-anacron
crontabs
crypto-utils
cryptsetup-luks
cryptsetup-luks-libs
cscope
ctags
ctan-cm-lgc-fonts-common
ctan-cm-lgc-roman-fonts
ctan-cm-lgc-sans-fonts
ctan-cm-lgc-typewriter-fonts
cups
cups-libs
cups-pk-helper
curl
cvs
cyrus-imapd
cyrus-imapd-utils
cyrus-sasl
cyrus-sasl-devel
cyrus-sasl-gssapi
cyrus-sasl-lib
cyrus-sasl-md5
cyrus-sasl-plain
dash
db4
db4-cxx
db4-devel
db4-utils
dbus
dbus-c++
dbus-devel
dbus-glib
dbus-glib-devel
dbus-libs
dbus-python
dbus-x11
dejagnu
dejavu-fonts-common
dejavu-sans-fonts
dejavu-sans-mono-fonts
dejavu-serif-fonts
desktop-effects
desktop-file-utils
devhelp
DeviceKit-power
device-mapper
device-mapper-event
device-mapper-event-libs
device-mapper-libs
device-mapper-persistent-data
dhclient
dhcp-common
diffstat
diffutils
dmidecode
dmraid
dmraid-events
dmz-cursor-themes
dnsmasq
docbook5-schemas
docbook5-style-xsl
docbook-dtds
docbook-simple
docbook-slides
docbook-style-dsssl
docbook-style-xsl
docbook-utils
dosfstools
dovecot
dovecot-mysql
doxygen
dracut
dracut-kernel
dropwatch
dstat
dvd+rw-tools
dvgrab
e2fsprogs
e2fsprogs-libs
ecj
eclipse-birt
eclipse-callgraph
eclipse-cdt
eclipse-changelog
eclipse-dtp
eclipse-emf
eclipse-gef
eclipse-jdt
eclipse-linuxprofilingframework
eclipse-mylyn
eclipse-mylyn-cdt
eclipse-mylyn-java
eclipse-mylyn-pde
eclipse-mylyn-trac
eclipse-mylyn-webtasks
eclipse-mylyn-wikitext
eclipse-oprofile
eclipse-pde
eclipse-platform
eclipse-rcp
eclipse-rpm-editor
eclipse-rse
eclipse-subclipse
eclipse-subclipse-graph
eclipse-svnkit
eclipse-swt
eclipse-valgrind
ed
efibootmgr
eggdbus
eject
ekiga
ElectricFence
elfutils
elfutils-devel
elfutils-libelf
elfutils-libelf-devel
elfutils-libs
elinks
emacs
emacs-common
enchant
enscript
eog
ethtool
evince
evince-dvi
evince-libs
evolution
evolution-data-server
evolution-data-server-devel
evolution-help
evolution-mapi
exempi
expat
expat-devel
expect
fakeroot
fakeroot-libs
farsight2
festival
festival-lib
festival-speechtools-libs
festvox-slt-arctic-hts
file
file-devel
file-libs
file-roller
filesystem
findutils
finger
fipscheck
fipscheck-lib
firefox
firstaidkit
firstaidkit-engine
firstaidkit-gui
firstboot
flac
flex
flightrecorder
fontconfig
fontconfig-devel
fontpackages-filesystem
foomatic
foomatic-db
foomatic-db-filesystem
foomatic-db-ppds
fop
fprintd
fprintd-pam
freeipmi
freetype
freetype-devel
ftp
fuse
fuse-libs
gamin
gamin-python
gawk
gcalctool
gcc
gcc-c++
gcc-debuginfo
gcc-gfortran
gcc-gnat
gcc-java
gcc-objc
gcc-objc++
GConf2
GConf2-devel
GConf2-gtk
gconf-editor
gconfmm26
gd
gdb
gdb-gdbserver
gdbm
gdbm-devel
gdk-pixbuf2
gdk-pixbuf2-devel
gdm
gdm-libs
gdm-plugin-fingerprint
gdm-user-switch-applet
gedit
gedit-plugins
gegl
genisoimage
geoclue
geronimo-specs
geronimo-specs-compat
gettext
gettext-devel
gettext-libs
ghostscript
ghostscript-fonts
giflib
gimp
gimp-data-extras
gimp-help
gimp-help-browser
gimp-libs
git
glade3
glade3-libgladeui
glib2
glib2-devel
glibc
glibc-common
glibc-debuginfo
glibc-debuginfo-common
glibc-devel
glibc-headers
glibc-utils
glibmm24
glib-networking
glx-utils
gmp
gmp-debuginfo
gmp-devel
gnome-applets
gnome-backgrounds
gnome-bluetooth
gnome-bluetooth-libs
gnome-common
gnome-desktop
gnome-desktop-devel
gnome-devel-docs
gnome-disk-utility
gnome-disk-utility-libs
gnome-disk-utility-ui-libs
gnome-doc-utils
gnome-doc-utils-stylesheets
gnome-icon-theme
gnome-keyring
gnome-keyring-devel
gnome-keyring-pam
gnome-mag
gnome-media
gnome-media-libs
gnome-menus
gnome-packagekit
gnome-panel
gnome-panel-libs
gnome-power-manager
gnome-python2
gnome-python2-applet
gnome-python2-bonobo
gnome-python2-canvas
gnome-python2-desktop
gnome-python2-extras
gnome-python2-gconf
gnome-python2-gnome
gnome-python2-gnomekeyring
gnome-python2-gnomevfs
gnome-python2-gtkhtml2
gnome-python2-libegg
gnome-python2-libwnck
gnome-python2-rsvg
gnome-screensaver
gnome-session
gnome-session-xsession
gnome-settings-daemon
gnome-speech
gnome-system-monitor
gnome-terminal
gnome-themes
gnome-user-docs
gnome-user-share
gnome-utils
gnome-utils-libs
gnome-vfs2
gnome-vfs2-devel
gnome-vfs2-smb
gnote
gnupg2
gnutls
gnutls-devel
gnutls-utils
gok
google-crosextra-caladea-fonts
google-crosextra-carlito-fonts
gperf
gpgme
gpm-libs
grep
groff
grub
grubby
gsm
gssdp
gstreamer
gstreamer-plugins-bad-free
gstreamer-plugins-base
gstreamer-plugins-good
gstreamer-python
gstreamer-tools
gthumb
gtk2
gtk2-devel
gtk2-devel-docs
gtk2-engines
gtk2-immodule-xim
gtk-doc
gtk+extra
gtkhtml2
gtkhtml3
gtkmm24
gtksourceview2
gtkspell
gucharmap
gupnp
gupnp-igd
gutenprint
gutenprint-cups
gutenprint-plugin
gvfs
gvfs-afc
gvfs-archive
gvfs-devel
gvfs-fuse
gvfs-gphoto2
gvfs-obexftp
gvfs-smb
gzip
hal
hal-devel
hal-info
hal-libs
hamcrest
hdparm
hesiod
hicolor-icon-theme
hmaccalc
hpijs
hplip-common
hplip-libs
hsqldb
httpd
httpd-devel
httpd-manual
httpd-tools
hunspell
hunspell-en
hwdata
hyphen
hyphen-en
ibus
ibus-anthy
ibus-chewing
ibus-gtk
ibus-hangul
ibus-libs
ibus-m17n
ibus-pinyin
ibus-qt
ibus-rawcode
ibus-sayura
ibus-table
ibus-table-additional
icedax
icu4j-eclipse
ilmbase
imake
im-chooser
imsettings
imsettings-libs
indent
info
initscripts
intltool
iok
iotop
ipa-client
ipa-python
ipmitool
iproute
ipset
iptables
iptables-devel
iptables-ipv6
iptraf
iptstate
iputils
irqbalance
iso-codes
iw
jakarta-commons-codec
jakarta-commons-discovery
jakarta-commons-el
jakarta-commons-httpclient
jakarta-commons-io
jakarta-commons-lang
jakarta-commons-logging
jakarta-commons-net
jakarta-oro
jasper-libs
java
java
java
java
java
java
java_cup
jdepend
jdom
jetty-eclipse
jline
jna
jomolhari-fonts
jpackage-utils
jsch
junit
junit4
jwhois
jzlib
kasumi
kbd
kbd-misc
kernel
kernel
kernel
kernel-debuginfo-common-x86_64
kernel-devel
kernel-devel
kernel-devel
kernel-headers
kexec-tools
keyutils
keyutils-libs
keyutils-libs-devel
khmeros-base-fonts
khmeros-fonts-common
kpartx
kpathsea
krb5-devel
krb5-libs
krb5-workstation
kurdit-unikurd-web-fonts
latencytop
latencytop-common
latencytop-tui
latrace
lcms-libs
ledmon
less
libacl
libacl-devel
libaio
libao
libarchive
libart_lgpl
libart_lgpl-devel
libasyncns
libatasmart
libattr
libattr-devel
libavc1394
libbasicobjects
libblkid
libbonobo
libbonobo-devel
libbonoboui
libbonoboui-devel
libbsd
libbsd-devel
libburn
libcanberra
libcanberra-devel
libcanberra-gtk2
libcap
libcap-ng
libcap-ng-devel
libcdio
libcgroup
libcgroup-devel
libchewing
libcollection
libcom_err
libcom_err-devel
libcroco
libcroco-devel
libcurl
libcurl-devel
libdaemon
libdbi
libdbi-dbd-mysql
libdbi-drivers
libdhash
libdiscid
libdmx
libdrm
libdrm-devel
libdv
libedit
liberation-fonts-common
liberation-mono-fonts
liberation-sans-fonts
liberation-serif-fonts
libevent
libevent-devel
libevent-doc
libevent-headers
libexif
libffi
libfontenc
libfprint
libgail-gnome
libgcc
libgcj
libgcj-devel
libgcrypt
libgcrypt-devel
libgdata
libgdata-devel
libgfortran
libglade2
libglade2-devel
libgnat
libgnat-devel
libgnome
libgnomecanvas
libgnomecanvas-devel
libgnome-devel
libgnomekbd
libgnomeui
libgnomeui-devel
libgomp
libgpg-error
libgpg-error-devel
libgphoto2
libgpod
libgsf
libgsf-devel
libgssglue
libgtop2
libgudev1
libgweather
libgweather-devel
libgxim
libhangul
libical
libical-devel
libICE
libICE-devel
libicu
libIDL
libIDL-devel
libidn
libidn-devel
libiec61883
libieee1284
libimobiledevice
libini_config
libipa_hbac
libipa_hbac-python
libiptcdata
libisofs
libitm
libjpeg-turbo
libjpeg-turbo-devel
libldb
libmcpp
libmemcached
libmng
libmng-devel
libmnl
libmpcdec
libmtp
libmusicbrainz3
libnetfilter_conntrack
libnfnetlink
libnice
libnih
libnl
libnotify
libnotify-devel
libobjc
libogg
liboil
libopenraw
libopenraw-gnome
libotf
libpanelappletmm
libpath_utils
libpcap
libpciaccess
libplist
libpng
libpng-devel
libproxy
libproxy-bin
libproxy-python
libpurple
libraw1394
libref_array
libreoffice-calc
libreoffice-core
libreoffice-draw
libreoffice-graphicfilter
libreoffice-impress
libreoffice-langpack-en
libreoffice-math
libreoffice-opensymbol-fonts
libreoffice-pdfimport
libreoffice-ure
libreoffice-writer
libreoffice-xsltfilter
libreport
libreport-cli
libreport-compat
libreport-gtk
libreport-newt
libreport-plugin-kerneloops
libreport-plugin-logger
libreport-plugin-mailx
libreport-plugin-reportuploader
libreport-plugin-rhtsupport
libreport-python
librsvg2
librsvg2-devel
libsamplerate
libsane-hpaio
libselinux
libselinux-devel
libselinux-python
libselinux-utils
libsemanage
libsemanage-python
libsepol
libsepol-debuginfo
libsepol-devel
libsexy
libshout
libsigc++20
libSM
libsmbclient
libSM-devel
libsmi
libsndfile
libsoup
libsoup-devel
libspectre
libspiro
libss
libssh2
libsss_idmap
libstdc++
libstdc++-devel
libstdc++-docs
libtalloc
libtar
libtasn1
libtasn1-devel
libtdb
libtevent
libthai
libtheora
libtiff
libtirpc
libtool
libtool-ltdl
libtool-ltdl-devel
libtopology
libtopology-devel
libudev
libudev-devel
libusb
libusb1
libusb-devel
libuser
libuser-python
libutempter
libuuid
libuuid-devel
libv4l
libvirt-client
libvirt-devel
libvirt-java
libvirt-java-devel
libvisual
libvorbis
libvpx
libwacom
libwacom-data
libwmf
libwmf-lite
libwnck
libX11
libX11-common
libX11-devel
libXau
libXau-devel
libXaw
libxcb
libxcb-devel
libXcomposite
libXcomposite-devel
libXcursor
libXcursor-devel
libXdamage
libXdamage-devel
libXdmcp
libxdo
libXext
libXext-devel
libXfixes
libXfixes-devel
libXfont
libXft
libXft-devel
libXi
libXi-devel
libXinerama
libXinerama-devel
libxkbfile
libxklavier
libxml2
libxml2-devel
libxml2-python
libXmu
libXmu-devel
libXp
libXp-devel
libXpm
libXrandr
libXrandr-devel
libXrender
libXrender-devel
libXres
libXScrnSaver
libxslt
libxslt-devel
libXt
libXt-devel
libXtst
libXtst-devel
libXv
libXvMC
libXxf86dga
libXxf86misc
libXxf86vm
libXxf86vm-devel
libzip
lklug-fonts
lm_sensors
lm_sensors-devel
lm_sensors-libs
lockdev
log4j
logrotate
lohit-assamese-fonts
lohit-bengali-fonts
lohit-devanagari-fonts
lohit-gujarati-fonts
lohit-kannada-fonts
lohit-oriya-fonts
lohit-punjabi-fonts
lohit-tamil-fonts
lohit-telugu-fonts
lpg-java-compat
lpsolve
lslk
lsof
ltrace
lua
lucene
lucene-contrib
lvm2
lvm2-libs
lx
lzo
m17n-contrib
m17n-contrib-assamese
m17n-contrib-bengali
m17n-contrib-gujarati
m17n-contrib-hindi
m17n-contrib-kannada
m17n-contrib-maithili
m17n-contrib-malayalam
m17n-contrib-marathi
m17n-contrib-oriya
m17n-contrib-punjabi
m17n-contrib-sinhala
m17n-contrib-tamil
m17n-contrib-telugu
m17n-contrib-urdu
m17n-db
m17n-db-assamese
m17n-db-bengali
m17n-db-datafiles
m17n-db-gujarati
m17n-db-hindi
m17n-db-kannada
m17n-db-malayalam
m17n-db-oriya
m17n-db-punjabi
m17n-db-sinhala
m17n-db-tamil
m17n-db-telugu
m17n-db-thai
m17n-lib
m2crypto
m4
madan-fonts
mailcap
mailx
make
MAKEDEV
man
man-pages
man-pages-overrides
mc
mcelog
mcpp
mdadm
meanwhile
media-player-info
memtest86+
mercurial
mesa-dri1-drivers
mesa-dri-drivers
mesa-dri-filesystem
mesa-libEGL
mesa-libgbm
mesa-libGL
mesa-libGL-devel
mesa-libGLU
mesa-libGLU-devel
mesa-libGLw
mesa-libGLw-devel
mesa-private-llvm
metacity
mgetty
min12xxw
mingetty
mlocate
mobile-broadband-provider-info
mod_dnssd
ModemManager
mod_perl
mod_ssl
module-init-tools
mod_wsgi
mousetweaks
mozilla-filesystem
mpfr
mtdev
mtools
mtr
mx4j
mysql
mysql-bench
mysql-connector-java
mysql-connector-odbc
mysql-devel
mysql-libs
MySQL-python
mysql-server
mysql-test
mythes-en
nano
nasm
nautilus
nautilus-extensions
nautilus-open-terminal
nautilus-sendto
nc
ncurses
ncurses-base
ncurses-devel
ncurses-libs
neon
netpbm
netpbm-progs
net-snmp
net-snmp-devel
net-snmp-libs
net-snmp-perl
net-snmp-python
net-snmp-utils
net-tools
NetworkManager
NetworkManager-glib
NetworkManager-gnome
newt
newt-python
nfs4-acl-tools
nfs-utils
nfs-utils-lib
nmap
notification-daemon
notify-python
nspluginwrapper
nspr
nspr-devel
nss
nss_compat_ossl
nss-devel
nss-softokn
nss-softokn-devel
nss-softokn-freebl
nss-softokn-freebl-devel
nss-sysinit
nss-tools
nss-util
nss-util-devel
ntp
ntpdate
ntsysv
numactl
numpy
obexd
obex-data-server
objectweb-asm
oddjob
oddjob-mkhomedir
opal
openchange
OpenEXR-libs
OpenIPMI
OpenIPMI-libs
openjade
openjpeg-libs
openldap
openldap-devel
openmotif
openmotif-devel
openobex
opensp
openssh
openssh-askpass
openssh-clients
openssh-server
openssl
openssl-devel
openswan
oprofile
oprofile-gui
oprofile-jit
ORBit2
ORBit2-devel
orca
p11-kit
p11-kit-trust
PackageKit
PackageKit-device-rebind
PackageKit-glib
PackageKit-gstreamer-plugin
PackageKit-gtk-module
PackageKit-yum
PackageKit-yum-plugin
pakchois
paktype-fonts-common
paktype-naqsh-fonts
paktype-tehreer-fonts
pam
pam-devel
pam_krb5
pam_passwdqc
pango
pango-devel
pangomm
papi
paps
paps-libs
parted
passwd
patch
patchutils
pax
pbm2l2030
pbm2l7k
pciutils
pciutils-libs
pcmciautils
pcre
perf
perl
perl-Archive-Extract
perl-Archive-Tar
perl-Bit-Vector
perl-BSD-Resource
perl-Cache-Memcached
perl-Carp-Clan
perl-CGI
perl-Compress-Raw-Bzip2
perl-Compress-Raw-Zlib
perl-Compress-Zlib
perl-core
perl-CPAN
perl-CPANPLUS
perl-Crypt-OpenSSL-Bignum
perl-Crypt-OpenSSL-Random
perl-Crypt-OpenSSL-RSA
perl-Crypt-SSLeay
perl-Date-Calc
perl-DBD-MySQL
perl-DBD-SQLite
perl-DBI
perl-DBIx-Simple
perl-devel
perl-Devel-Symdump
perl-Digest-HMAC
perl-Digest-SHA
perl-Digest-SHA1
perl-Encode-Detect
perl-Error
perl-ExtUtils-CBuilder
perl-ExtUtils-Embed
perl-ExtUtils-MakeMaker
perl-ExtUtils-ParseXS
perl-File-Fetch
perl-Frontier-RPC
perl-Frontier-RPC-doc
perl-Git
perl-HTML-Parser
perl-HTML-Tagset
perl-IO-Compress-Base
perl-IO-Compress-Bzip2
perl-IO-Compress-Zlib
perl-IO-Socket-INET6
perl-IO-Socket-SSL
perl-IO-Zlib
perl-IPC-Cmd
perl-libs
perl-libwww-perl
perl-libxml-perl
perl-Locale-Maketext-Simple
perl-Log-Message
perl-Log-Message-Simple
perl-Mail-DKIM
perl-MailTools
perl-Module-Build
perl-Module-CoreList
perl-Module-Load
perl-Module-Load-Conditional
perl-Module-Loaded
perl-Module-Pluggable
perl-NetAddr-IP
perl-Net-DNS
perl-Net-LibIDN
perl-Net-SSLeay
perl-Newt
perl-Object-Accessor
perl-Package-Constants
perl-Params-Check
perl-parent
perl-Parse-CPAN-Meta
perl-Pod-Coverage
perl-Pod-Escapes
perl-Pod-Simple
perl-SGMLSpm
perl-Socket6
perl-String-CRC32
perl-suidperl
perl-Term-UI
perl-Test-Harness
perl-Test-Pod
perl-Test-Pod-Coverage
perl-Test-Simple
perltidy
perl-TimeDate
perl-Time-HiRes
perl-Time-Piece
perl-URI
perl-version
perl-XML-Dumper
perl-XML-Grove
perl-XML-Parser
perl-XML-Twig
phonon-backend-gstreamer
pidgin
pinentry
pinentry-gtk
pinfo
pixman
pixman-devel
pkgconfig
plymouth
plymouth-core-libs
plymouth-gdm-hooks
plymouth-graphics-libs
plymouth-plugin-label
plymouth-plugin-two-step
plymouth-scripts
plymouth-system-theme
plymouth-theme-rings
plymouth-utils
pm-utils
pnm2ppa
policycoreutils
policycoreutils-gui
policycoreutils-python
polkit
polkit-desktop-policy
polkit-devel
polkit-docs
polkit-gnome
poppler
poppler-data
poppler-glib
poppler-utils
popt
popt-devel
portreserve
postfix
postgresql
postgresql-devel
postgresql-libs
powertop
ppl
ppp
prelink
printer-filters
procmail
procps
psacct
ps_mem
psmisc
psutils
pth
ptlib
ptouch-driver
pulseaudio
pulseaudio-gdm-hooks
pulseaudio-libs
pulseaudio-libs-devel
pulseaudio-libs-glib2
pulseaudio-libs-zeroconf
pulseaudio-module-bluetooth
pulseaudio-module-gconf
pulseaudio-module-x11
pulseaudio-utils
pycairo
pycairo-devel
pychart
pygobject2
pygobject2-codegen
pygobject2-devel
pygobject2-doc
pygpgme
pygtk2
pygtk2-codegen
pygtk2-devel
pygtk2-doc
pygtk2-libglade
pygtksourceview
pyOpenSSL
pyorbit
pytalloc
python
python-babel
python-beaker
python-crypto
python-dateutil
python-decorator
python-devel
python-docs
python-enchant
python-ethtool
python-gtkextra
python-iniparse
python-iwlib
python-kerberos
python-krbV
python-ldap
python-libs
python-lxml
python-magic
python-mako
python-markupsafe
python-matplotlib
python-meh
python-memcached
python-netaddr
python-nose
python-nss
python-paramiko
python-pycurl
python-setuptools
python-sexy
python-slip
python-slip-dbus
python-slip-gtk
python-sssdconfig
python-urlgrabber
pytz
pywebkitgtk
pyxdg
pyxf86config
qdox
qt
qt3
qt3-devel
qt-devel
qt-sqlite
qt-x11
quota
rarian
rarian-compat
rcs
rdate
readahead
readline
readline-devel
redhat-bookmarks
redhat-logos
redhat-lsb
redhat-lsb-compat
redhat-lsb-core
redhat-lsb-graphics
redhat-lsb-printing
redhat-menus
redhat-rpm-config
regexp
rfkill
rhino
rhythmbox
rng-tools
rome
rootfiles
rpcbind
rpm
rpm-build
rpm-devel
rpmdevtools
rpm-libs
rpmlint
rpm-python
rsync
rsyslog
rtkit
sac
samba4-libs
samba-client
samba-common
samba-winbind
samba-winbind-clients
sane-backends
sane-backends-libs
sane-backends-libs-gphoto2
sane-frontends
sat4j
scenery-backgrounds
scl-utils
screen
scrub
SDL
seahorse
seahorse-plugins
sed
seekwatcher
selinux-policy
selinux-policy-targeted
setools-console
setools-libs
setools-libs-python
setroubleshoot
setroubleshoot-plugins
setroubleshoot-server
setserial
setup
setuptool
sg3_utils-libs
sgml-common
sgpio
shadow-utils
shared-mime-info
sil-padauk-fonts
sinjdoc
slang
slf4j
smartmontools
smc-fonts-common
smc-meera-fonts
smp_utils
snappy
sos
sound-juicer
sound-theme-freedesktop
spamassassin
speex
spice-vdagent
sqlite
sqlite-devel
sssd
sssd-ad
sssd-client
sssd-common
sssd-common-pac
sssd-ipa
sssd-krb5
sssd-krb5-common
sssd-ldap
sssd-proxy
startup-notification
startup-notification-devel
stix-fonts
strace
stunnel
subversion
subversion-javahl
sudo
svnkit
swig
sysstat
system-config-date
system-config-date-docs
system-config-firewall
system-config-firewall-base
system-config-firewall-tui
system-config-kdump
system-config-keyboard
system-config-keyboard-base
system-config-lvm
system-config-network-tui
system-config-printer
system-config-printer-libs
system-config-printer-udev
system-config-services
system-config-services-docs
system-config-users
system-config-users-docs
system-gnome-theme
system-icon-theme
system-setup-keyboard
systemtap
systemtap-client
systemtap-devel
systemtap-initscript
systemtap-runtime
systemtap-sdt-devel
systemtap-server
sysvinit-tools
taglib
tar
tbb
tbb-devel
tcl
tcpdump
tcp_wrappers
tcp_wrappers-devel
tcp_wrappers-libs
tcsh
telnet
tex-cm-lgc
texlive
texlive-dvips
texlive-latex
texlive-texmf
texlive-texmf-dvips
texlive-texmf-errata
texlive-texmf-errata-dvips
texlive-texmf-errata-fonts
texlive-texmf-errata-latex
texlive-texmf-fonts
texlive-texmf-latex
texlive-utils
tex-preview
thai-scalable-fonts-common
thai-scalable-waree-fonts
theora-tools
tibetan-machine-uni-fonts
time
tmpwatch
tokyocabinet
tokyocabinet-devel
totem
totem-mozplugin
totem-nautilus
totem-pl-parser
trace-cmd
traceroute
trilead-ssh2
ttmkfdir
tzdata
tzdata-java
udev
udisks
un-core-dotum-fonts
un-core-fonts-common
unique
unixODBC
unzip
upstart
urw-fonts
usbmuxd
usbutils
usermode
usermode-gtk
ustr
util-linux-ng
valgrind
valgrind-devel
vconfig
vim-common
vim-enhanced
vim-minimal
vino
virt-what
vlgothic-fonts
vlgothic-fonts-common
vorbis-tools
vte
wacomexpresskeys
watchdog
wavpack
wdaemon
webalizer
webkitgtk
wget
which
wireless-tools
wireshark
wireshark-gnome
wodim
words
wpa_supplicant
wqy-zenhei-fonts
ws-commons-util
wsdl4j
ws-jaxme
xalan-j2
xcb-util
xdg-user-dirs
xdg-user-dirs-gtk
xdg-utils
xerces-j2
xinetd
xkeyboard-config
xml-common
xml-commons-apis
xml-commons-resolver
xmldb-api
xmldb-api-sdk
xmlgraphics-commons
xmlrpc3-client
xmlrpc3-common
xmlrpc-c
xmlrpc-c-client
xmlto
xorg-x11-docs
xorg-x11-drivers
xorg-x11-drv-acecad
xorg-x11-drv-aiptek
xorg-x11-drv-apm
xorg-x11-drv-ast
xorg-x11-drv-ati
xorg-x11-drv-cirrus
xorg-x11-drv-dummy
xorg-x11-drv-elographics
xorg-x11-drv-evdev
xorg-x11-drv-fbdev
xorg-x11-drv-fpit
xorg-x11-drv-glint
xorg-x11-drv-hyperpen
xorg-x11-drv-i128
xorg-x11-drv-i740
xorg-x11-drv-intel
xorg-x11-drv-keyboard
xorg-x11-drv-mach64
xorg-x11-drv-mga
xorg-x11-drv-modesetting
xorg-x11-drv-mouse
xorg-x11-drv-mutouch
xorg-x11-drv-nouveau
xorg-x11-drv-nv
xorg-x11-drv-openchrome
xorg-x11-drv-penmount
xorg-x11-drv-qxl
xorg-x11-drv-r128
xorg-x11-drv-rendition
xorg-x11-drv-s3virge
xorg-x11-drv-savage
xorg-x11-drv-siliconmotion
xorg-x11-drv-sis
xorg-x11-drv-sisusb
xorg-x11-drv-synaptics
xorg-x11-drv-tdfx
xorg-x11-drv-trident
xorg-x11-drv-v4l
xorg-x11-drv-vesa
xorg-x11-drv-vmmouse
xorg-x11-drv-vmware
xorg-x11-drv-void
xorg-x11-drv-voodoo
xorg-x11-drv-wacom
xorg-x11-drv-xgi
xorg-x11-fonts-100dpi
xorg-x11-fonts-misc
xorg-x11-fonts-Type1
xorg-x11-font-utils
xorg-x11-fonts-ISO8859-1-100dpi
xorg-x11-glamor
xorg-x11-proto-devel
xorg-x11-server-common
xorg-x11-server-utils
xorg-x11-server-Xorg
xorg-x11-utils
xorg-x11-xauth
xorg-x11-xinit
xorg-x11-xkb-utils
xrestop
xsane
xsane-common
xsane-gimp
xulrunner
xvattr
xz
xz-devel
xz-libs
xz-lzma-compat
yajl
yelp
ypbind
yp-tools
yum
yum-metadata-parser
yum-plugin-auto-update-debug-info
yum-plugin-fastestmirror
yum-plugin-security
yum-utils
zenity
zip
zlib
zlib-debuginfo
zlib-devel
-microcode_ctl
-*firmware
%end

%post

# Create the magma user account.
/usr/sbin/useradd magma
echo "magma" | passwd --stdin magma

# Make the future magma user a sudo master.
sed -i "s/^.*requiretty/#Defaults requiretty/" /etc/sudoers
echo "magma        ALL=(ALL)       NOPASSWD: ALL" >> /etc/sudoers.d/magma
chmod 0440 /etc/sudoers.d/magma

VIRT=`dmesg | grep "Hypervisor detected" | awk -F': ' '{print $2}'`
if [[ $VIRT == "Microsoft HyperV" ]]; then
    yum --assumeyes install eject hyperv-daemons
    chkconfig hypervvssd on
    chkconfig hypervkvpd on
#    eject /dev/cdrom
fi

%end
