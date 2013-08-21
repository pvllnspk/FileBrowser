//
//  SettingsManager.h
//  FileBrowser
//
//  Created by Barney on 8/20/13.
//  Copyright (c) 2013 pvllnspk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SettingsManager : NSObject

+ (id)sharedManager;

- (NSString*)appVersion;

- (void) saveShowHiddenFiles:(BOOL) showHiddenFiles;
- (BOOL) showHiddenFiles;

@end
