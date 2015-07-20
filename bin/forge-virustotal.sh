#!/bin/bash
set -o nounset

# function for loading libraries
_LIB_BASEDIR=lib
function f_libLoad() {
  _lib=$1
  _CWD=$(dirname $0)
  if [[ -e ${_CWD}/../${_LIB_BASEDIR}/${_lib} ]]; then
    source ${_CWD}/../${_LIB_BASEDIR}/${_lib}
  else
    echo "ERR: Library ${_lib} not found in ${_CWD}../${_LIB_BASEDIR}/"
    exit 1
  fi
}
f_libLoad f_libLoad

# loading libraries
f_libLoad f_cmdAvailable
f_libLoad f_virusTotal

# checking for requirements
declare -a _REQ=(curl python sha256sum)
for _cmd in ${_REQ[@]};
  do f_n_cmdAvailable ${_cmd} || exit 1
done


#########
# START #
#########

_file=$(realpath "$1")
if [[ -e "${_file}" ]] ; then
  _hash=$(sha256sum ${_file})

  # check if file was already scanned 
  # and report is available for it
  _ret=$(f_s_vsFileReport ${_hash})
  _retCode=$(echo ${_ret} | grep -Po '"response_code": \d*' | awk '{print $2}')
  if [[ ${_retCode} -eq 0 ]]; then
    _ret=$(f_s_vsUploadFile ${_file})
    while ${_retCode} -eq 0 ; do
      sleep 5
      _retCode=$(f_s_vsFileReport ${_hash} | grep -Po '"response_code": \d*' | awk '{print $2}')
    done
  fi
  echo ${_ret} | python -mjson.tool
fi
