//
//  ServerController.h
//  nxt_remote
//
//  Copyright (c) 2011-2012 Alexander Zautke. All rights reserved.
//  This code is released under the MIT License (MIT).
//  For conditions of distribution and use, see the disclaimer and license in nxt_remote.h
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
