//
//  ViewController.m
//  vadexample
//
//  Created by Peiqiang Hao on 16/9/17.
//  Copyright © 2016年 Peiqiang Hao. All rights reserved.
//

#import "ViewController.h"
#import "vadexample-Swift.h"


@interface ViewController () {

    NSArray* data;
    __weak IBOutlet UITableView *voiceTableView;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if (!data)
        return 0;
    return [data count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    VoiceSegment* segment = (VoiceSegment*)[data objectAtIndex:indexPath.row];
    UITableViewCell* cell;
    CellMaker* maker = [[CellMaker alloc] init];
    
    if (segment.isVoice) {
    
        cell = [maker makeLineCell:tableView];
        CGFloat width = segment.duration*20;
        if (width > tableView.bounds.size.width - 10) {
            
            width = tableView.bounds.size.width - 10;
        }
        NSString* title = [NSString stringWithFormat:@"始于 %.2fs，长 %.2fs",segment.timestamp,segment.duration];
        [maker LineCellWithCell:cell setTitle:title setWidth:width];
    } else {
    
        NSString* title = [NSString stringWithFormat:@"空白 %.2fs",segment.duration];
        cell = [maker makeSlienceCell:tableView withText:title];
    }
    
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
