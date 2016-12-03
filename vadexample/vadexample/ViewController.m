//
//  ViewController.m
//  vadexample
//
//  Created by Peiqiang Hao on 16/9/17.
//  Copyright © 2016年 Peiqiang Hao. All rights reserved.
//

#import "ViewController.h"
#import "VoiceTableViewCell.h"

static NSString* VoiceTableCellIdentifier = @"VoiceTableCellIdentifier";
@interface ViewController () {

    NSArray* data;
    __weak IBOutlet UITableView *voiceTableView;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [voiceTableView registerClass:[VoiceTableViewCell class] forCellReuseIdentifier:VoiceTableCellIdentifier];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if (!data)
        return 0;
    return [data count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    VoiceTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:VoiceTableCellIdentifier forIndexPath:indexPath];
    VoiceSegment* segment = (VoiceSegment*)[data objectAtIndex:indexPath.row];
    if (segment.isVoice)
        cell.textLabel.text = [NSString stringWithFormat:@"开始于%.2fs 持续%.2fs",
                           segment.timestamp,
                           segment.duration];
    else
        cell.textLabel.text = [NSString stringWithFormat:@"空白%.2fs",
                               segment.duration];

    return cell;
}

- (IBAction)readaudio:(id)sender {
    
    //test-16000.wav
    NSURL *fileUrl = [[NSBundle mainBundle] URLForResource:@"44100" withExtension:@"mp3"];
//    NSURL *fileUrl = [[NSBundle mainBundle] URLForResource:@"testbig" withExtension:@"mp3"];
    WVAudioSegment* audioSegment = [[WVAudioSegment alloc] init];
    data = [audioSegment segmentAudio:fileUrl];
    [voiceTableView reloadData];
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}


@end
