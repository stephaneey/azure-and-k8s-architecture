# Availabilty Samples

This sample code deploys:

- Two webapps, one in Belgium Central and one in France Central
- One Cosmos DB account with multi-region writes  
- It pushes the application code (zip file) to both web apps

To run this:

- Make sure to have enough permission, ideally subscription owner
- Clone this on your machine or Open an Azure Cloud Shell and clone it from there
- make sure to cd into the current folder
- run: terraform init
- run: terraform apply --auto-approve

Once deployed, you should end up with the following resources (names vary):

![alt text](resources.png)

To test the API, you can use Postman or Fiddler by first performing a POST request, to create a document:

![alt text](post.png)

The API operation will create a document and return which regional Cosmos DB region was used.

Same for a GET request:

![alt text](get.png)

Now, you can start playing with Cosmos to see how both APIs react. Here are the following things you can test using the Azure Portal:

- Marking one of the Cosmos regions read only. In such a case, both APIs (Belgium and France) should automatically go to the remaining writable region, but reads (GET queries) would still pick their regional instance.
- Deleting one of the Cosmos regions. In such a case, both APIs should automatically go to the remaining region for both reads and writes
- Offline a Cosmos region. In such a case, an automatic failover should take place to the remaining region. Note that you must create a support ticket to get it back online. Just try this one after having tried the other changes.

Make sure to run both POST and GET request between each steps and check which Cosmos backend instance is used by the API. You'll notice that whatever you do at Cosmos level, the backend is smart enough to keep working.

PS C:\Users\steph> az cosmosdb sql role assignment create --account-name cosmos-ai7i1b --resource-group cosmos-rg2 --role-assignment-id cb8ed2d7-2371-4e3c-bd31-6cc1560e84f8 --role-definition-id /subscriptions/f63a908a-c054-4d45-a1fd-1eadaee67ffc/resourceGroups/cosmos-rg2/providers/Microsoft.DocumentDB/databaseAccounts/cosmos-ai7i1b/sqlRoleDefinitions/00000000-0000-0000-0000-000000000002 --principal-id 0698461f-4c4c-4453-be00-b56565e4081b --scope "/subscriptions/f63a908a-c054-4d45-a1fd-1eadaee67ffc/resourceGroups/cosmos-rg2/providers/Microsoft.DocumentDB/databaseAccounts/cosmos-ai7i1b"