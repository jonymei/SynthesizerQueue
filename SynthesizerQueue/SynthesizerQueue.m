//
//  SynthesizerQueue.m
//  SynthesizerQueue
//
//  Created by 梅俊 on 15/11/25.
//  Copyright © 2015年 iFlytek. All rights reserved.
//

#import "SynthesizerQueue.h"
#import <AVFoundation/AVFoundation.h>
#import <iflyMSC/iflyMSC.h>
#import "AudioEncodeHelper.h"

@interface SynthesizerQueue ()<IFlySpeechSynthesizerDelegate, AVAudioPlayerDelegate>

@property (nonatomic, strong) IFlySpeechSynthesizer *synthesizer;

@property (nonatomic, strong) AVAudioPlayer *player;

@property (nonatomic, strong) NSMutableArray<NSString *> *audioCaches;

@property (nonatomic) NSUInteger synthesizeIndex;

@end

@implementation SynthesizerQueue

- (instancetype)init
{
    if (self = [super init]) {
        [self setup];
        [[NSFileManager defaultManager] removeItemAtPath:[NSHomeDirectory() stringByAppendingPathComponent:@"audio"] error:nil];
    }
    return self;
}

- (void)setup
{
    _maxCacheCount = 6;
    _textSegments = [[NSMutableArray alloc] init];
    _synthesizer = [IFlySpeechSynthesizer sharedInstance];
    _synthesizer.delegate = self;
    [_synthesizer setParameter:@"100" forKey:[IFlySpeechConstant SPEED]];
    _audioCaches = [[NSMutableArray alloc] init];
    
    _synthesizeIndex = 0;
}



- (BOOL)start
{
    NSLog(@"start [IN]");
    if ([_synthesizer isSpeaking]) {
        NSLog(@"synthesizer is speaking!");
        return NO;
    }
    
    if (_audioCaches.count >= self.maxCacheCount) {
        NSLog(@"out of max count!");
        return NO;
    }
    
    while (_textSegments.firstObject.length == 0 && _textSegments.count != 0) {
        [_textSegments removeObjectAtIndex:0];
    }
    
    if (_textSegments.firstObject == nil || _textSegments.firstObject.length == 0) {
        NSLog(@"no text input!");
        return NO;
    }
    
    NSString *text = _textSegments.firstObject;
    NSLog(@"%@", text);
    
    [_synthesizer synthesize:text toUri:[self audioNameByIndex:_synthesizeIndex]];
    
    NSLog(@"start [OUT]");
    return YES;
}

- (BOOL)stop
{
    [_synthesizer stopSpeaking];
    [_player stop];
    
    return YES;
}

- (void)putText:(NSString *)text
{
    NSParameterAssert(text);
    if (!_textSegments) {
        _textSegments = [[NSMutableArray alloc] init];
    }
    [_textSegments addObject:text];
}

#pragma mark - private
- (NSString *)audioNameByIndex:(NSUInteger)index
{
    NSString *path = [NSHomeDirectory() stringByAppendingFormat:@"/Documents/audio/tts%tu.pcm", index];
    return path;
}

- (void)startPlaying
{
    if ([_player isPlaying]) {
        return;
    }
    if (_audioCaches.count == 0) {
        return;
    }
    
    NSData *pcmData = [NSData dataWithContentsOfFile:[_audioCaches firstObject]];
    if (pcmData.length > 0) {
        NSData *wavData = [AudioEncodeHelper wavDataFromPcm:pcmData];
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
        NSError *error = nil;
        _player = [[AVAudioPlayer alloc] initWithData:wavData error:&error];
        if (_player != nil && error == nil) {
            _player.delegate = self;
            [_player play];
            return;
        }
    }
    NSLog(@"bad audio!");
    dispatch_async(dispatch_get_main_queue(), ^{
        [self audioPlayerDidFinishPlaying:_player successfully:YES];    //跳过这一段
    });
}

#pragma mark - IFlySpeechSynthesizerDelegate
- (void)onCompleted:(IFlySpeechError *)error
{
    if (error.errorCode != 0) {
        //error
        return;
    }
    
    [_audioCaches addObject:[self audioNameByIndex:_synthesizeIndex]];
    _synthesizeIndex ++;
    NSLog(@"index = %tu", _synthesizeIndex);
    [_textSegments removeObjectAtIndex:0];
    
    //try to play
    [self startPlaying];
    
    //syntheize loop
    [self start];
}

#pragma mark - AVAudioPlayerDelegate
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    [[NSFileManager defaultManager] removeItemAtPath:[_audioCaches firstObject] error:nil];
    [_audioCaches removeObjectAtIndex:0];
    NSLog(@"removed!");
    
    [self startPlaying];
    
    [self start];
}

@end
