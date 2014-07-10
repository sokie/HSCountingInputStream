//
//  HSRandomDataLengthInputStream.h
//
//  Created by sokie on 10/07/14.
//  Copyright (c) 2014 sokie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HSRandomDataLengthInputStream : NSInputStream <NSStreamDelegate>

    @property (assign) uint16_t length;

- (id)initWithLength:(uint16_t)length;

@end
