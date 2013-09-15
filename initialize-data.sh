
echo load product data 
curl -X POST -H "Content-Type:application/json" -d '{"name": "Product A", "inventory": 11, "UPC": "127890"}' http://localhost:3000/products;
curl -X POST -H "Content-Type:application/json" -d '{"name": "Product B", "inventory": 22, "UPC": "127891"}' http://localhost:3000/products;
curl -X POST -H "Content-Type:application/json" -d '{"name": "Product C", "inventory": 33, "UPC": "127892"}' http://localhost:3000/products;
curl -X POST -H "Content-Type:application/json" -d '{"name": "Product D", "inventory": 44, "UPC": "123893"}' http://localhost:3000/products;

echo car data
curl -X POST -H "Content-Type:application/json" -d '{"name":"Mustang", "milage": 22 }' http://localhost:3000/cars;
curl -X POST -H "Content-Type:application/json" -d '{"name":"VW", "milage": 33  }' http://localhost:3000/cars;
curl -X POST -H "Content-Type:application/json" -d '{"name":"FJ", "milage": 44  }' http://localhost:3000/cars;

echo store data
curl -X POST -H "Content-Type:application/json" -d '{"name":"Store 1", "geo": { "lat": 4, "lng": 20 } }' http://localhost:3000/stores;
curl -X POST -H "Content-Type:application/json" -d '{"name":"Store 2", "geo": { "lat": 5, "lng": 20 } }' http://localhost:3000/stores;
curl -X POST -H "Content-Type:application/json" -d '{"name":"Store 3", "geo": { "lat": 6, "lng": 20 } }' http://localhost:3000/stores;

echo automobile data
curl -X POST -H "Content-Type:application/json" -d '{"name": "Toyota"}' http://localhost:3000/automobiles;
curl -X POST -H "Content-Type:application/json" -d '{"name": "Honda" }' http://localhost:3000/automobiles;
curl -X POST -H "Content-Type:application/json" -d '{"name": "Old Truck" }' http://localhost:3000/automobiles;

echo load customer data
curl -X POST -H "Content-Type:application/json" -d '{"name": "Customer B", "zip": "127891"}' http://localhost:3000/customers;
curl -X POST -H "Content-Type:application/json" -d '{"name": "Customer C", "zip": "127892"}' http://localhost:3000/customers;

echo load ship data
curl -X POST -H "Content-Type:application/json" -d '{"name": "ShipA","geo": { "lat": 37.796996, "lng": -122.429281 } ,"SHIPTYPE": "cargo","FLAG": "US" }' http://localhost:3000/ships;
curl -X POST -H "Content-Type:application/json" -d '{"name": "ShipB","geo": { "lat": 37.766996, "lng": -122.409281 } ,"SHIPTYPE": "cargo","FLAG": "US" }' http://localhost:3000/ships;
curl -X POST -H "Content-Type:application/json" -d '{"name": "ShipC","geo": { "lat": 37.8000, "lng": -122.449281 } ,"SHIPTYPE": "cargo","FLAG": "US" }' http://localhost:3000/ships;

echo load sailboat data
curl -X POST -H "Content-Type:application/json" -d '{"designer": "Robert H. Perry","builder": "Valiant Yachts","loa": "39’ 11″ (12.16 m.)","lwl": " 34’ 0″ (10.36 m.)","beam": "12’ 4″ (3.76 m.)","draft": "6’ 0″ (1.83 m.)","ballast": "7,700 lbs. (3,493 kg.)","displacement": "22,500 lbs. (10,206 kg.)","sailarea": "772 sq. ft. (71.7 sq. m.)" }' http://localhost:3000/sailboats;
curl -X POST -H "Content-Type:application/json" -d '{"designer": "Robert H. Perry","builder": "Valiant Yachts","loa": "37′ 0″","lwl": "31′ 7″","beam": "11′ 5″","draft": "5′ 9″","ballast": " 6,600 lbs","displacement": "17,000 lbs","sailarea": "667 sqft" }' http://localhost:3000/sailboats;
curl -X POST -H "Content-Type:application/json" -d '{"designer": "Robert H. Perry","builder": "Valiant Yachts","loa": "37′ 0″","lwl": "31′ 7″","beam": "11′ 5″","draft": "5′ 9″","ballast": " 6,600 lbs","displacement": "17,000 lbs","sailarea": "667 sqft" }' http://localhost:3000/sailboats;
curl -X POST -H "Content-Type:application/json" -d '{"designer": "Robert H. Perry","builder": "Valiant Yachts","loa": "37′ 0″","lwl": "31′ 7″","beam": "11′ 5″","draft": "5′ 9″","ballast": " 6,600 lbs","displacement": "17,000 lbs","sailarea": "667 sqft" }' http://localhost:3000/sailboats;








