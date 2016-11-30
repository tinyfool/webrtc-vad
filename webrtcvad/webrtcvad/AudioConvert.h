//
//  AudioConvert.h
//  webrtcvad
//
//  Created by Peiqiang Hao on 2016/11/27.
//  Copyright © 2016年 Peiqiang Hao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>

typedef struct AudioConverterSettings
{
    AudioStreamBasicDescription inputFormat; // input file's data stream description
    AudioStreamBasicDescription outputFormat; // output file's data stream description
    
    AudioFileID					inputFile; // reference to your input file
    AudioFileID					outputFile; // reference to your output file
    
    UInt64						inputFilePacketIndex; // current packet index in input file
    UInt64						inputFilePacketCount; // total number of packts in input file
    UInt32						inputFilePacketMaxSize; // maximum size a packet in the input file can be
    AudioStreamPacketDescription *inputFilePacketDescriptions;
    void *sourceBuffer;
    
} AudioConverterSettings;


typedef void (*DealAudioFrameProc)(void *frame,UInt32 frameSize);

void CheckResult(OSStatus result, const char *operation);

void Convert(AudioConverterSettings *mySettings);

