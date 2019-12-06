//删除数据
print('start del ...........' + (new Date().toString()))
var start = '2018-01-01';
var endt = '2019-08-01T23:59:59';
var nu = db.LogOperationDataEntity.find({
    "OptTime": {
        $gte: new Date(start),
        $lt: new Date(endt)
    }
}).count();
print('total:' + nu);

db.LogOperationDataEntity.deleteMany({
    "OptTime": {
        $gte: new Date(start),
        $lt: new Date(endt)
    }
});

print('end del .  ..........' + (new Date().toString()))


// https: //docs.mongodb.com/manual/reference/method/Date/index.html
// Returns a date either as a string or as a Date object.

// Date() returns the current date as a string in the mongo shell.
// new Date() returns the current date as a Date object.The mongo shell wraps the Date object with the ISODate helper.The ISODate is in UTC.
// You can specify a particular date by passing an ISO - 8601 date string with a year within the inclusive range 0 through 9999 to the new Date() constructor or the ISODate()
// function.These functions accept the following formats:

//     new Date("<YYYY-mm-dd>") returns the ISODate with the specified date.
// new Date("<YYYY-mm-ddTHH:MM:ss>") specifies the datetime in the client’ s local timezone and returns the ISODate with the specified datetime in UTC.
// new Date("<YYYY-mm-ddTHH:MM:ssZ>") specifies the datetime in UTC and returns the ISODate with the specified datetime in UTC.
// new Date( < integer > ) specifies the datetime as milliseconds since the Unix epoch(Jan 1, 1970), and returns the resulting ISODate instanc
