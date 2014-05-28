//
//  soundManager.h
//  Ollie
//
//  Created by Samar's Mac Mini on 3/12/13.
//  Copyright (c) 2013 ClickLabs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <AVFoundation/AVFoundation.h>

@interface soundManager : NSObject<AVAudioPlayerDelegate>
{
    NSString* BS_path_blue3;
    AVAudioPlayer *BS_player_blue3;
}
+(soundManager *)shared;

-(void) buttonSound;

@end
