//
//  MasterViewController.m
//  FileBrowser
//
//  Created by Barney on 8/19/13.
//  Copyright (c) 2013 pvllnspk. All rights reserved.
//

#import "FilesViewController.h"
#import "FileViewController.h"
#import "SWRevealViewController.h"
#import "FolderTableViewCell.h"
#import "FileTableViewCell.h"
#import "FileExtensions.h"
#import "SettingsManager.h"

@implementation FilesViewController
{
    NSString *_directoryPath;
    NSMutableArray *_directoryContents;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    SWRevealViewController *revealController = [self revealViewController];
    [self.navigationController.navigationBar addGestureRecognizer:revealController.panGestureRecognizer];
    UIBarButtonItem *rightRevealButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"reveal-icon.png"]
                                                                              style:UIBarButtonItemStyleBordered target:revealController action:@selector(rightRevealToggle:)];
    self.navigationItem.rightBarButtonItem = rightRevealButtonItem;
    
    [self updateDirectoryContents];
    
    NSString *currentPath = [_fileManager currentDirectoryPath];
    _directoryPath = currentPath;
    
    self.title = [_fileManager displayNameAtPath:currentPath];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"FolderTableViewCell" bundle:nil] forCellReuseIdentifier:@"Cell_Folder"];
    [self.tableView registerNib:[UINib nibWithNibName:@"FileTableViewCell" bundle:nil] forCellReuseIdentifier:@"Cell_File"];
    
    [self.tableView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
	[self.tableView setRowHeight:51.8f];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: animated];
    
    SettingsViewController *settingsViewController = (SettingsViewController*)[self revealViewController].rightViewController;
    settingsViewController.delegate = self;
    
    if(_pushedToStack){
        
        [_fileManager changeCurrentDirectoryPath: _directoryPath];
        _pushedToStack = NO;
        
        [self updateDirectoryContents];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_directoryContents count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *attributes = [_fileManager attributesOfItemAtPath: [_directoryContents objectAtIndex: [indexPath row]] error: nil];
    
    if([self isDirectory:indexPath]){
        
        static NSString *CellIdentifier = @"Cell_Folder";
        
        FolderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[FolderTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        
        UILabel *folderName = (UILabel *)[cell.contentView viewWithTag:102];
        folderName.text = [_directoryContents objectAtIndex: indexPath.row];
        
        return cell;
        
    }else{
        
        static NSString *CellIdentifier = @"Cell_File";
        
        FileTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[FileTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        
        UIImageView *fileImage = (UIImageView *)[cell.contentView viewWithTag:101];
        [fileImage setImage:[self getImageForFile:[_directoryContents objectAtIndex: indexPath.row]]];
        
        UILabel *fileName = (UILabel *)[cell.contentView viewWithTag:102];
        fileName.text = [_directoryContents objectAtIndex: indexPath.row];
        
        UILabel *fileSize = (UILabel *)[cell.contentView viewWithTag:103];
        fileSize.text = [self getUserFriendlySize:[[[attributes valueForKey: NSFileSize] description] longLongValue]];
        
        UILabel *fileDate = (UILabel *)[cell.contentView viewWithTag:104];
        fileDate.text = [self getUserFriendlyDate:[[attributes valueForKey: NSFileModificationDate] description]];
        
        return cell;
    }
}

- (UIImage*) getImageForFile:(NSString*)fileName
{
    NSString *fileExtension = [fileName pathExtension];
    UIImage *fileImage = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png",fileExtension]];
    if (!fileImage) {
        fileImage = [UIImage imageNamed:@"_blank"];
        return fileImage;
    }
    
    return [UIImage imageNamed:[NSString stringWithFormat:@"%@.png",fileExtension]];
}

- (NSString*)getUserFriendlyDate:(NSString *)dateString
{
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy-MM-dd HH:mm:ss Z"];
    NSDate *date = [format dateFromString:dateString];
    [format setDateFormat:@"yyyy-MM-dd HH:mm"];
    return [format stringFromDate:date];
}

- (NSString*)getUserFriendlySize:(long)bytes
{
    return [NSByteCountFormatter stringFromByteCount:bytes countStyle:NSByteCountFormatterCountStyleFile];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *selectedPath = [_directoryContents objectAtIndex: [indexPath row]];
    BOOL moveInsideDirectory = [_fileManager changeCurrentDirectoryPath: selectedPath];
    
    if(moveInsideDirectory){
        
        FilesViewController *filesViewController = [[FilesViewController alloc] initWithNibName: @"FilesViewController" bundle: nil];
        filesViewController.fileManager = _fileManager;
        
        _pushedToStack = YES;
        
        [self.navigationController pushViewController: filesViewController animated: YES];
        
    }else{
        
        FileViewController *fileViewController = [[FileViewController alloc] initWithNibName:@"FileViewController" bundle:nil];
        fileViewController.fileName = [_directoryContents objectAtIndex: indexPath.row];
        fileViewController.filePath = [NSString stringWithFormat:@"%@/%@",_directoryPath,[_directoryContents objectAtIndex: indexPath.row]];
        [self.navigationController pushViewController:fileViewController animated:YES];
    }
    
    [tableView deselectRowAtIndexPath: indexPath animated: YES];
}

- (BOOL) isDirectory:(NSIndexPath *)indexPath
{
    NSString *filePath = [_directoryContents objectAtIndex: [indexPath row]];
    BOOL isDirectory;
    [_fileManager fileExistsAtPath:filePath isDirectory:&isDirectory];
    return isDirectory;
}

- (void)onShowHideHiddenFiles:(BOOL)show
{
    [[SettingsManager sharedManager] saveShowHiddenFiles:show];
    
    [self updateDirectoryContents];
}

- (void) updateDirectoryContents
{
    NSString *currentPath = [_fileManager currentDirectoryPath];
    _directoryContents = [NSMutableArray arrayWithArray:[_fileManager contentsOfDirectoryAtPath: currentPath error: nil]];
    
    if(![[SettingsManager sharedManager] showHiddenFiles]){
        
        [self hideHiddenFiles];
    }
    
    [self.tableView reloadData];
}

- (void) hideHiddenFiles
{
    for(NSString *file in [_directoryContents copy]){
        
        if([file hasPrefix:@"."]){
            [_directoryContents removeObject:file];
        }
    }
}

@end
