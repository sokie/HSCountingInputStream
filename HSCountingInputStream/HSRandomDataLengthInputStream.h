//
//  HSRandomDataLengthInputStream.h
//
//  Created by sokie on 10/07/14.
//  Copyright (c) 2014 sokie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HSRandomDataLengthInputStream : NSInputStream <NSStreamDelegate>

- (id)initWithLength:(uint32_t)length;

@end
