#!/bin/bash

script=test.sh
host=$( hostname )
racadm=/opt/dell/srvadmin/sbin/racadm

log() {
    echo $script: $host: $( date +%H:%M:%S ): $*.
}

error_exit() {
    log ERROR: $*. Stopping update
    exit 1
}

get_bios_version() {
    local ver
    
    ver=$( facter | grep bios_version | sed -e 's/.* //' )
    if [[ ! -z $ver ]]; then
        log "Currently installed bios version is '$ver'"
        echo $ver
        return 0
    fi
    
    ver=$( dmidecode -s bios-version )
    if [[ ! -z $ver ]]; then
        log "Currently installed bios version is '$ver'"
        echo $ver
        return 0
    fi
    
    ver=$( $racadm getversion -b | perl -ne 'm/.*Bios Version.*= *(.*)/i && print qq{$1}' )
    if [[ ! -z $ver ]]; then
        log "Currently installed bios version is '$ver'"
        echo $ver
        return 0
    fi
    
    log WARNING: Not able to detect currently installed bios version
    return 1
}

myver=$( get_bios_version )
echo main: [$myver]
echo hello there i havent left yet
