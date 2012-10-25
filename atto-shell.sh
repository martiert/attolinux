#!/bin/bash
cd `dirname $0`

if [ ! -f ./environment-oecore ]; then
    echo "OpenEmbedded is not configured, please run ./setup-oe.sh first!"
    exit 1
fi

bash --rcfile atto-bashrc
