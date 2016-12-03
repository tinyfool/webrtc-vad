//
//  WVAudioSegment.h
//  webrtcvad
//
//  Created by Peiqiang Hao on 2016/11/27.
//  Copyright © 2016年 Peiqiang Hao. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WVVad;

@interface WVAudioSegment : NSObject
{

    WVVad* vad;
}
- (NSArray*)segmentAudio:(NSURL *) fileURL;
@end
@interface VoiceSegment : NSObject
{
    int isVoice;
    NSTimeInterval timestamp;
    NSTimeInterval duration;
}
@property (nonatomic) int isVoice;
@property (nonatomic) NSTimeInterval timestamp;
@property (nonatomic) NSTimeInterval duration;
@end
