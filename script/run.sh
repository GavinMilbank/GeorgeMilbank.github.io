#!/bin/bash -xv
echo ${STAGE:?is null} > /dev/null
echo ${STACK:?is null} > /dev/null
export ROLE=${ROLE:-""}
export IS_PULL=${IS_PULL:-""}
TARGET=prod
while true ; do
  case ${1} in
    --dev)
        shift
        TARGET=dev
    ;;
    *)
        DOCKERFILE=${1}
        shift
        CMDLINE="$*"
        break
    ;;
  esac
done
set -evxo pipefail # error handling
[ -f "${DOCKERFILE}" ]

VERSION_LABEL=${VERSION_LABEL:-latest}
IMAGE_TYPE=$(echo $(basename ${DOCKERFILE}) | awk -F. '{print $2}')
IMAGE_URL=${IMAGE_URL:-${APP_NAME}-${IMAGE_TYPE}-${TARGET}:${VERSION_LABEL}}

if [[ ! -z "${IS_PULL}" ]]; then
    docker pull ${IMAGE_URL}
fi
if [[ ! -z "${STAGE}" ]]; then
    STAGE_ARGS="-e STAGE=${STAGE}"
fi
if [[ ! -z "${ROLE}" ]]; then
    CREDS=$(aws sts assume-role --role-arn arn:aws:iam::${AWS_ACCOUNT_ID}:role/${ROLE} --role-session-name `whoami`)
    CRED_ARGS="
    -e AWS_SECRET_ACCESS_KEY=$(echo $CREDS | jq -r .Credentials.SecretAccessKey)
    -e AWS_ACCESS_KEY_ID=$(echo $CREDS | jq -r .Credentials.AccessKeyId)
    -e AWS_SESSION_TOKEN=$(echo $CREDS | jq -r .Credentials.SessionToken)
    -e AWS_SESSION_EXPIRATION=$(echo $CREDS | jq -r .Credentials.Expiration)
    "
else
    CRED_ARGS="
    -e AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY}
    -e AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID}
    "
fi

if [ "${IMAGE_TYPE}" == "rstudio" ]; then
    CONTAINER_HOME=/home/rstudio
    NET_ARGS="-e DISABLE_AUTH=true -p 8787"
fi

if [ ! -z "${APP_PORT}" ]; then
    NET_ARGS="${NET_ARGS} -p ${APP_PORT}:${APP_PORT}"
fi

if [ "dev"=="${TARGET}" ]; then
    MOUNT_ARGS="
        -v "$(pwd):${CONTAINER_HOME}"
        -v "${HOME}/.ssh:/root/.ssh"
        -v "${HOME}/.ssh:${CONTAINER_HOME}/.ssh"
        -v "${HOME}/.aws:${CONTAINER_HOME}/.aws"
    "
else
    MOUNT_ARGS=""
fi

TMPFILE=$(mktemp)
./env-stage.sh --stage ${STAGE} --stack ${STACK} > ${TMPFILE}
cp ${TMPFILE} ./data
ENVFILE=$(pwd)/data/$(basename $TMPFILE)
echo ENVFILE=${ENVFILE}

echo Role=$(aws-id.sh)
docker run -it \
    --env-file ${ENVFILE} \
    -v ${ENVFILE}:${CONTAINER_HOME}/.env \
    ${CRED_ARGS} \
    ${NET_ARGS} \
    ${MOUNT_ARGS} \
    ${IMAGE_URL} \
    ${CMDLINE}
