//
//  webrtcvadTests.m
//  webrtcvadTests
//
//  Created by Peiqiang Hao on 16/9/17.
//  Copyright © 2016年 Peiqiang Hao. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "WVad.h"
@interface webrtcvadTests : XCTestCase{
    WVad* vad;
}
@end

@implementation webrtcvadTests

- (void)setUp {
    [super setUp];
    vad = [[WVad alloc] init];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testForAllzero {
    
    const UInt32 sample_rate = 16000;
    const UInt32 duration = 10;
    const UInt32 voiceBufsize = sample_rate*duration/1000;
    static int16_t* voiceBuffer = NULL;
    voiceBuffer = malloc(voiceBufsize*sizeof(int16_t));
    memset(voiceBuffer, 0, voiceBufsize*sizeof(int16_t));
    int voice = [vad isVoice:voiceBuffer sample_rate:sample_rate length:voiceBufsize];
    XCTAssertEqual(voice,0,"This is must not be voice!!!");
}

-(void)testPythonFrame0 {

    const UInt32 sample_rate = 16000;
    const UInt32 duration = 10;
    const UInt32 voiceBufsize = sample_rate*duration/1000;
    char voiceBuffer[] = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
    int voice = [vad isVoice:(const int16_t*)voiceBuffer sample_rate:sample_rate length:voiceBufsize];
    XCTAssertEqual(voice,0,"This is must not be voice!!!");
}


-(void)testPythonFrame3 {
    
    const UInt32 sample_rate = 16000;
    const UInt32 duration = 10;
    const UInt32 voiceBufsize = sample_rate*duration/1000;
    char voiceBuffer[] = {'\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x01', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x01', '\x00', '\x01', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\xff', '\xff', '\xff', '\xff', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x01', '\x00', '\x00', '\x00', '\xff', '\xff', '\xff', '\xff', '\xff', '\xff', '\xff', '\xff', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\xff', '\xff', '\xff', '\xff', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x01', '\x00', '\x01', '\x00', '\x00', '\x00', '\x00', '\x00', '\xff', '\xff', '\xff', '\xff', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\xff', '\xff', '\x00', '\x00', '\x00', '\x00', '\x01', '\x00', '\x01', '\x00', '\x01', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\xff', '\xff', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x01', '\x00', '\x01', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x01', '\x00', '\x01', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x01', '\x00', '\x01', '\x00', '\x01', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x01', '\x00', '\x01', '\x00', '\x00', '\x00', '\x00', '\x00', '\xff', '\xff', '\xff', '\xff', '\x00', '\x00', '\x01', '\x00', '\x01', '\x00', '\x01', '\x00', '\x01', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x01', '\x00', '\x00', '\x00', '\x00', '\x00', '\xff', '\xff', '\xfe', '\xff', '\xff', '\xff', '\xff', '\xff', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\xff', '\xff', '\xff', '\xff'};
    int voice = [vad isVoice:(const int16_t*)voiceBuffer sample_rate:sample_rate length:voiceBufsize];
    XCTAssertEqual(voice,1,"This is must not be voice!!!");
}

@end
