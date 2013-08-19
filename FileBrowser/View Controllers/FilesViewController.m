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
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    cell.textLabel.text = [_directoryContents objectAtIndex: indexPath.row];
    return cell;
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

@end
