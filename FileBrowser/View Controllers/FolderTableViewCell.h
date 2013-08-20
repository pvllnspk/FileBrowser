//
//  FolderTableViewCell.h
//  FileBrowser
//
//  Created by Barney on 8/20/13.
//  Copyright (c) 2013 pvllnspk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FolderTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *folderImage;
@property (weak, nonatomic) IBOutlet UILabel *folderName;

@end
