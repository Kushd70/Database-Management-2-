/*
	- Collection
		• Items
			§ Required Attributes: name , String type
			§ Price : numerical, should be more than 0.00
			§ Stock : numerical , should not be less than 0.00 should be less than 1000
		
	- Optional Attributes:
		• Category
			§ Validations : will include a json with attributes size , colour, height and width
			§ Supplier : will include a json array consisting objects with attirbutes supplier name an contact
		
		
	1. Insert at least 5 documents to items collection using your own data.
	2. Select all the documents in the collection
	3. Select item name and price of items with their stocks reached to 0
	4. Select items with their price over 1000 and stock over 100
	5. Select items with supplier name as 'Abc Company'
	6. Select items with their category set to electronics or stock reached to 5
	7. Select average price of an item
Select maximum stock from the collection

*/
use("Ecommerce");


// create a database 
use('supermarket');

// collections
use('supermarket');
db.createCollection('items',
    {
        validator:{
            $jsonSchema:{
                bsonType:"object",
                required : ["name", "price" , "stock"],
                properties: {
                    name :{
                        bsonType: "string",
                        description: "Name is required"
                    },
                    price: {
                        bsonType: "number",
                        description: "price is required",
                        minimum: 0.00
                    },
                    stock:{
                        bsonType:"number",
                        description: "stock is required",
                        minimum: 0.00,
                        maximum: 1000
                    }
                }
            }
        }
    }
); 

let item_list = [
    {"name" : "ABC", "price" : 100.00, "stock" : 30, "supplier": [
            {"sup_name" : "Abc Company", "contact": "08888888"},
            {"sup_name": "Werty Suppliers", "contact": "09888888"}
        ]
    },
    {"name": "BCD", "price" : 1200.00, "stock":10, "category": "Electronics"},
    {"name": "CDE", "price" : 1250.00, "stock":20, "category": "Misc", 
        "variation" : {"size": "L", "colour" : "black"}
    }  
];
use('supermarket');
db.getCollection('items').insertMany(item_list);

// 2. Select all the documents in the collections
use('supermarket');
db.getCollection('items').find();

// 3. select item name and price of items with their stocks reached to 0
use('supermarket');
db.getCollection('items').find({"stock": 0.00}, {name: 1, price: 1}); // qutations withbbath kamak na nathath kamak na


// 4. select items with their prices over 1000 and stock over 100
use('supermarket');
db.getCollection('items').find({$and : [{price :{$gt : 1000}, stock : {$gt : 0}}]});


// 5. Select items with supplier name as "Abc company".......
use('supermarket');
db.getCollection('items').find({"suppliers.sup_name" : "Abc Company"}); // since supplier is a main attribute we need to add " " there 

// 6. Select items with their category set to electronics or stock reached to 5
use('supermarket');
db.getCollection('items').find({$or: [{"category" : "Electronics"}, {"stock" : 5}]});




/* Aggregate functions..
db.<collection>.aggregate([<aggregate functions>]);
{$group:{_id:<grouping attributes>, <aggregate attribute>: <aggregate operator>}}

*/
use('supermarket');
db.getCollection('items').aggregate([
    {
        $group: {
            _id:null,
            averagePrice: {$avg: "$price"}
        }
    }
]);

// 8. select maximum stock from the collection....
use('supermarket');
db.getCollection('items').aggregate([
    {
        $group:{
            _id:null,
            maximumStock: {$max : "$stock"} 
        }
    }
]);

// 9. select maximum stock for each category....
use('supermarket');
db.getCollection('items').aggregate([
    {
        $group:{
            _id:"$category",
            maxStockCategory: {$max : "$stock"}
        }
    }
]);