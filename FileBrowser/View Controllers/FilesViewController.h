//
//  MasterViewController.h
//  FileBrowser
//
//  Created by Barney on 8/19/13.
//  Copyright (c) 2013 pvllnspk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SettingsViewController.h"

@class FileViewController;

@interface FilesViewController : UITableViewController <ShowHideHiddenFilesDelegate>

@property (strong, nonatomic) NSFileManager *fileManager;
@property BOOL pushedToStack;

@end
