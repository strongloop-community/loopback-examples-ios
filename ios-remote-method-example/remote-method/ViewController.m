//
//  ViewController.m
//  remote-method
//
//  Created by Matt Schmulen on 9/15/13.
//  Copyright (c) 2013 Matt Schmulen. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *labelMethod1;
@property (weak, nonatomic) IBOutlet UILabel *labelMethod2;
@end

@implementation ViewController

- (IBAction)actionMethod1:(id)sender {
    
    // ++++++++++++++++++++++++++++++++++++
    // call a custom method on the server
    // ++++++++++++++++++++++++++++++++++++
    
    // Define the load error functional block
    void (^staticMethodErrorBlock)(NSError *) = ^(NSError *error) {
        NSLog( @"Error %@", error.description);
    };//end selfFailblock
    
    // Define the load success block for the LBModelPrototype allWithSuccess message
    void (^staticMethodSuccessBlock)() = ^(id result) {
        NSLog(@"Success on Static Method result: %@", result);
        
        self.labelMethod1.text = @"Response 1";
        
    };//end staticMethodSuccessBlock
    
    //Get a local representation of the 'cars' model type
    LBModelPrototype *objectB = [[AppDelegate adapter] prototypeWithName:@"cars"];
    [[[AppDelegate adapter] contract] addItem:[SLRESTContractItem itemWithPattern:@"/cars/custommethod1" verb:@"GET"] forMethod:@"cars.custommethod1"];
    
    // Invoke the invokeStaticMethod message for the 'cars' LBModelPrototype
    // Equivalent http JSON endpoint request : http://localhost:3000/cars/custommethod1
    [objectB invokeStaticMethod:@"custommethod1" parameters:@{} success:staticMethodSuccessBlock failure:staticMethodErrorBlock ];
}

- (IBAction)actionMethod2:(id)sender {
    
    // ++++++++++++++++++++++++++++++++++++
    // call a custom method on the server
    // ++++++++++++++++++++++++++++++++++++
    
    // Define the load error functional block
    void (^staticMethodErrorBlock)(NSError *) = ^(NSError *error) {
        NSLog( @"Error %@", error.description);
    };//end selfFailblock
    
    // Define the load success block for the LBModelPrototype allWithSuccess message
    void (^staticMethodSuccessBlock)() = ^(id result) {
        NSLog(@"Success on Static Method result: %@", result);
        
        self.labelMethod2.text = @"Response 2";
        
    };//end staticMethodSuccessBlock
    
    //Get a local representation of the 'cars' model type
    LBModelPrototype *objectB = [[AppDelegate adapter] prototypeWithName:@"cars"];
    [[[AppDelegate adapter] contract] addItem:[SLRESTContractItem itemWithPattern:@"/cars/custommethod2" verb:@"GET"] forMethod:@"cars.custommethod2"];
    
    // Invoke the invokeStaticMethod message for the 'cars' LBModelPrototype
    // Equivalent http JSON endpoint request : http://localhost:3000/cars/custommethod2?arg1=yack&arg2=123
    [objectB invokeStaticMethod:@"custommethod2" parameters:@{@"arg1":@"yack" , @"arg2":@123} success:staticMethodSuccessBlock failure:staticMethodErrorBlock ];
    
}
- (IBAction)actionMethod3:(id)sender {
    
    // ++++++++++++++++++++++++++++++++++++
    // call a custom method on the server
    // ++++++++++++++++++++++++++++++++++++
    
    // Define the load error functional block
    void (^staticMethodErrorBlock)(NSError *) = ^(NSError *error) {
        NSLog( @"Error %@", error.description);
    };//end selfFailblock
    
    // Define the load success block for the LBModelPrototype allWithSuccess message
    void (^staticMethodSuccessBlock)() = ^(id result) {
        NSLog(@"Success on Static Method result: %@", result);
    };//end staticMethodSuccessBlock
    
    //Get a local representation of the 'cars' model type
    LBModelPrototype *objectB = [[AppDelegate adapter] prototypeWithName:@"cars"];
    [[[AppDelegate adapter] contract] addItem:[SLRESTContractItem itemWithPattern:@"/cars/custommethod3" verb:@"GET"] forMethod:@"cars.custommethod3"];
    
    // Invoke the invokeStaticMethod message for the 'cars' LBModelPrototype
    // Equivalent http JSON endpoint request : http://localhost:3000/cars/custommethod3?arg1=yack&arg2=123
    [objectB invokeStaticMethod:@"custommethod3" parameters:@{@"arg1":@"yack" , @"arg2":@123} success:staticMethodSuccessBlock failure:staticMethodErrorBlock ];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
