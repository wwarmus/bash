#!/bin/bash -x

source lib/f_cmdAvailable

set -o nounset

declare -a _REQ=(scrot git)
for _cmd in ${_REQ[@]};
  do f_r_cmdAvailable ${_cmd} || exit 1
done

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
