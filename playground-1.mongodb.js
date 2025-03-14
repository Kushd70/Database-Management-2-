// Creating a new database or use an existing db...
use('shop');

// collections 
use('shop');
db.createCollection('users'); // no fixed attributes (schema less)

// collection with flexible schema
use('shop');
db.createCollection('categories', 
    {
        validator:{
            $jsonSchema:{
                bsonType:"object",
                required:['code', 'name'],
                properties:{
                    code:{
                        bsonType:'string',
                        description:'code is required',
                    },
                    name:{
                        bsonType:'string',
                        description:'name is required',
                    }
                }
            }
        }}
);

// Insert data
// Inserting only one document
let user = {
    "name":"Jhohn Doe",
    "email": "jhone@gmail.com",
    "city":"kandy",
    "type":"admin"
};
use('shop');
db.getCollection('users').insertOne(user);

// Inserting multiple documents at once
let user_list=[
    {"name":"Sam Silva", "city":"Colombo","type": "customer", "phone":"077777"},
    {"name":"Angelo", "city":"Kandy", "type":"customer", "age":33},
    {"name":"Ben", "city":"Kegalle"}
];
use('shop');
db.getCollection('users').insertMany(user_list);


// Selecting all the data from a collection
use('shop');
db.getCollection('users').find();// returns an array of json objects

// Selecting only a specific set of attributes
// display name and city of all the users
use('shop');
db.getCollection('users').find({}, {"name": 1, "city": 1}); // projection using fields


// selecting data based on a specific value for a field
// display details of all the user from kandy
use('shop');
db.getCollection('users').find({"city": "Kandy"}); // Equality condition