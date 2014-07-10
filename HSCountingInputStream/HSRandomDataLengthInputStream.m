//
//  HSRandomDataLengthInputStream.m
//
//  Created by sokie on 10/07/14.
//  Copyright (c) 2014 sokie. All rights reserved.
//

#import "HSRandomDataLengthInputStream.h"

@interface HSRandomDataLengthInputStream ()

@property uint16_t bytesAvailable;

@end

@implementation HSRandomDataLengthInputStream
{
    NSStreamStatus streamStatus;
    
    id <NSStreamDelegate> delegate;
    
	CFReadStreamClientCallBack copiedCallback;
	CFStreamClientContext copiedContext;
	CFOptionFlags requestedEvents;
}

@synthesize bytesAvailable;

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
        streamStatus = NSStreamStatusNotOpen;
        bytesAvailable = 0;
        [self setDelegate:self];
    }
    
    return self;
}

- (id)initWithLength:(uint16_t)length
{
    self = [super init];
    if (self) {
        // Initialization code here.
        streamStatus = NSStreamStatusNotOpen;
        self.length = length;
        self.bytesAvailable = length;
        [self setDelegate:self];
    }
    
    return self;
}

- (void)dealloc
{
    // [super dealloc];
}

#pragma mark - NSStream subclass overrides

- (void)open {
    streamStatus = NSStreamStatusOpen;
}

- (void)close {
    streamStatus = NSStreamStatusClosed;
}

- (id<NSStreamDelegate>)delegate {
    return delegate;
}

- (void)setDelegate:(id<NSStreamDelegate>)aDelegate {
    delegate = aDelegate;
    if (delegate == nil) {
    	delegate = self;
    }
}

- (void)scheduleInRunLoop:(NSRunLoop *)aRunLoop forMode:(NSString *)mode {
    // Nothing to do here, because this stream does not need a run loop to produce its data.
}

- (void)removeFromRunLoop:(NSRunLoop *)aRunLoop forMode:(NSString *)mode {
    // Nothing to do here, because this stream does not need a run loop to produce its data.
}

- (id)propertyForKey:(NSString *)key {
    return nil;
}

- (BOOL)setProperty:(id)property forKey:(NSString *)key {
    return NO;
}

- (NSStreamStatus)streamStatus {
    return streamStatus;
}

- (NSError *)streamError {
    return nil;
}


#pragma mark - NSInputStream subclass overrides

- (NSInteger)read:(uint8_t *)buffer maxLength:(NSUInteger)len {
	
    if(bytesAvailable > len){
        bytesAvailable-=len;
    }else{
        bytesAvailable=0;
        len-=bytesAvailable;
    }
    
	for (NSUInteger i=0; i<len; ++i) {
		buffer[i] = arc4random() & 0x00000000ffffffff;
	}
	
	if (CFReadStreamGetStatus((CFReadStreamRef)self) == kCFStreamStatusOpen) {
        
        double delayInSeconds = 0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            if (copiedCallback && (requestedEvents & kCFStreamEventHasBytesAvailable)) {
                copiedCallback((__bridge CFReadStreamRef)self, kCFStreamEventHasBytesAvailable, &copiedContext);
            }
        });
    }
	
	return len;
}

- (BOOL)getBuffer:(uint8_t **)buffer length:(NSUInteger *)len {
	// Not appropriate for this kind of stream; return NO.
	return NO;
}

- (BOOL)hasBytesAvailable {
    if(bytesAvailable > 0 ){
        return YES;
    }else{
        return NO;
    }
}

#pragma mark - Undocumented CFReadStream bridged methods

- (void)_scheduleInCFRunLoop:(CFRunLoopRef)aRunLoop forMode:(CFStringRef)aMode {
	// Nothing to do here, because this stream does not need a run loop to produce its data.
}

- (BOOL)_setCFClientFlags:(CFOptionFlags)inFlags
                 callback:(CFReadStreamClientCallBack)inCallback
                  context:(CFStreamClientContext *)inContext {
	
	if (inCallback != NULL) {
		requestedEvents = inFlags;
		copiedCallback = inCallback;
		memcpy(&copiedContext, inContext, sizeof(CFStreamClientContext));
		
		if (copiedContext.info && copiedContext.retain) {
			copiedContext.retain(copiedContext.info);
		}
		
		copiedCallback((__bridge CFReadStreamRef)self, kCFStreamEventHasBytesAvailable, &copiedContext);
	}
	else {
		requestedEvents = kCFStreamEventNone;
		copiedCallback = NULL;
		if (copiedContext.info && copiedContext.release) {
			copiedContext.release(copiedContext.info);
		}
		
		memset(&copiedContext, 0, sizeof(CFStreamClientContext));
	}
	
	return YES;
	
}

- (void)_unscheduleFromCFRunLoop:(CFRunLoopRef)aRunLoop forMode:(CFStringRef)aMode {
	// Nothing to do here, because this stream does not need a run loop to produce its data.
}


@end
