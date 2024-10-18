# Distributed storage design

All data is distributed across several databases for responsibility segregation and independent scalability of the microservices:
1. Posts DB, _MongoDB_, key based sharding by _user_id_, async replication 
2. Comments DB, _MongoDB_, key based sharding by _post_id_, async replication 
3. Post Reactions DB, _MongoDB_, key based sharding by _post_id_, async replication 
4. Comment reactions DB, _MongoDB_, key based sharding by _post_id_, async replication 
5. Locations DB, _PostgreSQL_, no sharding, async replication 
6. Users DB, _MongoDB_, key based sharding by user _id_, async replication 
7. Subscriptions DB, _MongoDB_, key based sharding by _following_user_id_, async replication 

All DBs except locations db are document-oriented _MongoDB_ that is good for scaling since that's the biggest challenge for this system. 
Locations DB on PostgreSQL with PostGIS extension is because of geospatial data.  

### Async replication
it's a tradeoff for satisfying nonfunctional requirement of eventual consistency for the system and minimizing the latency.
- 1 master + 2 or 1 (async) slave depending on schema
- automatic leader election in MongoDB: https://www.mongodb.com/docs/manual/core/replica-set-elections/

### Tiered storage:
- Hot data on SSD NVMe disks for the most recent and popular data and significant traffic load
- Warm data on SSD SATA disks for with less expensive costs and decent params, from low to middle traffic load
- Cold data on HDD disks for old data and mostly irrelevant but kept for historical purposes, minor traffic load

Mostly the data will be stored in object storage rather than SQL/NoSQL DB:
- Object storage: 19.2 PB, 99.75%
- SQL/NoSQL DBs: 49 TB, 0.25%
