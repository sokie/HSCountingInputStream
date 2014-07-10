//
//  HSNSStringInputStream.h
//
//  Created by sokie on 10/07/14.
//  Copyright (c) 2014 sokie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HSNSStringInputStream : NSInputStream <NSStreamDelegate>

@property (assign) NSString *string;

- (id)initWithNSString:(NSString *)string;

@end