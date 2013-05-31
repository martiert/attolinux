#!/bin/bash
cd `dirname $0`

if [ ! -f ~/.oe/environment-atto ]; then
    echo "OpenEmbedded is not configured, please run \"MACHINE=<machineid> ./oebb.sh config <machineid>\"first!"
    exit 1
fi

bash --rcfile atto-bashrc
