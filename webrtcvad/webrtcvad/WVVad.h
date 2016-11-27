//
//  vad.h
//  webrtcvad
//
//  Created by Peiqiang Hao on 16/9/17.
//  Copyright © 2016年 Peiqiang Hao. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef struct WebRtcVadInst VadInst;

@interface WVVad : NSObject {
    
    VadInst *_vad;
}
-(int)isVoice:(const int16_t*)audio_frame sample_rate:(int)fs length:(int) frame_length;
@end
