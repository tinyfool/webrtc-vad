//
//  vad.m
//  webrtcvad
//
//  Created by Peiqiang Hao on 16/9/17.
//  Copyright © 2016年 Peiqiang Hao. All rights reserved.
//

#import "WVad.h"
#include "webrtc/common_audio/vad/include/webrtc_vad.h"

@implementation WVad

-(id)init {
    
    self = [super init];
    if(self) {
        
        WebRtcVad_Create(&_vad);
        WebRtcVad_Init(_vad);
    
    }
    return self;
}

-(int)isVoice:(const int16_t*)audio_frame sample_rate:(int)fs length:(int) frame_length {

    return WebRtcVad_Process(_vad,fs,audio_frame,frame_length);
}
@end
