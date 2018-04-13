#!/bin/bash
# For more details, see https://hub.docker.com/r/kochanpivotal/gpdb5oss/
set -e
[[ ${DEBUG} == true ]] && set -x

#set -x

# Including configurations
. config.sh
################################################################################
function RunMinio()
{
  #echo "[RunMinio] Command:  $1"
  COMMAND=$1

  if [[ -z "${COMMAND}" ]]; then
    echo "Missing command"
    exit -1;
  else
    if [[ "${COMMAND}" == "up" ]]; then
        $DC_MINIO_SCRIPT up
    elif [[ "${COMMAND}" == "down" ]]; then
         $DC_MINIO_SCRIPT down
    else # default option
        $DC_MINIO_SCRIPT up
    fi
  fi
}
################################################################################
function printHelp()
{
    me=$(basename "$0")
    echo "Usage: $me "
    echo "   " >&2
    echo "Options:   " >&2
    echo "-h help  " >&2
    echo "-t Type. For example $ $me -t minio  " >&2
    echo "-c command. For example $me -t minio -c up  or $me -t minio  -c down  " >&2
    echo ""
    echo "For example  " >&2
    echo "$ ./$(basename "$0") -t minio -c up " >&2
}
################################################################################
while getopts ":hc:t:" opt; do
  case $opt in
    t)
      #echo "Type Parameter: $OPTARG" >&2
      export TYPE=$OPTARG
      ;;
    c)
      #echo "Command Parameter: $OPTARG" >&2
      export COMMAND=$OPTARG
      ;;
    h)printHelp
      exit 0;
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      printHelp
      exit 1
      ;;
    :)
      echo "Option -$OPTARG requires an argument." >&2
      printHelp
      exit 1
      ;;
  esac
done

if [[ -z "${TYPE}" ]]; then
  echo "Invalid Type"
  printHelp
  exit 1
else
  if [[ "${TYPE}" == "New Command" ]]; then
      echo "${COMMAND}"
  elif [[ "${TYPE}" == "minio" ]]; then
      RunMinio  "${COMMAND}"
  else # default option
       echo "test"
  fi
fi
################################################################################
