#Disclaimer
# make sure you have all the required resource providers enabled in your subscription
# this demo code is just provided as a sample and should not be used in production

$PRIMARY_RESOURCE_GROUP="sqlprimary"
$SECONDARY_RESOURCE_GROUP="sqlsecondary"
$PRIMARY_LOCATION="swedencentral"
$SECONDARY_LOCATION="francecentral"
$PRIMARY_NSG="sqlprimary-nsg"
$SECONDARY_NSG="sqlsecondary-nsg"
$PRIMARY_VNET_NAME="sqlprimary-vnet"
$SECONDARY_VNET_NAME="sqlsecondary-vnet"
$PRIMARY_PIP="sqlprimary-pip"
#Use this VM to access SQL over private endpoint. Just connect to it using its public IP. In the real-world
#the VM would not be public but rather sit behind a bastion or a firewall.
$VM_NAME="clientvm"
$IMAGE="Win2022Datacenter"
$SIZE="Standard_DS1_v2"
$ADMIN_USERNAME="azureuser"

az group create `
  --name $RESOURCE_GROUP `
  --location $LOCATION
az group create `
  --name $TARGET_RESOURCE_GROUP `
  --location $TARGET_LOCATION

az network vnet create `
  --resource-group $PRIMARY_RESOURCE_GROUP `
  --name $PRIMARY_VNET_NAME `
  --location $PRIMARY_LOCATION `
  --address-prefix 10.0.0.0/26 `
  --subnet-name default `
  --subnet-prefix 10.0.0.0/28

az network vnet create `
  --resource-group $SECONDARY_RESOURCE_GROUP `
  --name $SECONDARY_VNET_NAME `
  --location $SECONDARY_LOCATION `
  --address-prefix 10.10.0.0/26 `
  --subnet-name default `
  --subnet-prefix 10.10.0.0/28

az network nsg create `
  --resource-group $PRIMARY_RESOURCE_GROUP `
  --name $PRIMARY_NSG `
  --location $PRIMARY_LOCATION

# Allowing RDP inbound
az network nsg rule create `
  --resource-group $PRIMARY_RESOURCE_GROUP `
  --nsg-name $PRIMARY_NSG `
  --name Allow-RDP `
  --protocol Tcp `
  --direction Inbound `
  --priority 100 `
  --source-address-prefixes '*' `
  --source-port-ranges '*' `
  --destination-address-prefixes '*' `
  --destination-port-ranges 3389 `
  --access Allow

az network vnet subnet update `
  --resource-group $PRIMARY_RESOURCE_GROUP `
  --vnet-name $PRIMARY_VNET_NAME `
  --name default `
  --network-security-group $PRIMARY_NSG

az network nsg create `
  --resource-group $SECONDARY_RESOURCE_GROUP `
  --name $SECONDARY_NSG `
  --location $SECONDARY_LOCATION


az network nsg rule create `
  --resource-group $TARGET_RESOURCE_GROUP `
  --nsg-name $TARGET_NSG `
  --name Allow-RDP `
  --protocol Tcp `
  --direction Inbound `
  --priority 100 `
  --source-address-prefixes '*' `
  --source-port-ranges '*' `
  --destination-address-prefixes '*' `
  --destination-port-ranges 3389 `
  --access Allow

  az network nsg rule create `
  --resource-group $TARGET_RESOURCE_GROUP `
  --nsg-name $TARGET_NSG `
  --name Allow-HTTP `
  --protocol Tcp `
  --direction Inbound `
  --priority 110 `
  --source-address-prefixes '*' `
  --source-port-ranges '*' `
  --destination-address-prefixes '*' `
  --destination-port-ranges 80 `
  --access Allow

az network vnet subnet update `
  --resource-group $TARGET_RESOURCE_GROUP `
  --vnet-name $TARGET_VNET_NAME `
  --name default `
  --network-security-group $TARGET_NSG


az network public-ip create `
  --name $PIP `
  --resource-group $RESOURCE_GROUP

az network nic create `
  --name asr-nic `
  --resource-group $RESOURCE_GROUP `
  --vnet-name $VNET_NAME `
  --subnet default `
  --public-ip-address $PIP

az network public-ip create `
  --name $TARGET_PIP `
  --resource-group $TARGET_RESOURCE_GROUP

az vm create `
  --resource-group $RESOURCE_GROUP `
  --name $VM_NAME `
  --image $IMAGE `
  --size $SIZE `
  --nics asr-nic `
  --admin-username $ADMIN_USERNAME `
  --authentication-type password `
  --admin-password "YourSecurePassword123!"

az vm extension set `
  --resource-group $RESOURCE_GROUP `
  --vm-name $VM_NAME `
  --name CustomScriptExtension `
  --publisher Microsoft.Compute `
  --settings '{"commandToExecute": "powershell Add-WindowsFeature Web-Server"}'

# here starts the replication part

az backup vault create `
  --name $VAULT `
  --resource-group $TARGET_RESOURCE_GROUP `
  --location $TARGET_LOCATION

