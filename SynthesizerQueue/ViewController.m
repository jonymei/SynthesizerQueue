//
//  ViewController.m
//  SynthesizerQueue
//
//  Created by 梅俊 on 15/11/25.
//  Copyright © 2015年 iFlytek. All rights reserved.
//

#import "ViewController.h"
#import "SynthesizerQueue.h"

@interface ViewController ()

@property (nonatomic, strong) SynthesizerQueue *synthesizerQueue;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.title = @"长文本合成优化";
    self.view.backgroundColor = [UIColor whiteColor];
    
    _synthesizerQueue = [[SynthesizerQueue alloc] init];
    
    UITextView *textView = [[UITextView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:textView];
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"ABC" ofType:@"txt"];
    NSData *fileData = [[NSData alloc] initWithContentsOfFile:filePath];
    if (fileData) {
        NSString *text = [[NSString alloc] initWithData:fileData encoding:NSUTF8StringEncoding];
        textView.text = text;
        NSMutableCharacterSet *mcharset = [[NSMutableCharacterSet alloc] init];
        [mcharset addCharactersInString:@"\n"];
        [mcharset addCharactersInString:@"。"];
        [mcharset addCharactersInString:@"！"];
        [mcharset addCharactersInString:@"？"];
        [mcharset addCharactersInString:@"；"];
        [mcharset addCharactersInString:@"，"];
        NSArray *segments = [text componentsSeparatedByCharactersInSet:mcharset];
        _synthesizerQueue.textSegments = [[NSMutableArray alloc] initWithArray:segments];
        [_synthesizerQueue start];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
