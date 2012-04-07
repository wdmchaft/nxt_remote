//
//  nxt_remoteAppDelegate.h
//  nxt_remote
//
//  Copyright (c) 2011-2012 Alexander Zautke. All rights reserved.
//  This code is released under the MIT License (MIT).
//  For conditions of distribution and use, see the disclaimer and license in nxt_remote.h
//

#import <Cocoa/Cocoa.h>

@interface nxt_remoteAppDelegate : NSObject <NSApplicationDelegate> {
    NSWindow *__unsafe_unretained window;
}

@property (unsafe_unretained) IBOutlet NSWindow *window;

@end
