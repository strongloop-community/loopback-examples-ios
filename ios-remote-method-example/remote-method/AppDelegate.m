//
//  AppDelegate.m
//  remote-method
//
//  Created by Matt Schmulen on 9/15/13.
//  Copyright (c) 2013 Matt Schmulen. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

// The LBRESTAdapter defines the API server location endpoint for LoopBack server Calls
// file://localhost/loopback-clients/ios/docs/html/interface_l_b_r_e_s_t_adapter.html

static LBRESTAdapter * _adapter = nil;

+ (LBRESTAdapter *) adapter
{
    if( !_adapter)
        _adapter = [LBRESTAdapter adapterWithURL:[NSURL URLWithString:@"http://localhost:3000"]];
    return _adapter;
}

+ (void) initializeServerWithData
{
    // Define the load error functional block
    void (^saveNewErrorBlock)(NSError *) = ^(NSError *error) {
        NSLog( @"initializeServerWithData : Error on Save %@", error.description);
    };
    
    // Define the load success block for saveNewSuccessBlock message
    void (^saveNewSuccessBlock)() = ^() {
        NSLog( @"initializeServerWithData : Saved some initial data ");
    };
    /*
     LBModelPrototype *prototype = [ [AppDelegate adapter] prototypeWithName:@"products"];
     //Persist the newly created Model to the LoopBack node server
     [ [prototype modelWithDictionary:@{ @"name": @"Product A", @"inventory" : @11 }]  saveWithSuccess:saveNewSuccessBlock failure:saveNewErrorBlock];
     [ [prototype modelWithDictionary:@{ @"name": @"Product B", @"inventory" : @22 }]  saveWithSuccess:saveNewSuccessBlock failure:saveNewErrorBlock];
     [ [prototype modelWithDictionary:@{ @"name": @"Product C", @"inventory" : @33 }]  saveWithSuccess:saveNewSuccessBlock failure:saveNewErrorBlock];
     */
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
