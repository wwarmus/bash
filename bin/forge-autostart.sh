#!/bin/bash -x
set -o nounset

# based define IPs
readonly ALLOWED_IPS="10.11.12.30 10.11.14.30"

# autodetect active interface by checking default route
_INTERFACE=$(ip r s | grep default | awk '{print $5}')

# since there might be no default route, autodetect may return null
# so check is needed
if [[ -z ${_INTERFACE} ]]; then
  echo "No active inet device detected. Quitting"
  exit 1
fi

# or set explicit interface get current IP of the ethernet interface
#_INTERFACE="em1"

# get current IP
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
