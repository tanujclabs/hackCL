//
//  soundManager.m
//  testOllie2
//
//  Created by Samar's Mac Mini on 24/01/13.
//  Copyright (c) 2013 contact@click-labs.com. All rights reserved.
//




#import "soundManager.h"
static soundManager *dataManager;
@implementation soundManager

+(soundManager *) shared{
    if(!dataManager){
        dataManager = [[soundManager alloc] init];
    }
    return dataManager;
}
-(void)buttonSound
{
    BS_path_blue3=[[NSBundle mainBundle]pathForResource:@"click2" ofType:@"mp3"];

BS_player_blue3 =[[AVAudioPlayer alloc]initWithContentsOfURL:[NSURL fileURLWithPath:BS_path_blue3]  error:NULL];
BS_player_blue3.delegate=self;
[BS_player_blue3 prepareToPlay];
      
          [BS_player_blue3 play];

}

@end
