# Disaster recovery with Azure SQL - focusing only on RTO not RPO
The purpose of this section is to highlight how to minimize downtime using Azure SQL. You can deploy the provided example that makes use of failover groups and a sample demo console application to test it. 

# Active geo replication
![Geo-Replication](./images/geo-replication.png)

# Failover Groups
![Failover-Groups-Before](./images/fg-before.png)
![Failover-Groups-After](./images/fg-after.png)

# Attention Points

- Geo replication allows you to configure per-database geo replicas while failover groups regroup one or more databases that failover together
- Geo replication failover is manual while failover group support both manual and automatic modes
- Geo replication doesn't abstract the primary and secondary servers while failover groups provide listener endpoints that always target primary and secondary servers. In case of failover, the clients do not need to be failover-aware nor to update connection strings.