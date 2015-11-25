//
//  AudioEncodeHelper.h
//  SynthesizerQueue
//
//  Created by 梅俊 on 15/11/25.
//  Copyright © 2015年 iFlytek. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AudioEncodeHelper : NSObject

+ (NSData *)wavDataFromPcm:(NSData *)pcmData;

@end
