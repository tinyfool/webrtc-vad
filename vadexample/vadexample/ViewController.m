//
//  ViewController.m
//  vadexample
//
//  Created by Peiqiang Hao on 16/9/17.
//  Copyright © 2016年 Peiqiang Hao. All rights reserved.
//

#import "ViewController.h"
#import "vadexample-Swift.h"
#import <AVFoundation/AVFoundation.h>
#import <webrtcvad/webrtcvad.h>
#import <Speech/Speech.h>

@interface ViewController () {

    NSArray* data;
    __weak IBOutlet UITableView *voiceTableView;
    AVAudioPlayer* player;
    NSTimer* timer;
    NSURL *fileUrl;
    SFSpeechRecognizer* recognizer;
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
    fileUrl = [[NSBundle mainBundle] URLForResource:@"44100" withExtension:@"mp3"];
//    NSURL *fileUrl = [[NSBundle mainBundle] URLForResource:@"testbig" withExtension:@"mp3"];
    
    NSError* error;
    player = [[AVAudioPlayer alloc] initWithContentsOfURL:fileUrl error:&error];
    if (player) {
    
        [player prepareToPlay];
    }
    WVAudioSegment* audioSegment = [[WVAudioSegment alloc] init];
    data = [audioSegment segmentAudio:fileUrl];
    [voiceTableView reloadData];
}

- (nullable NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    VoiceSegment* segment = (VoiceSegment*)[data objectAtIndex:indexPath.row];
    [self playAtTime:segment.timestamp withDuration:segment.duration];
    
    if(!recognizer) {
        
        //recognizer = [[SFSpeechRecognizer alloc] initWithLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
        recognizer = [[SFSpeechRecognizer alloc] init];
    }
    [SFSpeechRecognizer requestAuthorization:^(SFSpeechRecognizerAuthorizationStatus status) {
        switch (status) {
            case SFSpeechRecognizerAuthorizationStatusAuthorized:
                [self recongizeFrom:segment.timestamp withDuration:segment.duration];
                break;
            case SFSpeechRecognizerAuthorizationStatusNotDetermined:
                NSLog(@"用户还没同意");
                break;
            case SFSpeechRecognizerAuthorizationStatusRestricted:
                NSLog(@"设备不支持");
            case SFSpeechRecognizerAuthorizationStatusDenied:
                NSLog(@"没有权限");
            default:
                break;
        }
    }];
    return NULL;
}

- (void) recongizeFrom:(NSTimeInterval)time
           withDuration:(NSTimeInterval)duration {
    
    [self trimAudioFileURL:fileUrl from:time to:time+duration withHandle:^(NSURL * url) {
        
        SFSpeechURLRecognitionRequest* request = [[SFSpeechURLRecognitionRequest alloc] initWithURL:url];
        [recognizer recognitionTaskWithRequest:request resultHandler:^(SFSpeechRecognitionResult * _Nullable result, NSError * _Nullable error) {
            
            if (!result)
                NSLog(@"%@",[error localizedDescription]);
            else {
            
                NSLog(@"%@",result);
                speechLabel.text = result.bestTranscription.formattedString;
            }
            [[NSFileManager defaultManager] removeItemAtURL:url error:NULL];
        }];
    }];
}

- (void)playAtTime:(NSTimeInterval)time withDuration:(NSTimeInterval)duration {
    
    NSTimeInterval shortStartDelay = 0.01;
    
    player.currentTime = time + shortStartDelay;
    [player play];
    
    if(timer) {
    
        [timer invalidate];
        timer = nil;
    }
    timer = [NSTimer scheduledTimerWithTimeInterval:shortStartDelay + duration
                                                      target:self
                                                    selector:@selector(stopPlaying:)
                                                    userInfo:nil
                                                     repeats:NO];
}

- (void)stopPlaying:(NSTimer *)theTimer {
    [player pause];
    NSLog(@"stopPlaying");
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}

- (NSURL*)trimAudioFileURL:(NSURL*)audioFileInput from:(NSTimeInterval)vocalStartMarker to:(NSTimeInterval)vocalEndMarker withHandle:(void (^)(NSURL*))handler
{
    
    NSURL *audioFileOutput =[NSURL fileURLWithPath:[self pathForTemporaryFileWithPrefix:@"AudioForRecognition" andExt:@"m4a"]];
    
    if (!audioFileInput || !audioFileOutput)
    {
        return nil;
    }
    
    [[NSFileManager defaultManager] removeItemAtURL:audioFileOutput error:NULL];
    AVAsset *asset = [AVAsset assetWithURL:audioFileInput];
    
    AVAssetExportSession *exportSession = [AVAssetExportSession exportSessionWithAsset:asset
                                                                            presetName:AVAssetExportPresetAppleM4A];
    
    if (exportSession == nil)
    {
        return nil;
    }
    
    CMTime startTime = CMTimeMake((int)(floor(vocalStartMarker * 100)), 100);
    CMTime stopTime = CMTimeMake((int)(ceil(vocalEndMarker * 100)), 100);
    CMTimeRange exportTimeRange = CMTimeRangeFromTimeToTime(startTime, stopTime);
    
    exportSession.outputURL = audioFileOutput;
    exportSession.outputFileType = AVFileTypeAppleM4A;
    exportSession.timeRange = exportTimeRange;
    
    [exportSession exportAsynchronouslyWithCompletionHandler:^
     {
         if (AVAssetExportSessionStatusCompleted == exportSession.status)
         {
             NSLog(@"%@",audioFileOutput);
             handler(audioFileOutput);
         }
         else if (AVAssetExportSessionStatusFailed == exportSession.status)
         {
             // It failed...
         }
     }];
    return audioFileOutput;
}

- (NSString *)pathForTemporaryFileWithPrefix:(NSString *)prefix andExt:(NSString*)ExtName
{
    NSString *  result;
    CFUUIDRef   uuid;
    CFStringRef uuidStr;
    
    uuid = CFUUIDCreate(NULL);
    assert(uuid != NULL);
    
    uuidStr = CFUUIDCreateString(NULL, uuid);
    assert(uuidStr != NULL);
    
    result = [NSTemporaryDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"%@-%@.%@", prefix, uuidStr,ExtName]];
    assert(result != nil);
    
    CFRelease(uuidStr);
    CFRelease(uuid);
    
    return result;
}

@end
