#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

test -z "${DEBUG:-}" || {
    set -x
}

function log {
    local now=$(date +'%Y-%m-%d %H:%M:%S')
    echo "[$now] $1"
}

HOUSEKEEPING_DIRECTORY=/opt/housekeeping
HOUSEKEEPING_SOURCE=https://github.com/peterwardle/techtasks-housekeeping/archive/master.tar.gz

if [ ! -d "$HOUSEKEEPING_DIRECTORY" ]; then
    mkdir -p "$HOUSEKEEPING_DIRECTORY"
    log "Created directory $HOUSEKEEPING_DIRECTORY"
    wget -O - "$HOUSEKEEPING_SOURCE" | tar --strip-components=1 -xzC "$HOUSEKEEPING_DIRECTORY"
    log "Installed source from $HOUSEKEEPING_SOURCE"
fi

puppet apply "$HOUSEKEEPING_DIRECTORY/puppet/manifest.pp"
