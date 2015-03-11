#!/bin/bash -x
set -o nounset

# based define IPs
readonly ALLOWED_IPS="10.11.12.30 10.11.14.30"

# get current IP of the ethernet interface
# (adjust the _INTERFACE variable)
_INTERFACE="em1"
_ip=$(ifconfig ${_INTERFACE} | grep inet | awk '{print $2}')

# declare commands to be run
declare -a _APPS=( \
       'firefox' \
       'gajim' \
       )
_APPS_LEN=${#_APPS[@]}

# if current IP is the same as the one of defined 
# run the declared applications
if [[ "${ALLOWED_IPS}" =~ "${_ip}" ]]; then
    for i in $(seq 0 $((${_APPS_LEN}-1))) ; do
        ${_APPS[$i]} &
        sleep 1
    done
fi
