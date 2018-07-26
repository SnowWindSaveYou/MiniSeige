//
//  Gaming.h
//  MiniSeige
//
//  Created by JingyiWu on 2017/6/2.
//  Copyright © 2017年 JingyiWu. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import <CoreMotion/CoreMotion.h>
#import "Gameover.h"
@interface Gaming : SKScene<UIAccelerometerDelegate,SKPhysicsContactDelegate>
@property(nonatomic) SKLabelNode* lblTime;
@property(nonatomic) SKLabelNode* lblScore;
@property(nonatomic,strong) CMMotionManager* game;

@end
