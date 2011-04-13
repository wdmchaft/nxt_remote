//
//  nxt_remoteAppDelegate.h
//  nxt_remote
//
//  Created by Alexander Zautke on 3/10/11.
//

#import <Cocoa/Cocoa.h>

@interface nxt_remoteAppDelegate : NSObject <NSApplicationDelegate> {
    NSWindow *window;
}

@property (assign) IBOutlet NSWindow *window;

@end
