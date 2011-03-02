//
//  AppController.m
//  iPing
//
//  Created by Charles Feduke on 3/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AppController.h"


@implementation AppController

-(IBAction)startStopPing:(id)sender {
	if (task) {
		[task interrupt];
	} else {
		task = [[NSTask alloc] init];
		[task setLaunchPath:@"/sbin/ping"];
		NSArray *args = [NSArray arrayWithObjects:@"-c10", [hostField stringValue], nil];
		[task setArguments:args];
		
		[pipe release];
		pipe = [[NSPipe alloc] init];
		[task setStandardOutput:pipe];
		
		NSFileHandle *fh = [pipe fileHandleForReading];
		NSNotificationCenter *nc;
		nc = [NSNotificationCenter defaultCenter];
		[nc removeObserver:self];
		[nc addObserver:self selector:@selector(dataReady:) name:NSFileHandleReadCompletionNotification object:fh];
		[nc addObserver:self selector:@selector(taskTerminated:) name:NSTaskDidTerminateNotification object:task];
		[task launch];
		[outputView setString:@""];
		
		[fh readInBackgroundAndNotify];
	}
}

-(void)appendData:(NSData *)d
{
	NSString *s = [[NSString alloc] initWithData:d encoding:NSUTF8StringEncoding];
	NSTextStorage *ts = [outputView textStorage];
	[ts replaceCharactersInRange:NSMakeRange([ts length], 0) withString:s];
	[s release];
}

-(void)dataReady:(NSNotification *)n {
	NSData *d;
	d = [[n userInfo] valueForKey:NSFileHandleNotificationDataItem];
	NSLog(@"dataReady: %d bytes", [d length]);
	
	if ([d length]) {
		[self appendData:d];
	}
	
	if (task)
		[[pipe fileHandleForReading] readInBackgroundAndNotify];
}

-(void)taskTerminated:(NSNotification *)n {
	NSLog(@"Task terminated");
	[task release];
	task = nil;
	[startButton setState:0];
}
@end
