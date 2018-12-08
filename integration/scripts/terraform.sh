#!/bin/bash

###############################################################################
#
# This script will run Terraform in a Docker container
#
# Useful for Jenkins or other systems that do not have Terraform installed
#
###############################################################################

SSH_KEYS_PATH="${SSH_KEYS_PATH:-"${HOME}/.ssh"}"
OCI_KEYS_PATH="${OCI_KEYS_PATH:-"${HOME}/.oci"}"
CHEF_KEYS_PATH="${CHEF_KEYS_PATH:-"${HOME}/.chef"}"

CONTAINER_HOME="$(dirname $SSH_KEYS_PATH)"

# Ugly hack to get around ssh errors related to /etc/passwd
# overriding the $HOME location when mounted in docker
TMP_ETC_PASSWD="$(mktemp /tmp/tmp-etc_passwd.XXXXXXXX)"
_cleanup(){ prev_errcode=$?; rm -f $TMP_ETC_PASSWD; exit $prev_errcode; }
trap "_cleanup" EXIT

echo "root:x:0:0::/root:/bin/sh" > $TMP_ETC_PASSWD
echo "$USER:x:$UID:$GID::$CONTAINER_HOME:/bin/sh" >> $TMP_ETC_PASSWD

# Another hack to detect if we're running locally or on Jenkins (no TTY)
test -t 1 && PSEUDO_TTY=t

docker run --rm \
  -i$PSEUDO_TTY \
  -u "$(id -u)" \
  -v "$(pwd)":/terraform \
  -v "${TMP_ETC_PASSWD}":"/etc/passwd:ro" \
  -v "${SSH_KEYS_PATH}":"${SSH_KEYS_PATH}:ro" \
  -v "${OCI_KEYS_PATH}":"${OCI_KEYS_PATH}:ro" \
  -v "${TF_MODULE_PATH}":"${TF_MODULE_PATH}:ro" \
  -v "${CHEF_KEYS_PATH}":"${CHEF_KEYS_PATH}:ro" \
  -e HOME="${CONTAINER_HOME}" \
  --env-file <(env | grep -e TF_VAR -e AWS_ACCESS_KEY_ID -e AWS_SECRET_ACCESS_KEY) \
  "artifacts.dynguts.net:5001/dyn_terraform:2.0.0" $@
