//
//  SynthesizerQueue.h
//  SynthesizerQueue
//
//  Created by 梅俊 on 15/11/25.
//  Copyright © 2015年 iFlytek. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SynthesizerQueue : NSObject

@property (atomic, strong) NSMutableArray<NSString *> *textSegments;

@property (nonatomic) NSUInteger maxCacheCount; //default is 5;

- (BOOL)start;

- (BOOL)stop;

- (void)putText:(NSString *)text;

@end
