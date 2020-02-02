# ------------------------------------------
# Usage login_to_service.sh servicename
# ------------------------------------------
x="0"
if [ -z ${command+x} ]
then
    echo "Setting Command Directory"
    command=$(find ~ -name 'Commands' 2>/dev/null | grep 'Prod')
    export command=$command
    chmod a+x $command/*.sh
fi

if [ "$#" -gt "0" ]
then
    podname=$("$command/check_service_state.sh" pods | grep $1 | cut -d' ' -f1)
    echo $podname
    kubectl exec -it $podname /bin/bash
else
    echo "Usage: login_to_service.sh servicename"
fi