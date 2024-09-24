# Social Network - System Design
System Design project for [System Design course](https://balun.courses/courses/system_design)


### Functional requirements:
- post publishing from traveling with photos, small description and location
- post reactions and commenting
- subscribing and notifications
- sight search and posts bind to them
- feed with other traveler posts

### Estimates:
- DAU: 10^7 unique users
- Linear users grow
- CIS geo region


### Non-functional requirements:
- Reliability
- Usability (out of this system design scope)
- Availability
- Scalability


### Calculations:
1. Posts publishing:
   - assumptions:
     - average post publishing count per day: 1
     - average 2 photo per post
   - request size (~2 KB metadata + ~1.5 MB media/images):
     - ~~userId: 16 B (uuid)~~ comes with auth
     - text: 2 KB (~1000 chars)
     - location: 48 B ([PostGIS Geometry/Geography](https://stackoverflow.com/questions/30455025/size-of-data-type-geographypoint-4326-in-postgis))
     - photo: 2 * 750 KB = 1.5 MB (blob storage)
   - api/traffic:
     - RPS: 10^7 * 1 / 86400 ~ 116
     - Peak RPS (100/1 ratio): 116 * 100 = 11 600  
     - write traffic: 11600 * 1.5 MB = 17.4 GB/s
     - peak write traffic: 1.74 TB/s
2. Reactions:
   - assumptions:
     - average post reactions per user per day: 10
   - request size ~ 100 B:
     - ~~userId: 16 B~~ comes with auth
     - postId: 16 B
     - reaction: 8 B 
   - api/traffic:
     - RPS: 10e7 * 10 / 86400 ~ 1 157
     - peak RPS: 1157 * 100 = 115 700
     - write traffic: 115700 * 100 B ~ 11.57 MB/s
     - peak write traffic: ~ 1.157 GB/s
3. Comments:
   - assumptions:
     - average comments write count per user per day: 5
     - average comments reading count per user per day: 10
     - average comments batch size per read: 15
     - average photo per comment: 1
   - request size:
     - write ~ 1 MB:
       - text: 1 KB (~500 chars)
       - postId: 8 B (uuid)
       - photo: 1 * 750 KB = 0.75 MB (blob storage)
     - read per comment ~ 1 MB:
       - text: 1 KB
       - userId: 8 B
       - commentId: 8 B
       - createdAt: 8 B
       - photos: 0.75 MB
   - api/traffic:
     - write:
       - RPS: 1e7 * 5 / 86400 = 579
       - peak RPS: 57 970
       - traffic: 579 * 1 MB ~ 579 MB/s
       - peak traffic: 57.9 GB/s
     - read:
       - RPS: 1e7 * 10 / 86400 = 1 157
       - peak RPS: 1157 * 100 = 115 700
       - traffic: 1157 * 1 MB * 15 = 17.355 GB/s
       - peak traffic: 17.355 GB/s * 100 ~ 1.7355 TB/s
4. Feed
    - assumptions:
      - average feed reads count per day: 10
      - average posts in feed per read: 15
    - request size per post (~2 KB metadata + ~1.5 MB media/photo):
      - userId: 8 B
      - postId: 8 B
      - text: 2 KB
      - location: 48 B
      - createdAt: 8 B
      - photos: 2 * 0.75 MB ~ 1.5 MB
    - api/traffic:
       - RPS: 1e7 * 10 / 86400 = 1 157
       - peak RPS: 1157 * 100 = 115 700
       - traffic: 1157 * 1.5 MB * 15 = 26.041 GB/s
       - peak traffic: 26.041 GB/s * 100 ~ 2.6041 TB/s