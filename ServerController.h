//
//  ServerController.h
//  nxt_remote
//
//  Created by Alexander Zautke on 6/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ServerController : NSObject <NSNetServiceDelegate, NSStreamDelegate> {
    NSNetService *netService;
    
    NSInputStream  *  iStream;
    NSOutputStream *  oStream;
}

-(void)startService;
-(void)stopService;

-(void)setStreams: (NSInputStream*)istream : (NSOutputStream*)ostream;

-(void)startServer;

@end
