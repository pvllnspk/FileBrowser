//
//  SettingsTableViewCell.h
//  FileBrowser
//
//  Created by Barney on 8/20/13.
//  Copyright (c) 2013 pvllnspk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *settingsLabel;
@property (weak, nonatomic) IBOutlet UISwitch *settingsSwitch;
@property (weak, nonatomic) IBOutlet UILabel *settingsVersion;

@end
