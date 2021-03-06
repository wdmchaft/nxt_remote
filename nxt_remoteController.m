//
//  nxt_remoteController.m
//  nxt_remote
//
//  Copyright (c) 2011-2012 Alexander Zautke.
//  This code is released under the MIT License (MIT).
//  For conditions of distribution and use, see the disclaimer and license in nxt_remote.h
//

#import "nxt_remoteController.h"


@implementation nxt_remoteController

- (id)initNXT{
    self = [super init];
    if (self) {
        _nxt = [[NXT alloc] init];
    }
    
    return self;
}

- (id)init
{
    return [self initNXT];
}



- (IBAction)doConnect:(id)sender
{
    [deviceStatus setStringValue:(@"Connecting")];
    
    BOOL nxtConnected;
    nxtConnected = [_nxt connect:self];
    if (nxtConnected) {
        [deviceStatus setStringValue:(@"Connected to device")];
    }
    else {
        [deviceStatus setStringValue:(@"Failed to connect to device")];
    }
}

- (IBAction)close:(id)sender{
    [_nxt closeConnection];
    [deviceStatus setStringValue:@"Disconnected"];
}

- (IBAction)getFirmwareVersion:(id)sender{
    [_nxt getFirmwareVersion];
}

-(IBAction)startProgram:(id)sender
{
    
    NSString* programNameTextField;
    programNameTextField = [programName stringValue];
    
    NSRange rxeRange;
    rxeRange = [programNameTextField rangeOfString:@".rxe"];

    if (rxeRange.length == 0) {
        programNameTextField = [programNameTextField stringByAppendingString:@".rxe"];
    }
        
        
        if (programStarted == NO) {
            
            NSLog(@"%@",programNameTextField);
            
            if ([programNameTextField isEqualToString:@".rxe"]) {
                
                NSAlert *alert = [[NSAlert alloc] init];
                [alert setMessageText:@"No program name specified"];
                [alert setInformativeText:@"Please enter a program name, before starting the program"];
                [alert runModal];
            }
            
            else {
                
                [_nxt startProgram:programNameTextField];
                [sender setTitle:@"Stop program"];
                programStarted = YES;
            }
            
        }
        else {
            [self stopProgram];
            [sender setTitle:@"Start program"];
            programStarted = NO;
    }
}

-(IBAction)getBatteryLevelC:(id)sender{
    [_nxt getBatteryLevel];
}
-(IBAction)playSound:(id)sender {
    
    Boolean loopB;
    if ([loopSound state] == YES) {
        loopB = YES;
     }
    else {
        loopB = NO;
    }
    
    if (soundStarted == NO) {
        
        NSString* soundFile;
        soundFile = [soundFileField stringValue];
        
        NSRange rsoRange;
        rsoRange = [soundFile rangeOfString:@".rso"];
        
        if (rsoRange.length == 0) {
            soundFile = [soundFile stringByAppendingString:@".rso"];
        }
        
        if ([soundFile isEqualToString:@".rso"]) {
            NSAlert *alert = [[NSAlert alloc] init];
            [alert setMessageText:@"No sound file name specified"];
            [alert setInformativeText:@"Please enter a sound file name, before playing a sound"];
            [alert runModal];
        }
        else {
            
        [_nxt playSoundFile:soundFile loop:loopB];
        [sender setTitle:@"Stop sound"];
        soundStarted = YES;
        
        }
    }
    else {
        [_nxt stopSoundPlayback];
        [sender setTitle:@"Play SoundFile"];
        soundStarted = NO;
        }
}

-(void)stopProgram{
    [_nxt getCurrentProgramName];
    [_nxt stopProgram];
}

-(void)setupInputValues:(UInt8)port{
    NSString* sensorName = [self whichSensor:port];
    
    if ([sensorName isEqualToString:@"Touch"]){
        [_nxt setupTouchSensor:port];
        NSLog(@"Setup Touch");
    }
    if ([sensorName isEqualToString:@"Sound db"]) {
        [_nxt setupSoundSensor:port dbA:NO];
        NSLog(@"Setup Sound db");
    }
    if ([sensorName isEqualToString:@"Sound dbA"]) {
        [_nxt setupSoundSensor:port dbA:YES];
        NSLog(@"Setup Sound dbA");
    }
    if ([sensorName isEqualToString:@"Light Active"]) {
        [_nxt setupLightSensor:port active:YES];
        NSLog(@"Setup Light");
    }
    if ([sensorName isEqualToString:@"Light Passive"]) {
        [_nxt setupLightSensor:port active:NO];
        NSLog(@"Setup Light Passive");
    }
}

-(NSString*)whichSensor:(UInt8)port{
    if (port == kNXTSensor1) {
        NSString* sensorName;
        sensorName = [popUpButton titleOfSelectedItem];
        NSLog(@"Sensor selected: %@",sensorName);
        return sensorName; 
    }
    if (port == kNXTSensor2) {
        NSString* sensorName;
        sensorName = [popUpButton2 titleOfSelectedItem];
        NSLog(@"Sensor selected: %@",sensorName);
        return sensorName; 
    }
    if (port == kNXTSensor3) {
        NSString* sensorName;
        sensorName = [popUpButton3 titleOfSelectedItem];
        NSLog(@"Sensor selected: %@",sensorName);
        return sensorName; 
    }
    if (port == kNXTSensor4) {
        NSString* sensorName;
        sensorName = [popUpButton4 titleOfSelectedItem];
        NSLog(@"Sensor selected: %@",sensorName);
        return sensorName; 
    }
    return @"";
}

-(IBAction)getInputValues:(id)sender {
    UInt8 port = 0;
    if ([sender tag] == 0) {
        port = kNXTSensor1;
        NSLog(@"Port 1");
    }
    if ([sender tag] == 1) {
        port = kNXTSensor2;
        NSLog(@"Port 2");
    }
    if ([sender tag] == 2) {
        port = kNXTSensor3;
        NSLog(@"Port 3");
    }
    if ([sender tag] == 3) {
        port = kNXTSensor4;
        NSLog(@"Port 4");
    }
    [self setupInputValues:port];
    [_nxt getInputValues:port];
}

- (void)NXTBatteryLevel:(NXT*)nxt batteryLevel:(UInt16)batteryLevel
{
    NSString* batteryLevelString;
    batteryLevelString = [NSString stringWithFormat:@"%i",batteryLevel];
    batteryLevelString = [batteryLevelString stringByAppendingFormat:@" milivolts"];
    [batteryLevelTextField setStringValue:batteryLevelString];
    [batterylevelIndicator setIntValue:batteryLevel];
}

- (void)NXTCommunicationError:(NXT*)nxt code:(int)code {
    
    [errorField setIntValue:code];
}

- (void)NXTCurrentProgramName:(NXT*)nxt currentProgramName:(NSString*)currentProgramName {
    
    programNameC = currentProgramName;
    
}

- (void) NXTDiscovered:(NXT*)nxt
    {

    
         
     }

-(void)NXTGetInputValues:(NXT *)nxt port:(UInt8)port isCalibrated:(BOOL)isCalibrated type:(UInt8)type mode:(UInt8)mode rawValue:(UInt16)rawValue normalizedValue:(UInt16)normalizedValue scaledValue:(SInt16)scaledValue calibratedValue:(SInt16)calibratedValue {
    
    switch (port) {
        case kNXTSensor1:
            [inputValues setIntValue:scaledValue];
            break;
        case kNXTSensor2:
            [inputValues2 setIntValue:scaledValue];
            break;
        case kNXTSensor3:
            [inputValues3 setIntValue:scaledValue];
            break;
        case kNXTSensor4:
            [inputValues4 setIntValue:scaledValue];
            break;
        default:
            break;
    }
}

// handle errors
- (void)NXTOperationError:(NXT*)nxt operation:(UInt8)operation status:(UInt8)status
    {
        NSString* errorMessage;
        NSLog(@"nxt error: operation=0x%x status=0x%x", operation, status);
        errorMessage = [NSString stringWithFormat:@"0x%x",status];
        [errorField setStringValue:errorMessage];
   }

// disconnected
- (void)NXTClosed:(NXT*)nxt
{
    [deviceStatus setStringValue:@"Disconnected"];
}

- (void)NXTGetFirmwareVersion:(NXT *)nxt minorVersionProtocol:(UInt8)minorVersionProtocol majorVersionProtocol:(UInt8)majorVersionProtocol minorVersionFirmware:(UInt8)minorVersionFirmware majorVersionFirmware:(UInt8)majorVersionFirmware{
    
    NSString* protocolVersionS = [[NSString alloc] initWithFormat:@"%i",majorVersionProtocol];
    protocolVersionS = [protocolVersionS stringByAppendingFormat:@".%i",minorVersionProtocol];
    [protocolVersion setStringValue:protocolVersionS];
    
    NSString* firmwareVersionS = [[NSString alloc] initWithFormat:@"%i",majorVersionFirmware];
    firmwareVersionS = [firmwareVersionS stringByAppendingFormat:@".%i",minorVersionFirmware];
    [firmwareVersion setStringValue:firmwareVersionS];
}

- (void)NXTSysGetDeviceInfo:(NXT *)nxt nxtName:(NSString *)nxtName btadress:(NSString *)btadress{
    [deviceName setStringValue:nxtName];
    [btadressField setStringValue:btadress];
}

- (IBAction)showSelectSheet:(id)sender{
    [NSApp beginSheet:selectWindow modalForWindow:mainWindow modalDelegate:nil didEndSelector:NULL contextInfo:NULL];
}

- (IBAction)endSelectSheet:(id)sender{
    [self doConnect:sender];
    [NSApp endSheet:selectWindow];
    [selectWindow orderOut:sender];
}

- (IBAction)getDeviceInfo:(id)sender{
    [_nxt getDeviceInfo];
}

- (IBAction)setOutputState:(id)sender{

}

-(IBAction)forward:(id)sender{
    [_nxt setOutputState:kNXTMotorAll power:0 mode:kNXTCoast regulationMode:kNXTRegulationModeIdle turnRatio:0 runState:kNXTMotorRunStateIdle tachoLimit:0];
    [_nxt moveServo:kNXTMotorA power:100 tacholimit:0];
    [_nxt moveServo:kNXTMotorC power:100 tacholimit:0];
}

-(IBAction)left:(id)sender{
    [_nxt setOutputState:kNXTMotorAll power:0 mode:kNXTCoast regulationMode:kNXTRegulationModeIdle turnRatio:0 runState:kNXTMotorRunStateIdle tachoLimit:0];
    [_nxt moveServo:kNXTMotorA power:100 tacholimit:0];
    [_nxt moveServo:kNXTMotorC power:30 tacholimit:0];
}

-(IBAction)right:(id)sender{
    [_nxt setOutputState:kNXTMotorAll power:0 mode:kNXTCoast regulationMode:kNXTRegulationModeIdle turnRatio:0 runState:kNXTMotorRunStateIdle tachoLimit:0];
    [_nxt moveServo:kNXTMotorA power:30 tacholimit:0];
    [_nxt moveServo:kNXTMotorC power:100 tacholimit:0];
}

-(IBAction)stop:(id)sender{
    [_nxt setOutputState:kNXTMotorAll power:0 mode:kNXTCoast regulationMode:kNXTRegulationModeIdle turnRatio:0 runState:kNXTMotorRunStateIdle tachoLimit:0];
    [_nxt moveServo:kNXTMotorA power:0 tacholimit:0];
    [_nxt moveServo:kNXTMotorC power:0 tacholimit:0];
}

- (IBAction)startServer:(id)sender{
    server = [[ServerController alloc] init];
    [server startServer];
}

@end
