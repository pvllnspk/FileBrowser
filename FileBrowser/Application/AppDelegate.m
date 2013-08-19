//
//  AppDelegate.m
//  FileBrowser
//
//  Created by Barney on 8/19/13.
//  Copyright (c) 2013 pvllnspk. All rights reserved.
//

#import "AppDelegate.h"
#import "SWRevealViewController.h"
#import "FilesViewController.h"
#import "SettingsViewController.h"

@interface AppDelegate() <SWRevealViewControllerDelegate>
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    FilesViewController *filesViewController = [[FilesViewController alloc] initWithNibName:@"FilesViewController" bundle:nil];
    SettingsViewController *settingsViewController = [[SettingsViewController alloc] initWithNibName:@"SettingsViewController" bundle:nil];
    
    UINavigationController *filesNavigationController = [[UINavigationController alloc] initWithRootViewController:filesViewController];
    
    SWRevealViewController *revealController = [[SWRevealViewController alloc] initWithRearViewController:settingsViewController frontViewController:filesNavigationController];
    revealController.delegate = self;
    
    self.viewController = revealController;
	
	self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
	return YES;
}

@end
