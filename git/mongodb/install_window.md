## install
https://fastdl.mongodb.org/win32/mongodb-win32-x86_64-2008plus-3.2.22-signed.msi
mkdir C:\MongoDB\Server\3.4\data\db
mkdir C:\MongoDB\Server\3.4\data\logs
rem  service install
mongod --bind_ip 0.0.0.0 --logpath C:\MongoDB\Server\3.4\data\logs\mongo.log --logappend --dbpath C:\MongoDB\Server\3.4\data\db --port 27017 --serviceName "MongoDB" --serviceDisplayName "MongoDB" --storageEngine=mmapv1--install


rem console 
mongod --bind_ip 0.0.0.0 --logpath C:\MongoDB\Server\3.4\data\logs\mongo.log --logappend --dbpath C:\MongoDB\Server\3.4\data\db --port 27017 --storageEngine=mmapv1