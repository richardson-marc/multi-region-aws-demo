SCRIPT_PATH=./scripts

# To insure environment uniformity this repo defaults to using docker.
# You can override this by setting TF_BIN to reference a different binary:
# For example: `TF_BIN=terraform make -e tf-plan` to use a locally installed
# terraform binary (not recommended).
TF_BIN?="${SCRIPT_PATH}/terraform.sh"

# location within the repo of terraform modules
TF_MODULE_PATH=.

# DEBUG, set log to emtpy string to turn off
# [TRACE DEBUG INFO WARN ERROR]
TF_LOG='DEBUG'
TF_LOG_PATH=./logfiles/tf_run.log

#REGION_VAR_DIR=regions
#ENV_DIR=`pwd`
#ENVIRONMENT=`basename "$ENV_DIR"`
# full path, not basenamed
PWD := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))
ENVIRONMENT := $(notdir $(patsubst %/,%,$(dir $(PWD))))
#ENVIRONMENT=$(basename $(ENV_DIR))	
# uses this string
#ENVIRONMENT=`basename $(pwd)`
#REGION_ID=us-east-1

#LOCATION=$(word 2,$(subst -, ,$(REGION_ID)))
#REGION_VAR_FILE="${REGION_VAR_DIR}/${REGION_ID}/${REGION_ID}.tfvars"

all: tf-plan

copy:
	cp -pr ../modules .
	cp -pr ../scripts .

tf-version:
	@${TF_BIN} version

tf-init: logdir copy
	TF_LOG=${TF_LOG} TF_LOG_PATH=${TF_LOG_PATH} \
	${TF_BIN} init

tf-env-new: logdir
	TF_LOG=${TF_LOG} TF_LOG_PATH=${TF_LOG_PATH} \
	${TF_BIN} workspace new ${ENVIRONMENT}

tf-env-select: logdir
	TF_LOG=${TF_LOG} TF_LOG_PATH=${TF_LOG_PATH} \
	${TF_BIN} workspace select ${ENVIRONMENT}

tf-style: copy logdir
	TF_LOG=${TF_LOG} TF_LOG_PATH=${TF_LOG_PATH} \
	${TF_BIN} fmt ${TF_MODULE_PATH}
	TF_VAR_env_user=${TF_VAR_env_user} \
	${TF_BIN} validate \
#	--var-file=${REGION_VAR_FILE} \
	${TF_MODULE_PATH}

tf-get: copy logdir tf-style tf-env-select
	TF_LOG=${TF_LOG} TF_LOG_PATH=${TF_LOG_PATH} \
	TF_VAR_env_user=${TF_VAR_env_user} \
	TF_VAR_tag_environment=${TF_VAR_tag_environment} \
	${TF_BIN} get \
	${TF_MODULE_PATH}

tf-plan: copy logdir tf-init tf-get tf-style tf-env-select
	TF_LOG=${TF_LOG} TF_LOG_PATH=${TF_LOG_PATH} \
	${TF_BIN} plan \
#	--var-file=${REGION_VAR_FILE} \
	${TF_MODULE_PATH}

tf-refresh: tf-style
	TF_LOG=${TF_LOG} TF_LOG_PATH=${TF_LOG_PATH} \
	TF_VAR_env_user=${TF_VAR_env_user} \
	${TF_BIN} refresh \
#	--var-file=${REGION_VAR_FILE} \
	${TF_MODULE_PATH}

tf-apply: logdir tf-init tf-get tf-style tf-env-select
	TF_LOG=${TF_LOG} TF_LOG_PATH=${TF_LOG_PATH} \
	TF_VAR_env_user=${TF_VAR_env_user} \
	${TF_BIN} apply \
#	--var-file=${REGION_VAR_FILE} \
	${TF_MODULE_PATH}

tf-plan-destroy: tf-get tf-style tf-env-select
	TF_LOG=${TF_LOG} TF_LOG_PATH=${TF_LOG_PATH} \
	TF_VAR_env_user=${TF_VAR_env_user} \
	${TF_BIN} plan --destroy \
#	--var-file=${REGION_VAR_FILE} \
	${TF_MODULE_PATH}

tf-destroy: tf-get tf-style tf-env-select
	TF_LOG=${TF_LOG} TF_LOG_PATH=${TF_LOG_PATH} \
	TF_VAR_env_user=${TF_VAR_env_user} \
	${TF_BIN} destroy \
#	--var-file=${REGION_VAR_FILE} \
	${TF_MODULE_PATH}

logdir:
	mkdir -p logfiles

clean-up:
	rm -rf ${TF_MODULE_PATH}/.terraform/modules/*