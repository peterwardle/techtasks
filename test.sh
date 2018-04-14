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

for f in {1..5}; do
    dd bs=1M count=1 if=/dev/urandom of="/app/logs/logfile-${f}.log" &> /dev/null
    sleep 1
done


## Remove oldest entry due to limited storage (buffer required is 100% storage space)
log "Remove oldest entry due to limited storage (buffer required is 100% storage space)"

test "$(ls -1 /app/logs | wc -l)" -eq "5"
test -e /app/logs/logfile-1.log

/opt/housekeeping/bin/logrotate.py /app/logs --buffer 100

test "$(ls -1 /app/logs | wc -l)" -eq "4"
test ! -e /app/logs/logfile-1.log


## Leave oldest entry due to sufficient storage (buffer required is 10% storage space)
log "Leave oldest entry due to sufficient storage (buffer required is 10% storage space)"

test "$(ls -1 /app/logs | wc -l)" -eq "4"
test -e /app/logs/logfile-2.log

/opt/housekeeping/bin/logrotate.py /app/logs --buffer 10

test "$(ls -1 /app/logs | wc -l)" -eq "4"
test -e /app/logs/logfile-2.log


## Remove oldest entry due to limited storage (buffer required is 100% storage space)
log "Remove oldest entry due to limited storage (buffer required is 100% storage space)"

test "$(ls -1 /app/logs | wc -l)" -eq "4"
test -e /app/logs/logfile-2.log

/opt/housekeeping/bin/logrotate.py /app/logs --buffer 100

test "$(ls -1 /app/logs | wc -l)" -eq "3"
test ! -e /app/logs/logfile-2.log
