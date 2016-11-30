//
//  WVAudioSegment.h
//  webrtcvad
//
//  Created by Peiqiang Hao on 2016/11/27.
//  Copyright © 2016年 Peiqiang Hao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WVVad.h"

@interface WVAudioSegment : NSObject

- (NSArray*)segmentAudio:(NSURL *) fileURL;

@end
