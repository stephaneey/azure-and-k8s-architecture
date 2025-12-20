# Availabilty Samples

This demo console app makes the simplest use of SQL server. No Entity Framework or NHibernate, just raw SQL objects. The sample app connects to the endpoint passed as an argument such as, the failover group read-write or read-only listener. It then runs in a loop and executes one DML and one query for each iteration, and catches any exception.

You can run the sample app like this: ./sqlfailover.exe <failovergroup or sql server endpoint> <database>
The user name and password are hard-coded into the code and match the credentials provided by the terraform code.