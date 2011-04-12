//
//  nxt_remoteController.h
//  nxt_remote
//
//  Created by Alexander Zautke on 12.03.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "nxt_remote.h"


@interface nxt_remoteController : NSObject {
    NXT* _nxt;
    
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
}

- (IBAction)startProgramm:(id)sender;
- (IBAction)doConnect:(id)sender;
- (IBAction)playSound:(id)sender;
- (IBAction)getBatteryLevelC:(id)sender;
- (IBAction)getInputValues:(id)sender;

- (void)setupInputValues:(UInt8)port;
- (void)stopProgram;

- (NSString*)whichSensor:(UInt8)port;

@end
