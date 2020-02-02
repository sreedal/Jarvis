# ------------------------------------------
# Usage archive_data_folders.sh [remotealso]
# ------------------------------------------

# Local Folders
jarvis=$(find ~ -name 'Jarvis' 2>/dev/null)
for f in `echo $jarvis`; do
    for i in `ls $jarvis/../ | grep ".csv$"`; do
        cd $jarvis
        cd ..
        cd $i
        cat *.csv >> ArchivedData.tsv
        rm -rf *.csv
        rm -rf .part*
    done
done

# Remote Folders
if [ "$#" -gt "0" ]
then
    echo "Archiving in Remote Also"
    pod=$(kubectl get pods | grep spark | cut -d' ' -f1)
    kubectl exec $pod "/bin/bash /home/joyvan/work/Jarvis/Prod/Commands/archive_data_folders.sh"
fi