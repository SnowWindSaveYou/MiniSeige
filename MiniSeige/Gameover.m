//
//  Gameover.m
//  ttttttttttt
//
//  Created by JingyiWu on 2017/6/1.
//  Copyright © 2017年 JingyiWu. All rights reserved.
//

#import "Gameover.h"
#import "Gaming.h"

@implementation Gameover
-(id)initWithSize:(CGSize)size die:(BOOL)die myScore:(int)myscore{
    
    if (self = [super initWithSize:size]) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        SKLabelNode *lblScore = [SKLabelNode labelNodeWithText: [NSString stringWithFormat:@"%i",myscore]];
        lblScore.fontSize = 250;
        //lblScore.fontColor = [SKColor blackColor];
        lblScore.position = CGPointMake(self.size.width/2, self.size.height - self.size.height/3);
        
        
        
        SKLabelNode *label = [SKLabelNode labelNodeWithFontNamed:@"Zapf Dingbats"];
        label.position = CGPointMake(self.size.width/2, 50);
        label.fontSize = 60;
       // label.fontColor = [SKColor blackColor];
        if (die) {
            label.text = @"_(:з」∠)_";
            label.fontColor = [SKColor colorWithRed:1 green:0.73 blue:0.6 alpha:1];
            lblScore.fontColor = [SKColor colorWithRed:1 green:0.73 blue:0.6 alpha:1];

        }else{
            label.text = @"Survive!";
            label.fontColor = [SKColor colorWithRed:0.92 green:1 blue:0.62 alpha:1];
            lblScore.fontColor = [SKColor colorWithRed:1 green:0.73 blue:0.6 alpha:1];
        }

        SKAudioNode* high = [[SKAudioNode alloc]initWithFileNamed:@"high.mp3"];
        high.autoplayLooped = NO;
        
        
        [self addChild:high];
        [self addChild:label];
        [self addChild:lblScore];
        [high runAction:[SKAction play]];

        [self runAction:[SKAction sequence:@[
                                             
                                             [SKAction waitForDuration:3.0],[SKAction runBlock:^{
            SKTransition *reveal = [SKTransition flipHorizontalWithDuration:0.1];
            SKScene * gamemenu = [[Gamemenu alloc] initWithSize:self.size];
            [self.view presentScene:gamemenu transition: reveal];
            
            
        }]]]];
        
    }
    
    
    
    return self;
}

@end
