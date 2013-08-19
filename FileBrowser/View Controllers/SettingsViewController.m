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

@implementation SettingsViewController

@synthesize rearTableView;

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *cellIdentifier = @"Cell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    NSInteger row = indexPath.row;
	
	if (nil == cell){
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
	}
	
    cell.textLabel.text = [NSString stringWithFormat:@" %d ",row];
	
	return cell;
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
