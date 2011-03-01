//
//  AppController.h
//  iPing
//
//  Created by Charles Feduke on 3/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface AppController : NSObject {
	IBOutlet NSTextView *outputView;
	IBOutlet NSTextField *hostField;
	IBOutlet NSButton *startButton;
	NSTask *task;
	NSPipe *pipe;
}

-(IBAction)startStopPing:(id)sender;
@end
