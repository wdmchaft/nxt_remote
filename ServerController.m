//
//  ServerController.m
//  nxt_remote
//
//  Created by Alexander Zautke on 6/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ServerController.h"
#import <netinet/in.h>
#import <sys/socket.h>

@implementation ServerController

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

static void ListeningSocketCallback(CFSocketRef sock, CFSocketCallBackType type, CFDataRef address, const void *data, void *info)
{
    
    int fd = * (const int *) data;
    CFReadStreamRef   readStream;
    CFWriteStreamRef  writeStream;
    NSInputStream  *  inputStream;
    NSOutputStream *  outputStream;
    CFStreamCreatePairWithSocket(NULL, fd, &readStream,
                                 &writeStream);
    inputStream  = NSMakeCollectable(readStream );
    outputStream = NSMakeCollectable(writeStream);
    ServerController* server = [[ServerController alloc] init];
    [inputStream setDelegate:server];
    [inputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [server setStreams:inputStream :outputStream];
    [inputStream open];
    [inputStream setProperty:(id)kCFBooleanTrue
                      forKey:(NSString *)kCFStreamPropertyShouldCloseNativeSocket];
    NSLog(@"ListeningSocketCallback");
}

-(void)setStreams: (NSInputStream*)istream : (NSOutputStream*)ostream{
    iStream = istream;
    oStream = ostream;
}

- (void) stream: (NSStream *) stream handleEvent: (NSStreamEvent) eventCode{
    
    printf("EVENT: Start.\n");
    
    switch(eventCode)
    {
        case NSStreamEventOpenCompleted:
        {
            printf("EVENT: Open completed.\n");
            
            break;
        }
        case NSStreamEventEndEncountered:
        {
            printf("EVENT: End encountered.\n");
            break;
        }
        case NSStreamEventHasSpaceAvailable:
        {
            printf("EVENT: Has space available.\n");
            break;
        }
        case NSStreamEventHasBytesAvailable:
        {
            if (stream == iStream){
                printf("EVENT: Has bytes available.\n");
                NSMutableData* _data = [NSMutableData data];
                uint8_t buf[1024];
                unsigned int len = 0;
                len = [(NSInputStream *)stream read:buf maxLength:1024];
                if(len) {
                    [_data appendBytes:(const void *)buf length:len];
                    NSString *value = [[NSString alloc] initWithData:_data encoding:NSUTF8StringEncoding];
                    NSLog(@"%@",value);
                } else {
                    NSLog(@"no buffer!");
                }
            }
            break;
        }
        case NSStreamEventErrorOccurred:
        {
            NSLog(@"EVENT: Error.\n");
            break;
        }
        case NSStreamEventNone:
        {
            printf("EVENT: None.\n");
            break;
        }
    }
    
    printf("EVENT: End.\n");
}

-(void)startService {
    
    
    int fd4 = socket(AF_INET, SOCK_STREAM, 0);
    struct sockaddr_in sin;
    memset(&sin, 0, sizeof(sin));
    sin.sin_family = AF_INET;
    sin.sin_len = sizeof(sin);
    sin.sin_port = 0;
    int err = bind(fd4, (const struct sockaddr *) &sin, sin.sin_len);
    socklen_t addrLen = sizeof(sin);
    err = getsockname(fd4, (struct sockaddr *) &sin, &addrLen);
    err = listen(fd4, 5);
    
    int fd6 = socket(AF_INET6, SOCK_STREAM, 0);
    int one = 1;
    err = setsockopt(fd6, IPPROTO_IPV6, IPV6_V6ONLY, &one, sizeof(one));
    struct sockaddr_in6 sin6;
    memset(&sin6, 0, sizeof(sin6));
    sin6.sin6_family = AF_INET6;
    sin6.sin6_len = sizeof(sin6);
    sin6.sin6_port = sin.sin_port;
    err = bind(fd6, (const struct sockaddr *) &sin6, sin6.sin6_len);
    err = listen(fd6, 5);
    
    CFSocketContext    context = { 0, NULL, NULL, NULL, NULL };
    CFSocketRef        sock;
    CFRunLoopSourceRef rls;
    sock = CFSocketCreateWithNative(NULL, fd4,
                                    kCFSocketAcceptCallBack,
                                    ListeningSocketCallback,
                                    &context);
    rls = CFSocketCreateRunLoopSource(NULL, sock, 0);
    CFRunLoopAddSource(CFRunLoopGetCurrent(),
                       rls,
                       kCFRunLoopCommonModes);
    CFRelease(rls);
    CFRelease(sock);
    
    sock = CFSocketCreateWithNative(NULL, fd6,
                                    kCFSocketAcceptCallBack,
                                    ListeningSocketCallback,
                                    &context);
    rls = CFSocketCreateRunLoopSource(NULL, sock, 0);
    CFRunLoopAddSource(CFRunLoopGetCurrent(),
                       rls,
                       kCFRunLoopCommonModes);
    CFRelease(rls);
    CFRelease(sock);
    
    
    netService = [[NSNetService alloc] initWithDomain:@"" type:@"_nxtRemote._tcp." 
                                                 name:@""  
                                                 port:ntohs(sin.sin_port)];
    
    if (netService){
        netService.delegate = self;
        [netService publish];
    }
    else{
        NSLog(@"An error occurred initializing the NSNetService object.");
    }
}

-(void)stopService {
    [netService stop];
    [netService release];
    netService = nil;
}

-(void)dealloc {
    [self stopService];
}

#pragma mark Net Service Delegate Methods
-(void)netService:(NSNetService *)aNetService didNotPublish:(NSDictionary *)dict {
    NSLog(@"Failed to publish: %@", dict);
}

-(void)netServiceDidPublish:(NSNetService *)sender{
    NSLog(@"Published: %@", sender.name);
}

-(void)startServer{
    [self startService];
}

@end
