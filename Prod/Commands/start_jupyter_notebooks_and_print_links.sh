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

sparkpod=$("$command/check_service_state.sh" pods | grep "spark" | cut -d' ' -f1)
devenvpod=$("$command/check_service_state.sh" pods | grep "devenv" | cut -d' ' -f1)

if [ -z ${sparkpod+x} ]
then
    echo "Spark Pod is not running - Consider restarting the pod and run again"
else
    notebooks=$(kubectl exec $sparkpod jupyter notebook list)
    if [ ${#notebooks} -lt "30" ]
    then
        nohup kubectl exec $sparkpod jupyter notebook &
        sleep 30
        notebooks=$(kubectl exec $sparkpod jupyter notebook list)
    fi
    #echo $notebooks
    sparkservice=$("$command/check_service_state.sh" services | grep "spark" | sed -E 's/[^a-zA-Z0-9.]+/ /g' | cut -d' ' -f4,5 | sed -e 's/ /:/g')
    echo ${notebooks/0.0.0.0:8888/$sparkservice}
fi

if [ -z ${devenvpod+x} ]
then
    echo "Devenv Pod is not running - Consider restarting the pod and run again"
else
    notebooks=$(kubectl exec $devenvpod jupyter notebook list)
    if [ ${#notebooks} -lt "30" ]
    then
        nohup kubectl exec $devenvpod jupyter notebook &
        sleep 30
        notebooks=$(kubectl exec $devenvpod jupyter notebook list)
    fi
    #echo $notebooks
    devenvservice=$("$command/check_service_state.sh" services | grep "devenv" | sed -E 's/[^a-zA-Z0-9.]+/ /g' | cut -d' ' -f4,5 | sed -e 's/ /:/g')
    echo ${notebooks/0.0.0.0:8888/$devenvservice}
fi