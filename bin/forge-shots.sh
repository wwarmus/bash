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

# checking for requirements
declare -a _REQ=(scrot git)
for _cmd in ${_REQ[@]};
  do f_n_cmdAvailable ${_cmd} || exit 1
done


#########
# START #
######$##

#point this to the place where you have the git repo
#_HOME=
_FILE=$(date | md5sum | awk '{print $1}').png
_SHOT="scrot -s ${_HOME}/${_FILE}"
_REPO="https://github.com/TheLorekeeper/shots"
_URL="${_REPO}/raw/master/${_FILE}"

cd ${_HOME}
${_SHOT}

git add ${_FILE}
git commit -m "Add ${_FILE}"
git push

echo ${_URL} | xsel --clipboard --input --display :0
