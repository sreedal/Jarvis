x="0"
if [ -z ${command+x} ]
then
    echo "Setting Command Directory"
    command=$(find ~ -name 'Commands' 2>/dev/null | grep 'Prod')
    export command=$command
    chmod a+x $command/*.sh
fi