x="0"
if [ -z ${command+x} ]
then
    echo "Setting Command Directory"
    command=$(find ~ -name 'Commands' 2>/dev/null | grep 'Prod')
    export command=$command
    chmod a+x $command/*.sh
fi

"$command/publish_local_to_aks_folders.sh"
"$command/publish_node_app.sh"
"$command/start_all_services.sh" remote restart