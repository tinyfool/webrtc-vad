//
//  ViewController.m
//  vadexample
//
//  Created by Peiqiang Hao on 16/9/17.
//  Copyright © 2016年 Peiqiang Hao. All rights reserved.
//

#import "ViewController.h"
@interface ViewController ()
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}


- (IBAction)readaudio:(id)sender {
    
    NSURL *fileUrl = [[NSBundle mainBundle] URLForResource:@"44100" withExtension:@"mp3"];
    WVAudioSegment* audioSegment = [[WVAudioSegment alloc] init];
    [audioSegment segmentAudio:fileUrl];
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}


@end
