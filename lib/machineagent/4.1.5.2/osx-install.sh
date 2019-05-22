#!/usr/bin/env bash
#
# Copyright (c) AppDynamics, Inc., and its affiliates, 2014, 2015
# All Rights Reserved
# THIS IS UNPUBLISHED PROPRIETARY CODE OF APPDYNAMICS, INC.
# The copyright notice above does not evidence any
# actual or intended publication of such source code.
#
# Installs the unpackaged machine agent and schedules it to run
# as a service. Moves the contents to the specified location
#

usage() {
    echo "Usage: $0 [-h] [-f] [-Dprop=value]* [-Xprop=value]*"
    echo "Installs the machine agent."
    echo "    -f               Overwrite existing directory"
    echo "    -h               Prints this help message"
    echo "    -D prop          set JAVA system property"
    echo "    -X prop          set non-standard JAVA system property"
}

installService() {
    force=$1

    # Update the plist to point to the install directory and use any
    # properties passed in from command line.

    <"$MACHINE_AGENT_HOME/com.appdynamics.machineagent.plist.template" awk \
    -v MACHINE_AGENT_HOME="$MACHINE_AGENT_HOME" -v STD_JAVA_PROPS="$STD_JAVA_PROPS" -v NON_STD_JAVA_PROPS="$NON_STD_JAVA_PROPS" '
    {gsub(/\${MACHINE_AGENT_HOME}/, MACHINE_AGENT_HOME);
    gsub(/\${STD_JAVA_PROPS}/, STD_JAVA_PROPS);
    gsub(/\${NON_STD_JAVA_PROPS}/, NON_STD_JAVA_PROPS);
    print}
    ' > "$MACHINE_AGENT_HOME/com.appdynamics.machineagent.plist"

    # Install the service
    launchctl load -w $MACHINE_AGENT_HOME/com.appdynamics.machineagent.plist

    echo "The appdynamics machine agent has been installed in $MACHINE_AGENT_HOME"
}

MACHINE_AGENT_HOME=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
STD_JAVA_PROPS=""
NON_STD_JAVA_PROPS=""

# Parse any long getopt options and put them into properties before calling getopt below
# Be dash compatible to make sure running under ubuntu works
ARGV=""
while [ $# -gt 0 ]
do
    case $1 in
      --help) ARGV="$ARGV -h"; shift;;
      --*=*) properties="$properties -D${1#--}"
           shift 1
           ;;
      --*) [ $# -le 1 ] && {
                echo "Option requires an argument: '$1'."
                shift
                continue
            }
           properties="$properties -D${1#--}=$2"
           shift 2
           ;;
      *) ARGV="$ARGV $1" ; shift
    esac
done

# Parse any command line options.
args=`getopt fhD:X: $ARGV`
eval set -- "$args"

while true; do
    case $1 in
        -f)
            force=0
            shift 1
        ;;
        -h)
            usage
            exit 0
        ;;
        -D)
            STD_JAVA_PROPS="$STD_JAVA_PROPS -D$2"
            shift 2
        ;;
        -X)
            NON_STD_JAVA_PROPS="NON_STD_JAVA_PROPS -X$2"
            shift 2
        ;;
        --)
            shift
            break
        ;;
        *)
            echo "Error parsing argument $1!" >&2
            usage
            exit 1
        ;;
    esac
done

installService "$force"

exit $?
