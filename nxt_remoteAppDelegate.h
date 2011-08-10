//
//  nxt_remoteAppDelegate.h
//  nxt_remote
//
//  Created by Alexander Zautke on 3/10/11.
//

#import <Cocoa/Cocoa.h>

@interface nxt_remoteAppDelegate : NSObject <NSApplicationDelegate> {
    NSWindow *__unsafe_unretained window;
}

@property (unsafe_unretained) IBOutlet NSWindow *window;

@end
