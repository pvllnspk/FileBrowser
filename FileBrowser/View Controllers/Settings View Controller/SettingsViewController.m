//
//  SettingsViewController.m
//  FileBrowser
//
//  Created by Barney on 8/19/13.
//  Copyright (c) 2013 pvllnspk. All rights reserved.
//

#import "SettingsViewController.h"
#import "FilesViewController.h"
#import "SWRevealViewController.h"
#import "SettingsTableViewCell.h"
#import "SettingsManager.h"

@implementation SettingsViewController

@synthesize rearTableView;

-(void)viewDidLoad
{
    [rearTableView registerNib:[UINib nibWithNibName:@"SettingsTableViewCell" bundle:nil] forCellReuseIdentifier:@"Cell_Settings"];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *cellIdentifier = @"Cell_Settings";
	SettingsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	
	if (nil == cell){
		cell = [[SettingsTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryNone;
	}
    
    UILabel *settingsName = (UILabel *)[cell.contentView viewWithTag:101];
    UISwitch *settingsSwitch = (UISwitch *)[cell.contentView viewWithTag:102];
    UILabel *settingsVersion = (UILabel *)[cell.contentView viewWithTag:103];
    
    switch (indexPath.row) {
            
        case 0:
            
            settingsName.text = @"Show Hidden Files";
            settingsVersion.hidden = YES;
            [settingsSwitch addTarget:self action:@selector(setState:) forControlEvents:UIControlEventValueChanged];
            
            break;
        case 1:
            
            settingsName.text = @"Application Version";
            settingsSwitch.hidden = YES;
            settingsVersion.text = [[SettingsManager sharedManager] appVersion];
            
            break;
            
        default:
            break;
    }
	
	return cell;
}

- (void)setState:(id)sender
{
    BOOL state = [sender isOn];
    
    [_delegate onShowHideHiddenFiles:state];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SWRevealViewController *revealController = self.revealViewController;
    UINavigationController *frontNavigationController = (id)revealController.frontViewController;
    
    if (![frontNavigationController.topViewController isKindOfClass:[FilesViewController class]] ){
        
        FilesViewController *filesViewController = [[FilesViewController alloc] init];
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:filesViewController];
        [revealController setFrontViewController:navigationController animated:YES];
        
    } else {
        
        [revealController revealToggle:self];
    }
}

@end
