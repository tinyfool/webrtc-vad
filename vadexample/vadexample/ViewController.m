//
//  ViewController.m
//  vadexample
//
//  Created by Peiqiang Hao on 16/9/17.
//  Copyright © 2016年 Peiqiang Hao. All rights reserved.
//

#import "ViewController.h"
#import <AudioToolbox/AudioToolbox.h>
#import <webrtcvad/webrtcvad.h>
@interface ViewController ()
{

}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}


+(WVad *)shardVad {

    static WVad *_vad = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _vad = [[WVad alloc] init];
    });
    return _vad;
}


- (IBAction)readaudio:(id)sender {

    AudioFileStreamID _audioFileStreamID;
    OSStatus status = AudioFileStreamOpen(NULL,         MyAudioFileStreamPropertyListenerProc,
                                          MyAudioFileStreamPacketsCallBack,
                                          kAudioFileMP3Type,
                                          &_audioFileStreamID);
    if(status!=noErr){
    
    }
    
    NSURL *fileUrl;
    fileUrl = [[NSBundle mainBundle] URLForResource:@"t" withExtension:@"mp3"];
//    fileUrl = [[NSBundle mainBundle] URLForResource:@"test-16000" withExtension:@"wav"];
//    fileUrl = [[NSBundle mainBundle] URLForResource:@"test" withExtension:@"aiff"];
    
    long buffsize = 4096;
    uint8_t* buffer = (uint8_t*) malloc (sizeof(uint8_t)*buffsize);
    
    long size;
    NSInputStream* is = [NSInputStream inputStreamWithURL:fileUrl];
    [is open];
    while((size = [is read:buffer maxLength:buffsize])>0) {
    
        OSStatus status =
        AudioFileStreamParseBytes(_audioFileStreamID, (UInt32)buffsize,buffer , kAudioFileStreamParseFlag_Discontinuity);
        NSLog(@"%ld,%d",size,(int)status);
    }
    [is close];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

AudioStreamBasicDescription asbd;

static void MyAudioFileStreamPropertyListenerProc (
                                                   void *							inClientData,
                                                   AudioFileStreamID				inAudioFileStream,
                                                   AudioFileStreamPropertyID		inPropertyID,
                                                   AudioFileStreamPropertyFlags *	ioFlags) {

    
    UInt32 asbdSize = sizeof(asbd);
    
    // get the stream format.
    OSStatus err = AudioFileStreamGetProperty(inAudioFileStream, kAudioFileStreamProperty_DataFormat, &asbdSize, &asbd);
    if (err != noErr)
    {
        return;
    }
    Float64 sampleRate = asbd.mSampleRate;
    NSLog(@"%d",(UInt32)sampleRate);
}



static void MyAudioFileStreamPacketsCallBack(void *inClientData,
                                             UInt32 inNumberBytes,
                                             UInt32 inNumberPackets,
                                             const void *inInputData,
                                             AudioStreamPacketDescription  *inPacketDescriptions)
{
    //处理discontinuous..
    
    if (inNumberBytes == 0 || inNumberPackets == 0)
    {
        return;
    }
    
    BOOL deletePackDesc = NO;
    if (inPacketDescriptions == NULL)
    {
        //如果packetDescriptioins不存在，就按照CBR处理，平均每一帧的数据后生成packetDescriptioins
        deletePackDesc = YES;
        UInt32 packetSize = inNumberBytes / inNumberPackets;
        inPacketDescriptions = (AudioStreamPacketDescription *)malloc(sizeof(AudioStreamPacketDescription) * inNumberPackets);
        
        for (int i = 0; i < inNumberPackets; i++)
        {
            UInt32 packetOffset = packetSize * i;
            inPacketDescriptions[i].mStartOffset = packetOffset;
            inPacketDescriptions[i].mVariableFramesInPacket = 0;
            if (i == inNumberPackets - 1)
            {
                inPacketDescriptions[i].mDataByteSize = inNumberBytes - packetOffset;
            }
            else
            {
                inPacketDescriptions[i].mDataByteSize = packetSize;
            }
        }
    }
    
    for (int i = 0; i < inNumberPackets; ++i)
    {
        SInt64 packetOffset = inPacketDescriptions[i].mStartOffset;
        UInt32 packetSize   = inPacketDescriptions[i].mDataByteSize;
        void *buffer = malloc(packetSize);
        memcpy(buffer, (const char*)inInputData + packetOffset, packetSize);
        
        putInVoiceBuffer(buffer, packetSize);
        
    }
    
    if (deletePackDesc)
    {
        free(inPacketDescriptions);
    } 
} 

void putInVoiceBuffer(void *frame,UInt32 frameSize) {

    
    const UInt32 voiceBufsize = 160;
    static char* voiceBuffer = NULL;
    static UInt32 pos = 0;
    
    if (voiceBuffer == NULL) {
        
        voiceBuffer = malloc(voiceBufsize);
    }
    
    UInt32 framePos = 0;
    
    while(framePos<frameSize) {
    
        UInt32 size = frameSize-framePos;
        if(pos+size>voiceBufsize) {
            
            size = voiceBufsize - pos;
        }
        
        memcpy(voiceBuffer+pos, frame+framePos, size);
        pos += size;
        framePos += size;
        if(pos >= voiceBufsize) {
            
            WVad* vad = [ViewController shardVad];
            int voice = [vad isVoice:(const int16_t*)voiceBuffer sample_rate:16000 length:voiceBufsize];
            NSLog(@"is voice %d",voice);
            pos = 0;
        }
    }
}

@end
