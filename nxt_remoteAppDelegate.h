//
//  nxt_remoteAppDelegate.h
//  nxt_remote
//
//  Created by Alexander Zautke on 3/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface nxt_remoteAppDelegate : NSObject <NSApplicationDelegate> {
    NSWindow *window;
}

@property (assign) IBOutlet NSWindow *window;

@end
