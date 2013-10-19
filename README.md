
#iOS examples showing how to connect mobile native iOS UI controls to LoopBack services



##Getting Started

1. Install and configure the StrongLoop Suite on your dev environment.  more information on installing LoopBack can be found in the [ StrongLoop Products ](http://strongloop.com/products

2. Download or clone this repo to your local machine from github [loopback-mobile-getting-started ](https://github.com/strongloop-community/loopback-mobile-getting-started) to a folder on iOS development machine
```sh
$ git clone https://github.com/strongloop-community/loopback-ios-examples
$ cd loopback-ios-examples
```

3. Start the LoopBack Node Server 
```sh
$slc run loopback-nodejs-server/app.js
```

4. inject some demo data
```sh
./initialize-data.sh
```

5. Open and Run ( CMD-R ) one of the sample projects 

###Example apps

![Image](screenshots/sample-examples-ios-all.png?raw=true)

####UITableView with CRUD
![](screenshots/tableview.png?raw=true)

####MapView with Get All, Get Nearest, Get Nearest 5 
![](screenshots/mapview.png?raw=true)

####Remote Method
![](screenshots/remote.png?raw=true)

