//
//  ViewController.m
//  ios-filter-example
//
//  Created by Matt Schmulen on 12/16/13.
//  Copyright (c) 2013 Matt Schmulen. All rights reserved.
//

#import "ViewController.h"
#import <LoopBack/LoopBack.h>

@interface ViewController ()

@property (strong, nonatomic) LBRESTAdapter *adapter;
@property (strong, nonatomic) NSMutableArray *tableData;
@property (weak, nonatomic) IBOutlet UITableView *myTableView;

@end

@implementation ViewController

- (NSMutableArray *) tableData
{
    if ( !_tableData) _tableData = [[NSMutableArray alloc] init];
    return _tableData;
};

- (LBRESTAdapter *) adapter
{
    if( !_adapter)
        _adapter = [LBRESTAdapter adapterWithURL:[NSURL URLWithString:@"http://localhost:3000/api"]];
    return _adapter;
}

- (IBAction)actionGetModelsNoFilter:(id)sender {
    
    // Define the load success block for the LBModelPrototype allWithSuccess message
    void (^loadSuccessBlock)(NSArray *) = ^(NSArray *models) {
        NSLog( @"selfSuccessBlock %d", models.count);
        NSLog(@"Success on Static Method result: %@", models);
        
        [self.tableData removeAllObjects ];
        
        for (int i = 0; i < models.count; i++) {
            LBModel *modelInstance = (LBModel*)[models objectAtIndex:i];
            [self.tableData addObject:modelInstance ];
        }//end for
        
        [self.myTableView reloadData];
    };//end selfSuccessBlock
    
    // Define the load error functional block
    void (^loadErrorBlock)(NSError *) = ^(NSError *error) {
        NSLog( @"Error %@", error.description);
    };//end selfFailblock
    
    //Get a local representation of the 'products' model type
    LBModelRepository *prototype = [ [self adapter]  repositoryWithModelName:@"products"];
    
    // Invoke the allWithSuccess message for the 'products' LBModelPrototype
    // Equivalent http JSON endpoint request : http://localhost:3000/products
    
    [prototype allWithSuccess: loadSuccessBlock failure: loadErrorBlock];
    
}

- (IBAction)actionGetModelsFilterAscendingOrderLimit:(id)sender {
    
    void (^staticMethodErrorBlock)(NSError *) = ^(NSError *error) {
        NSLog( @"Error %@", error.description);
    };//end selfFailblock
    
    void (^staticMethodSuccessBlock)(NSArray *) = ^(NSArray *models) {
        NSLog( @"selfSuccessBlock %d", models.count);
        NSLog(@"Success on Static Method result: %@", models);
        
        [self.tableData removeAllObjects ];
        
        for (int i = 0; i < models.count; i++) {
            LBModel *modelInstance = (LBModel*)[models objectAtIndex:i];
            [self.tableData addObject:modelInstance ];
        }//end for
        
        [self.myTableView reloadData];
    };//end staticMethodSuccessBlock
    
    LBModelRepository *prototype = [ [self adapter]  repositoryWithModelName:@"products"];
    
    [[ [self adapter] contract] addItem:[SLRESTContractItem itemWithPattern:@"/products" verb:@"GET"] forMethod:@"products.filter"];
    
    //Product with lowest inventory
    // http://localhost:3000/api/products?filter[order]=inventory%20ASC&filter[limit]=3': The highest inventory products
    [prototype invokeStaticMethod:@"filter" parameters:@{ @"filter[order]":@"inventory ASC",@"filter[limit]":@3} success:staticMethodSuccessBlock failure:staticMethodErrorBlock];
    
}

- (IBAction)actionGetModelsFilterDescendingOrderLimit:(id)sender {
    
    void (^staticMethodErrorBlock)(NSError *) = ^(NSError *error) {
        NSLog( @"Error %@", error.description);
    };//end selfFailblock
    
    void (^staticMethodSuccessBlock)(NSArray *) = ^(NSArray *models) {
        NSLog( @"selfSuccessBlock %d", models.count);
        NSLog(@"Success on Static Method result: %@", models);
        
        [self.tableData removeAllObjects ];
        
        for (int i = 0; i < models.count; i++) {
            LBModel *modelInstance = (LBModel*)[models objectAtIndex:i];
            [self.tableData addObject:modelInstance ];
        }//end for
        
        [self.myTableView reloadData];
    };//end staticMethodSuccessBlock
    
    LBModelRepository *prototype = [ [self adapter]  repositoryWithModelName:@"products"];
    
    [[ [self adapter] contract] addItem:[SLRESTContractItem itemWithPattern:@"/products" verb:@"GET"] forMethod:@"products.filter"];
    
    //Product with lowest inventory
    // http://33.33.33.10:3000/api/products?filter[limit]=4
    // http://localhost:3000/api/products?filter[order]=inventory%20ASC&filter[limit]=3': The highest inventory
    [prototype invokeStaticMethod:@"filter" parameters:@{ @"filter[order]":@"inventory DESC",@"filter[limit]":@3} success:staticMethodSuccessBlock failure:staticMethodErrorBlock];
}


- (IBAction)actionInjectSomeData:(id)sender {
    
    LBModelRepository *prototype = [ [self adapter]  repositoryWithModelName:@"products"];
    
    // Define the load error functional block
    void (^loadErrorBlock)(NSError *) = ^(NSError *error) {
        NSLog( @"initializeServerWithData : Error %@", error.description);
    };//end selfFailblock
    
    // Define the load success block for the LBModelPrototype allWithSuccess message
    void (^loadSuccessBlock)(NSArray *) = ^(NSArray *models) {
        
        //if ( models.count <= 0 )
        {
            void (^saveNewErrorBlock)(NSError *) = ^(NSError *error) {
                NSLog( @"initializeServerWithData: Error on Save %@", error.description);
            };
            void (^saveNewSuccessBlock)() = ^() { };
            
            //Persist the newly created Model to the LoopBack node server
            [ [prototype modelWithDictionary:@{ @"name": @"Product A", @"inventory" : @11, @"price" :@66.34 , @"units-sold" : @11 }]  saveWithSuccess:saveNewSuccessBlock failure:saveNewErrorBlock];
            [ [prototype modelWithDictionary:@{ @"name": @"Product B", @"inventory" : @84, @"price" :@22.34 , @"units-sold" : @22 }]  saveWithSuccess:saveNewSuccessBlock failure:saveNewErrorBlock];
            [ [prototype modelWithDictionary:@{ @"name": @"Product C", @"inventory" : @33, @"price" :@31.54 , @"units-sold" : @44 }]  saveWithSuccess:saveNewSuccessBlock failure:saveNewErrorBlock];
            [ [prototype modelWithDictionary:@{ @"name": @"Product D", @"inventory" : @12, @"price" :@16.54 , @"units-sold" : @55 }]  saveWithSuccess:saveNewSuccessBlock failure:saveNewErrorBlock];
            [ [prototype modelWithDictionary:@{ @"name": @"Product E", @"inventory" : @22, @"price" :@21.54 , @"units-sold" : @66 }]  saveWithSuccess:saveNewSuccessBlock failure:saveNewErrorBlock];
            [ [prototype modelWithDictionary:@{ @"name": @"Product F", @"inventory" : @123, @"price" :@1.14 , @"units-sold" : @77 }]  saveWithSuccess:saveNewSuccessBlock failure:saveNewErrorBlock];
            [ [prototype modelWithDictionary:@{ @"name": @"Product H", @"inventory" : @45, @"price" :@33.54 , @"units-sold" : @88 }]  saveWithSuccess:saveNewSuccessBlock failure:saveNewErrorBlock];
            
            
        }//end if models.cout <= 0
    };//end selfSuccessBlock
    
    [prototype allWithSuccess: loadSuccessBlock failure: loadErrorBlock];
    
}



- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView delegate methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.tableData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    LBModel *model = (LBModel *)[self.tableData objectAtIndex:indexPath.row];
    cell.textLabel.text = [[NSString alloc] initWithFormat:@"%@ - %@", [model objectForKeyedSubscript:@"name"] ,[model objectForKeyedSubscript:@"inventory"]  ];
    
    return cell;
}

@end
