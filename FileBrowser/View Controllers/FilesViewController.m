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

@implementation FilesViewController
{
    NSString *_directoryPath;
    NSArray *_directoryContents;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    SWRevealViewController *revealController = [self revealViewController];
    [self.navigationController.navigationBar addGestureRecognizer:revealController.panGestureRecognizer];
    UIBarButtonItem *rightRevealButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"reveal-icon.png"]
                                                                              style:UIBarButtonItemStyleBordered target:revealController action:@selector(rightRevealToggle:)];
    self.navigationItem.rightBarButtonItem = rightRevealButtonItem;
    
    
    NSString *currentPath = [_fileManager currentDirectoryPath];
    _directoryContents = [_fileManager contentsOfDirectoryAtPath: currentPath error: nil];
    
    _directoryPath = currentPath;
    self.title = [_fileManager displayNameAtPath:currentPath];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"FolderTableViewCell" bundle:nil] forCellReuseIdentifier:@"Cell_Folder"];
    [self.tableView registerNib:[UINib nibWithNibName:@"FileTableViewCell" bundle:nil] forCellReuseIdentifier:@"Cell_File"];
    
    [self.tableView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
	[self.tableView setRowHeight:51.8f];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: animated];
    
    if(_pushedToStack){
        
        [_fileManager changeCurrentDirectoryPath: _directoryPath];
        _pushedToStack = NO;
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
        
        UILabel *fileName = (UILabel *)[cell.contentView viewWithTag:102];
        fileName.text = [_directoryContents objectAtIndex: indexPath.row];
        
        return cell;
    }
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
        
        FileViewController *fileDetailViewController = [[FileViewController alloc] initWithNibName:@"FileDetailViewController" bundle:nil];
        [self.navigationController pushViewController:fileDetailViewController animated:YES];
    }
    
    [tableView deselectRowAtIndexPath: indexPath animated: YES];
}

-(BOOL) isDirectory:(NSIndexPath *)indexPath
{
    NSString *filePath = [_directoryContents objectAtIndex: [indexPath row]];
    BOOL isDirectory;
    [_fileManager fileExistsAtPath:filePath isDirectory:&isDirectory];
    return isDirectory;
}

@end
