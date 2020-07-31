//
//  ViewController.m
//  osmo
//
//  Created by Lijhara Ashish on 05/06/20.
//  Copyright © 2020 Hyper Reality. All rights reserved.
//

#import "ViewController.h"
#import "SVGKit/SVGKit.h"

@interface ViewController ()
@property(nonatomic, strong) AVAudioPlayerNode *playerNode;
@property(nonatomic, strong) AVAudioPCMBuffer *audioPCMBuffer;
@end
@implementation ViewController
@synthesize audioEngine;
@synthesize playerNode;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGSize _size = self.view.bounds.size;
    UIScrollView *scroll = [[UIScrollView alloc]initWithFrame:self.view.bounds];
    scroll.contentSize = CGSizeMake(_size.width*12, _size.height);
    
    
    UIImageView* iv = [[UIImageView alloc] initWithImage: [UIImage imageNamed:@"scroll.jpg"]];
    iv.frame = CGRectMake(0,0,scroll.contentSize.width,  scroll.contentSize.height);
    [scroll addSubview:iv];
    [self.view addSubview:scroll];
    self.view.backgroundColor = [UIColor colorWithRed:0.71 green:0.81 blue:0.83 alpha:1];
    self.audioEngine = [AVAudioEngine new];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Baseline1" ofType:@"mp3"];
    AVAudioFile *audioFile = [[AVAudioFile alloc]initForReading:[NSURL fileURLWithPath:path] error:nil];
    AVAudioFormat *audioFormat= audioFile.processingFormat;
    AVAudioFrameCount length = (AVAudioFrameCount)audioFile.length;
    NSLog(@"%d", length);
    self.audioPCMBuffer = [[AVAudioPCMBuffer alloc]initWithPCMFormat:audioFormat frameCapacity:length];
    [audioFile readIntoBuffer:self.audioPCMBuffer error:nil];
    self.playerNode = [[AVAudioPlayerNode alloc]init];
    [self.audioEngine attachNode:playerNode];
    AVAudioMixerNode * mixerNode = [self.audioEngine mainMixerNode];
    [self.audioEngine connect:self.playerNode to:mixerNode format:audioFormat];
    NSError *err;
    [self.audioEngine startAndReturnError:&err];
    [self.playerNode scheduleBuffer:self.audioPCMBuffer atTime:nil options:AVAudioPlayerNodeBufferLoops completionHandler:nil];
    [self.playerNode play];
}
@end
