# Checks the status of the Kube Services & Pods

if [ "$#" -gt "0" ]
then
    if [ "$1" = "pods" ]
    then
        kubectl get pods
    else
        kubectl get services
    fi
else
    kubectl get pods
    kubectl get services
fi