//
//  FileTableViewCell.h
//  FileBrowser
//
//  Created by Barney on 8/20/13.
//  Copyright (c) 2013 pvllnspk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FileTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *fileImage;
@property (weak, nonatomic) IBOutlet UILabel *fileName;
@property (weak, nonatomic) IBOutlet UILabel *fileSize;
@property (weak, nonatomic) IBOutlet UILabel *fileDate;

@end
