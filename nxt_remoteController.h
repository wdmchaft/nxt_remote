//
//  nxt_remoteController.h
//  nxt_remote
//
//  Copyright (c) 2011-2012 Alexander Zautke.
//  This code is released under the MIT License (MIT).
//  For conditions of distribution and use, see the disclaimer and license in nxt_remote.h
//

#import <Foundation/Foundation.h>
#import "nxt_remote.h"
#import "ServerController.h"


@interface nxt_remoteController : NSObject {
    NXT* _nxt;
    ServerController* server;
    
    Boolean programStarted;
    Boolean soundStarted;
    NSString* programNameC;
    
    IBOutlet NSTextField* deviceStatus;
    IBOutlet NSTextField* programName;
    IBOutlet NSTextField* errorField;
    IBOutlet NSTextField* soundFileField;
    IBOutlet NSTextField* inputValues;
    IBOutlet NSTextField* inputValues2;
    IBOutlet NSTextField* inputValues3;
    IBOutlet NSTextField* inputValues4;
    IBOutlet NSTextField* protocolVersion;
    IBOutlet NSTextField* firmwareVersion;
    IBOutlet NSTextField* deviceName;
    IBOutlet NSTextField* btadressField;
    IBOutlet NSTextField* batteryLevelTextField;
    
    IBOutlet NSWindow* selectWindow;
    IBOutlet NSWindow* mainWindow;
    IBOutlet NSWindow* deviceInfoWindow;
    
    IBOutlet NSLevelIndicator* batterylevelIndicator;
    
    IBOutlet NSPopUpButton* popUpButton;
    IBOutlet NSPopUpButton* popUpButton2;
    IBOutlet NSPopUpButton* popUpButton3;
    IBOutlet NSPopUpButton* popUpButton4;
    
    IBOutlet NSButton* loopSound;
    IBOutlet NSButton* getInputValuesPort1;
    IBOutlet NSButton* getInputValuesPort2;
    IBOutlet NSButton* getInputValuesPort3;
    IBOutlet NSButton* getInputValuesPort4;
    IBOutlet NSButton* setOutputState;
}

- (IBAction)showSelectSheet:(id)sender;
- (IBAction)endSelectSheet:(id)sender;

- (id)initNXT;

- (IBAction)startProgram:(id)sender;
- (IBAction)doConnect:(id)sender;
- (IBAction)playSound:(id)sender;
- (IBAction)getBatteryLevelC:(id)sender;
- (IBAction)getInputValues:(id)sender;
- (IBAction)getFirmwareVersion:(id)sender;
- (IBAction)getDeviceInfo:(id)sender;
- (IBAction)setOutputState:(id)sender;

-(IBAction)forward:(id)sender;
-(IBAction)left:(id)sender;
-(IBAction)right:(id)sender;
-(IBAction)stop:(id)sender;

- (void)setupInputValues:(UInt8)port;
- (void)stopProgram;

- (NSString*)whichSensor:(UInt8)port;
- (IBAction)startServer:(id)sender;

@end
