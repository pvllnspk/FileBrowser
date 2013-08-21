//
//  SettingsViewController.h
//  FileBrowser
//
//  Created by Barney on 8/19/13.
//  Copyright (c) 2013 pvllnspk. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ShowHideHiddenFilesDelegate <NSObject>
- (void)onShowHideHiddenFiles:(BOOL)show;
@end

@interface SettingsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, retain) IBOutlet UITableView *rearTableView;
@property (nonatomic, assign) id<ShowHideHiddenFilesDelegate> delegate;

@end
