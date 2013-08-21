//
//  SettingsManager.m
//  FileBrowser
//
//  Created by Barney on 8/20/13.
//  Copyright (c) 2013 pvllnspk. All rights reserved.
//

#import "SettingsManager.h"

#define KEY_SHOW_HIDDEN_FILES @"KEY_SHOW_HIDDEN_FILES"

@implementation SettingsManager

+ (id)sharedManager
{
    static dispatch_once_t onceToken;
    static SettingsManager *settingsManager;
    dispatch_once(&onceToken, ^{
        settingsManager = [[self alloc] init];
    });
    return settingsManager;
}

- (NSString*)appVersion
{
	return [[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString *)kCFBundleVersionKey];
}

-(void) saveShowHiddenFiles:(BOOL) showHiddenFiles
{
    [[NSUserDefaults standardUserDefaults] setBool:showHiddenFiles forKey:KEY_SHOW_HIDDEN_FILES];
}

-(BOOL) showHiddenFiles
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:KEY_SHOW_HIDDEN_FILES];
}

@end
