"# Jarvis" 

-----------------------------------------------------
Setup for generic ML Pipeline Building and Deployment
-----------------------------------------------------

Notes & Features Planned: available at https://onedrive.live.com/edit.aspx/Documents/Sreedal^4s%20Notebook?cid=d278259c09830e1b&id=documents&wd=target%28Home%2FHobbyProjects%2FML%20Pipeline.one%7C203C2AB7-5ED3-C044-BCE4-F6ED438DE52F%2F%29
onenote:https://d.docs.live.net/d278259c09830e1b/Documents/Sreedal's%20Notebook/Home/HobbyProjects/ML%20Pipeline.one#section-id={203C2AB7-5ED3-C044-BCE4-F6ED438DE52F}&end


-----------------------------------------------------
New User Onboarding
-----------------------------------------------------

1. git clone https://github.com/sreedal/Jarvis
2. install visual studio code from https://code.visualstudio.com/ 
3. install docker desktop from https://docs.docker.com/docker-for-mac/install/ 
4. install azure cli from https://docs.microsoft.com/en-us/cli/azure/install-azure-cli?view=azure-cli-latest 
5. az login # Login to the right azure subscription
6. az aks list 
7. install kubectl (https://docs.microsoft.com/en-us/azure/aks/tutorial-kubernetes-deploy-cluster) [ az aks install-cli ; az aks get-credentials --resource-group myResourceGroup --name myAKSCluster ; kubectl get nodes ]
8. ./Prod/Commands/start_all_services.sh
9.  Browse the link in the output tagged as "Prod Jarvis Node" / "Local Jarvis Node"
