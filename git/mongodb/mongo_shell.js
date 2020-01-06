// ./mongo localhost:27017 ./a.js
// https://docs.mongodb.com/manual/tutorial/write-scripts-for-the-mongo-shell/
// show dbs, show databases	
// db.adminCommand('listDatabases')
// use <db>
// db = db.getSiblingDB('<db>')
// show collections
// db.getCollectionNames()
// show users
// db.getUsers()
// show roles
// db.getRoles({showBuiltinRoles: true})
// show log <logname>
// db.adminCommand({ 'getLog' : '<logname>' })
// show logs
// db.adminCommand({ 'getLog' : '*' })
// it
// cursor = db.collection.find()
// if ( cursor.hasNext() ){
   // cursor.next();
// }

// mongo test --eval "printjson(db.getCollectionNames())"

// db = connect("localhost:27020/myDatabase");




// JavaScript Database Administration Methods	Description
// db.fromColl.renameCollection(<toColl>)	Rename collection from fromColl to <toColl>. See Naming Restrictions.
// db.getCollectionNames()	Get the list of all collections in the current database.
// db.dropDatabase()	Drops the current database.

db = db.getSiblingDB('local')
t=db.getCollectionNames();

printjson(t);
for(var i=0;i<t.length;i++){
print(t[i]);
}
