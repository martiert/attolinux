#!/bin/bash
# OpenEmbedded setup on a clean Debian based distribution

cd `dirname $0`

if [ -f ./environment-oecore ]; then
    echo "OpenEmbedded is already configured, run ./atto-shell.sh to start using it!"
    exit 1
fi

target_dir="oe"

# Install packages
which apt-get &> /dev/null
have_apt_get=$?

if [ $have_apt_get -eq 0 ];
then
    # Set up sh to use bash (needed for qt5 install scripts)
    echo dash dash/sh select false | sudo debconf-set-selections
    sudo dpkg-reconfigure -u dash

    # Install dependencies
   if sudo apt-get install --assume-yes \
        build-essential linux-headers-generic git sed wget cvs \
        subversion coreutils unzip texi2html docbook-utils sharutils gawk \
        python-pysqlite2 diffstat help2man bzr-rewrite make gcc g++ \
        desktop-file-utils chrpath libxml2-utils xmlto docbook texinfo \
        ia32-libs gcc-multilib gawk libgl1-mesa-dev dos2unix; 
    then
        echo "setup-oe: Installed all required dependencies"
    else
        echo "setup-oe: Could not install all dependencies. Aborting setup"
        exit 1
    fi
else
    echo "You are not running a debian distribution, and we can not automatically install the required packages"
    echo "Please see: http://www.openembedded.org/wiki/Required_software for the software requirements, and install them."
    echo "http://www.openembedded.org/wiki/OEandYourDistro have distro specific instructions, but might be outdated."
fi

pushd $target_dir >/dev/null
MACHINE=atto-panda ./oebb.sh config atto-panda
MACHINE=atto-panda ./oebb.sh update

if [ "x$1" = "x--with-origin" ]; then
    #setup master on git repo's
    pushd sources >/dev/null
    for dir in "bitbake" "meta-openembedded" "openembedded-core"; do
        pushd $dir >/dev/null
        git remote rename origin tetris
        case $dir in
            "bitbake")
                git remote add origin git://git.openembedded.org/bitbake
            ;;
            "meta-openembedded")
                git remote add origin git://git.openembedded.org/meta-openembedded
            ;;
            "openembedded-core")
                git remote add origin git://git.openembedded.org/openembedded-core
            ;;
            *)
                echo $dir
            ;;
        esac
        git fetch origin
        git branch master origin/master
        popd >/dev/null
    done
    popd >/dev/null
fi

popd >/dev/null
echo "Done!"

