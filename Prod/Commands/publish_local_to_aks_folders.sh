x="0"
if [ -z ${command+x} ]
then
    echo "Setting Command Directory"
    command=$(find ~ -name 'Commands' 2>/dev/null | grep 'Prod')
    export command=$command
    chmod a+x $command/*.sh
fi

cd "$command/../"
cp -f ServicesDocker/DevEnv/* ServicesAKS/DevEnv/
cp -f ServicesDocker/Spark/* ServicesAKS/Spark/
