//
//  vad.m
//  webrtcvad
//
//  Created by Peiqiang Hao on 16/9/17.
//  Copyright © 2016年 Peiqiang Hao. All rights reserved.
//

#import "WVVad.h"
#include "webrtc/common_audio/vad/include/webrtc_vad.h"

@implementation WVVad

-(id)init {
    
    self = [super init];
    if(self) {
        
        WebRtcVad_Create(&_vad);
        WebRtcVad_Init(_vad);
        WebRtcVad_set_mode(_vad, 0);
    }
    return self;
}

-(int)isVoice:(const int16_t*)audio_frame sample_rate:(int)fs length:(int) frame_length {

    VadInst *_vad1;
    WebRtcVad_Create(&_vad1);
    WebRtcVad_Init(_vad1);
    WebRtcVad_set_mode(_vad1, 0);

    int voice = WebRtcVad_Process(_vad1,fs,audio_frame,frame_length);
    WebRtcVad_Free(_vad1);
    return voice;
}
@end
