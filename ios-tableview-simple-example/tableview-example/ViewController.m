//
//  ViewController.m
//  tableview-example
//
//  Created by Matt Schmulen on 9/15/13.
//  Copyright (c) 2013 Matt Schmulen. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"

#define prototypeName @"products"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (strong, nonatomic) NSArray *tableData;
@property (strong, nonatomic) LBRESTAdapter * adapter;
@end

@implementation ViewController

- (LBRESTAdapter *) adapter
{
    if( !_adapter)
        _adapter = [LBRESTAdapter adapterWithURL:[NSURL URLWithString:@"http://localhost:3000/api/"]];
    return _adapter;
}

- (NSArray *) tableData
{
    if ( !_tableData) _tableData = [[NSArray alloc] init];
    return _tableData;
};

- ( void ) getModels
{
    // ++++++++++++++++++++++++++++++++++++
    // Get all the model instances on the server
    // ++++++++++++++++++++++++++++++++++++
    
    // Define the load error functional block
    void (^loadErrorBlock)(NSError *) = ^(NSError *error) {
        NSLog( @"Error %@", error.description);
    };//end selfFailblock
    
    // Define the load success block for the LBModelRepository allWithSuccess message
    void (^loadSuccessBlock)(NSArray *) = ^(NSArray *models) {
        NSLog( @"selfSuccessBlock %d", models.count);
        self.tableData  = models;
        [self.myTableView reloadData];
        // [self showGuideMessage:@"Great! you just pulled code from node"];
    };//end selfSuccessBlock
    
    //Get a local representation of the model type
    LBModelRepository *objectB = [[self adapter] repositoryWithModelName:prototypeName];
    
    // Invoke the allWithSuccess message for the LBModelRepository
    // Equivalent http JSON endpoint request : http://localhost:3000/api/products
    
    [objectB allWithSuccess: loadSuccessBlock failure: loadErrorBlock];
};


- ( void ) createNewModel
{
    // ++++++++++++++++++++++++++++++++++++
    // Uncomment the comment block below to call a custom method on the server
    // ++++++++++++++++++++++++++++++++++++
    
    ///*
    //Get a local representation of the model type
    LBModelRepository *prototype = [[self adapter] repositoryWithModelName:prototypeName];
    
    //create new LBModel of type
    LBModel *model = [prototype modelWithDictionary:@{ @"name": @"New Product", @"inventory" : @99 }];
    
    // Define the load error functional block
    void (^saveNewErrorBlock)(NSError *) = ^(NSError *error) {
        NSLog( @"Error on Save %@", error.description);
    };
    
    // Define the load success block for saveNewSuccessBlock message
    void (^saveNewSuccessBlock)() = ^() {
        
        // call a 'local' refresh to update the tableView
        [self getModels];
    };
    
    //Persist the newly created Model to the LoopBack node server
    [model saveWithSuccess:saveNewSuccessBlock failure:saveNewErrorBlock];
};

- ( void ) updateExistingModel
{
    // ++++++++++++++++++++++++++++++++++++
    // Uncomment the comment block below to call a custom method on the server
    // ++++++++++++++++++++++++++++++++++++
    
    // Define the find error functional block
    void (^findErrorBlock)(NSError *) = ^(NSError *error) {
        NSLog( @"Error No model found with ID %@", error.description);
    };
    
    // Define your success functional block
    void (^findSuccessBlock)(LBModel *) = ^(LBModel *model) {
        //dynamically add an 'inventory' variable to this model type before saving it to the server
        model[@"name"] = @"UPDATED NAME";
        
        //Define the save error block
        void (^saveErrorBlock)(NSError *) = ^(NSError *error) {
            NSLog( @"Error on Save %@", error.description);
        };
        void (^saveSuccessBlock)() = ^() {
            NSLog( @"Success on updateExistingModel ");
            // call a 'local' refresh to update the tableView
            [self getModels];
        };
        [model saveWithSuccess:saveSuccessBlock failure:saveErrorBlock];
    };
    
    //Get a local representation of the model type
    LBModelRepository *prototype = [[self adapter] repositoryWithModelName:prototypeName];
    
    //Get the instance of the model with ID = 2
    // Equivalent http JSON endpoint request : http://localhost:3000/api/products/2
    [prototype findById:@2 success:findSuccessBlock failure:findErrorBlock ];
    
}//end updateExistingModelAndPushToServer

- ( void ) deleteExistingModel
{
    // ++++++++++++++++++++++++++++++++++++
    // Uncomment the comment block below to call a custom method on the server
    // ++++++++++++++++++++++++++++++++++++
    
    ///*
    // Define the find error functional block
    void (^findErrorBlock)(NSError *) = ^(NSError *error) {
        NSLog( @"Error No model found with ID %@", error.description);
    };
    
    // Define your success functional block
    void (^findSuccessBlock)(LBModel *) = ^(LBModel *model) {
        
        //Define the save error block
        void (^removeErrorBlock)(NSError *) = ^(NSError *error) {
            NSLog( @"Error on Save %@", error.description);
        };
        void (^removeSuccessBlock)() = ^() {
            NSLog( @"Success deleteExistingModel");
            // call a 'local' refresh to update the tableView
            [self getModels];
        };
        
        //Destroy this model instance on the LoopBack node server
        [ model destroyWithSuccess:removeSuccessBlock failure:removeErrorBlock ];
    };
    
    //Get a local representation of the model type
    LBModelRepository *prototype = [ [self adapter] repositoryWithModelName:prototypeName];
    
    //Get the instance of the model with ID = 2
    // Equivalent http JSON endpoint request : http://localhost:3000/products/2
    [prototype findById:@2 success:findSuccessBlock failure:findErrorBlock ];
    
}//end deleteExistingModel

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)actionRefresh:(id)sender {
     [self getModels];
}
- (IBAction)actionCreate:(id)sender {
    [self createNewModel];
}
- (IBAction)actionUpdate:(id)sender {
     [self updateExistingModel];
}
- (IBAction)actionDelete:(id)sender {
      [self deleteExistingModel];
}

- (IBAction)actionInjectData:(id)sender {
    LBModelRepository *ObjectPrototype = [ [self adapter]  repositoryWithModelName:prototypeName];
    
    void (^saveNewErrorBlock)(NSError *) = ^(NSError *error) {
        NSLog( @"initializeServerWithData: Error on Save %@", error.description);
    };
    void (^saveNewSuccessBlock)() = ^() {
        [self getModels];
    };
    
    //Persist the newly created Model to the LoopBack node server
    [ [ObjectPrototype modelWithDictionary:@{ @"name": [[NSString alloc] initWithFormat:@"Product %@",[NSNumber numberWithInteger:(arc4random() % 33 + 1)] ] , @"inventory" : [NSNumber numberWithInteger:(arc4random() % 60 + 1)] }]  saveWithSuccess:saveNewSuccessBlock failure:saveNewErrorBlock];
    [ [ObjectPrototype modelWithDictionary:@{ @"name": [[NSString alloc] initWithFormat:@"Product %@",[NSNumber numberWithInteger:(arc4random() % 33 + 1)] ] , @"inventory" : [NSNumber numberWithInteger:(arc4random() % 60 + 1)] }]  saveWithSuccess:saveNewSuccessBlock failure:saveNewErrorBlock];
    [ [ObjectPrototype modelWithDictionary:@{ @"name": [[NSString alloc] initWithFormat:@"Product %@",[NSNumber numberWithInteger:(arc4random() % 33 + 1)] ] , @"inventory" : [NSNumber numberWithInteger:(arc4random() % 60 + 1)] }]  saveWithSuccess:saveNewSuccessBlock failure:saveNewErrorBlock];
}

// UITableView methods
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
    
    if ( [[ [self.tableData objectAtIndex:indexPath.row] class] isSubclassOfClass:[LBModel class]])
    {
        LBModel *model = (LBModel *)[self.tableData objectAtIndex:indexPath.row];
        //cell.textLabel.text = model[@"name"]; // [model objectForKeyedSubscript:@"name"];
        cell.textLabel.text = [[NSString alloc] initWithFormat:@"%@",
                               [model objectForKeyedSubscript:@"name"] ];
    }
    return cell;
}



@end
