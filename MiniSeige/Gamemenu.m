//
//  Gamemenu.m
//  ttttttttttt
//
//  Created by JingyiWu on 2017/6/1.
//  Copyright © 2017年 JingyiWu. All rights reserved.
//

#import "Gamemenu.h"

@implementation Gamemenu

-(id)initWithSize:(CGSize)size{
    
    if (self = [super initWithSize:size]) {
        self.backgroundColor = [UIColor whiteColor];
        
        SKSpriteNode* titimg = [SKSpriteNode spriteNodeWithImageNamed:@"title"];
        titimg.size = CGSizeMake(self.size.width, self.size.width);
        titimg.position = CGPointMake(self.size.width/2, self.size.height/2);
        [self addChild:titimg];
        
        SKLabelNode *label = [SKLabelNode labelNodeWithText:@"Tap to Start!"];
        label.fontSize = 40;
        label.fontColor = [UIColor colorWithRed:1 green:0.8 blue:0.4 alpha:1];
        label.position = CGPointMake(self.size.width/2, 50);
        [self addChild:label];
        
        
    
    }
    
    return self;
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

    SKView *skView = (SKView *)self.view;
    Gaming *scene = [[Gaming alloc]initWithSize:self.view.frame.size];
    scene.scaleMode = SKSceneScaleModeAspectFill;
    [skView presentScene:scene];
}

@end
