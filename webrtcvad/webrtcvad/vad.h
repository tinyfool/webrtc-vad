//
//  vad.h
//  webrtcvad
//
//  Created by Peiqiang Hao on 16/9/17.
//  Copyright © 2016年 Peiqiang Hao. All rights reserved.
//

#import <Foundation/Foundation.h>
#include "webrtc/common_audio/vad/include/webrtc_vad.h"

@interface vad : NSObject {
    
    VadInst *_vad;
}
-(int)isVoice:(const int16_t*)audio_frame sample_rate:(int)fs length:(int) frame_length;

@end
