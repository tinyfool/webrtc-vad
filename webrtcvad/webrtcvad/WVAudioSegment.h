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
    
    char* voiceBuffer;
    UInt32 pos;
    int n;
}

- (NSArray*)segmentAudio:(NSURL *) fileURL;

@end
