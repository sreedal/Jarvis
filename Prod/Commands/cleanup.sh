x="0"
if [ -z ${command+x} ]
then
    echo "Setting Command Directory"
    command=$(find ~ -name 'Commands' 2>/dev/null | grep 'Prod')
    export command=$command
    chmod a+x $command/*.sh
fi

# Local
docker stop $(docker ps -a -q)
docker rm $(docker ps -a -q)


# Remote
cd "$command/../ServicesAKS"
kubectl delete -f kafka-infra.yml
kubectl delete -f python-processing-and-redis.yml
kubectl delete -f web-server.yml