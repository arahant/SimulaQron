#!/usr/bin/env sh
ps aux | grep python | grep Test | awk {'print $2'} | xargs kill -9
ps aux | grep python | grep setup | awk {'print $2'} | xargs kill -9
ps aux | grep python | grep start | awk {'print $2'} | xargs kill -9

# if no arguments were given we take the list of current Nodes
if [ "$#" -eq 0 ] ;
then
    # check if the file with current nodes exist. Otherwise use Alice - Eve
    if [ -f "$NETSIM/config/Nodes.cfg" ]
    then
        python "$NETSIM/run/log/startCQCLog.py"
    else
        python "$NETSIM/configFiles.py" --nd "Alice Bob Charlie David Eve"

        # We call this script again, without arguments, to use the newly created config-files
        sh "$NETSIM/run/startAll.sh"
    fi
else  # if arguments were given, create the new nodes and start them
    while [ "$#" -gt 0 ]; do
        key="$1"
        case $key in
            -nn|--nrnodes)
            NRNODES="$2"
            shift
            shift
            ;;
            -tp|--topology)
            TOPOLOGY="$2"
            shift
            shift
            ;;
            -nd|--nodes)
            NODES="$2"
            shift
            shift
            ;;
            *)
            echo "Unknown argument ${key}"
            exit 1
        esac
    done

    python "$NETSIM/configFiles.py" --nrnodes "${NRNODES}" --topology "${TOPOLOGY}" --nodes "${NODES}"

    # We call this script again, without arguments, to use the newly created config-files
    sh "$NETSIM/run/startAllLog.sh"
fi