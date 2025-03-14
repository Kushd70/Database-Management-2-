// Creating a new database or use an existing db...
use('shop');

// collections 
use('shop');
db.createCollection('users'); // no fixed attributes (schema less)

// collection with flexible schema
use('shop');
db.createCOllection('categories', 
    {
        validators:{
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
