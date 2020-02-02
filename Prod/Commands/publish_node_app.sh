x="0"
if [ -z ${command+x} ]
then
    echo "Setting Command Directory"
    command=$(find ~ -name 'Commands' 2>/dev/null | grep 'Prod')
    export command=$command
    chmod a+x $command/*.sh
fi

cd "$command/../BaseNodeApp"
imaget=$(docker images | grep jarvis-node | sed -E 's/[ ]+/ /g' | cut -d' ' -f2 | sort -n | tail -1)
docker build -t sreedal/jarvis-node:$((imaget+1)) .
docker push sreedal/jarvis-node:$((imaget+1)) 
cd -