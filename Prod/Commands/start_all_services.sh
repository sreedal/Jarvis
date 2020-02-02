# ------------------------------------------
# Usage start_all_services.sh [remote|local] [restart|stop]
# ------------------------------------------

x="0"
if [ -z ${command+x} ]
then
    echo "Setting Command Directory"
    command=$(find ~ -name 'Commands' 2>/dev/null | grep 'Prod')
    export command=$command
    chmod a+x $command/*.sh
fi

x="0"
if [ "$#" -gt "1" ]
then
    # Both Destination and Restart Options have been specified
    restart=$2
    destination=$1
else if [ "$#" -gt "0" ]
    then
        destination=$1
    fi
fi

if [ -z ${destination+x} ] || [ "$destination" = "local" ]
then
    # Local
    t=$(docker container list | wc -l)
    if [ $t -lt "2" ]
    then
        echo "Local services not running - starting them"
        cd "$command/../ServicesDocker"
        docker-compose up 1>DockerLogs.txt 2>DockerErrors.txt &
    else
        if [ -z ${restart+x} ]
        then
            echo "Stopping local services"
            cd "$command/../ServicesDocker"
            docker-compose down

            if [ "$restart" = "restart" ]
            then
                echo "Restarting Docker Services"
                docker-compose up 1>DockerLogs.txt 2>DockerErrors.txt &
            fi
        else
            echo "Docker containers are already up and running - not restarting"
        fi
    fi
fi

if [ -z ${destination+x} ] || [ "$destination" = "remote" ]
then
    # Remote Services
    cd "$command/../ServicesAKS/"

    t=$("$command/check_service_state.sh" service | grep "zk-cs" | wc -l)
    if [ $t -lt "1" ]
    then
        kubectl apply -f kafka-infra.yml
        sleep 100
    else
        if [ -z ${restart+x} ]
        then
            echo "Stopping Remote Zookeeper services"
            cd "$command/../ServicesAKS"
            kubectl delete -f kafka-infra.yml
            if [ "$restart" = "restart" ]
            then
                echo "Restarting Remote Zookeeper services"
                kubectl apply -f kafka-infra.yml
                sleep 100
            fi
        else
            echo "Kafka services are already running - not restarting"
        fi
    fi

    t=$("$command/check_service_state.sh" service | grep "redis-store" | wc -l)
    if [ "$t" -lt "1" ]
    then
        kubectl apply -f python-processing-and-redis.yml
        sleep 100
    else
        if [ -z ${restart+x} ]
        then
            echo "Stopping Remote Processing services"
            cd "$command/../ServicesAKS"
            kubectl delete -f python-processing-and-redis.yml
            if [ "$restart" = "restart" ]
            then
                echo "Restarting Remote Processing services"
                kubectl apply -f python-processing-and-redis.yml
                sleep 100
            fi
        else
            echo "Processing & Key-Value services are already running - not restarting"
        fi
    fi

    t=$("$command/check_service_state.sh" service | grep "jarvis-node" | wc -l)
    if [ "$t" -lt "1" ]
    then
        kubectl apply -f web-server.yml
        sleep 100
    else
        if [ -z ${restart+x} ]
        then
            echo "Stopping Remote WebServer services"
            cd "$command/../ServicesAKS"
            kubectl delete -f web-server.yml
            if [ "$restart" = "restart" ]
            then
                echo "Restarting Remote WebServer services"
                kubectl apply -f web-server.yml
                sleep 100
            fi
        else
            echo "WebServer services are already running - not restarting"
        fi
    fi
fi