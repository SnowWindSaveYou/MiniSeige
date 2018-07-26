//
//  Gaming.m
//  MiniSeige
//
//  Created by JingyiWu on 2017/6/2.
//  Copyright © 2017年 JingyiWu. All rights reserved.
//

#import "Gaming.h"

@implementation Gaming{
    SKSpriteNode *Gplayer;
    UIAccelerationValue spX;
    UIAccelerationValue spY;
    NSMutableArray *Enemys;
    SKAudioNode* pong;
    int time;
    int score;
    int heath;
  
}
@synthesize lblTime;
@synthesize lblScore;

-(CMMotionManager*)game{
    if(_game == nil){
        _game = [[CMMotionManager alloc]init];
    }
    return _game;
}

- (void)didMoveToView:(SKView *)view {
    self.backgroundColor = [SKColor whiteColor];
    self.physicsWorld.gravity = CGVectorMake(0.0, 0.0);
    self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];
    self.physicsWorld.contactDelegate = self;
    
    pong = [[SKAudioNode alloc]initWithFileNamed:@"pong.mp3"];
    pong.autoplayLooped = false;
    [self addChild:pong];
    
    time = 30;
    score = 0;
    spX = 0;
    spY = 0;
    heath = 0;
    
    SKSpriteNode* Scoreimg = [SKSpriteNode spriteNodeWithImageNamed:@
                              "Star"];
    Scoreimg.position = CGPointMake(10, CGRectGetMaxY(self.frame)-25);
    Scoreimg.size = CGSizeMake(20, 20);
    [self addChild:Scoreimg];
    lblScore = [SKLabelNode labelNodeWithText:[NSString stringWithFormat:@"%i",score]];
    lblTime = [SKLabelNode labelNodeWithText:[NSString stringWithFormat:@"%i",time]];
    lblScore.fontName = @"Zapf Dingbats";
    lblTime.fontName = @"Zapf Dingbats";
    lblScore.fontSize = 25;
    lblTime.fontSize = 35;
    lblScore.fontColor = [UIColor colorWithRed:1 green:0.8 blue:0.4 alpha:1];
    lblTime.fontColor = [UIColor colorWithRed:1 green:0.73 blue:0.6 alpha:1];
    lblScore.position = CGPointMake(35, CGRectGetMaxY(self.frame)-35);
    lblTime.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMaxY(self.frame)-40);
    
    
    [self addChild:lblTime];
    [self addChild:lblScore];
    [self setplayer];

    [self setGameStart];

}
- (void)setGameStart{
    SKAction* actionwait = [SKAction waitForDuration:1];
    SKAction* actionaddenemy = [SKAction runBlock:^{
        if (time ==0) {
            [self GameOver:NO];
            
        }else{
            if (Enemys.count<30) {
                [self addEnemy];
                [self addEnemy];
            }
            time -=1;
            lblTime.text = [NSString stringWithFormat:@"%i",time];
        }
        
    }];
    [self runAction:[SKAction repeatActionForever:[SKAction sequence:@[actionaddenemy,actionwait]]]];
    
    if (!self.game.isGyroAvailable) {
        NSLog(@"acclerator false");
        return;
    }
    
    self.game.accelerometerUpdateInterval = 1.0/30.0;
    [self.game startAccelerometerUpdates];
    [self.game startAccelerometerUpdatesToQueue:[NSOperationQueue mainQueue] withHandler:^(CMAccelerometerData *accelerometerData, NSError *error) {
        if (error) return;
        
        CMAcceleration acceleration = accelerometerData.acceleration;
        spX += acceleration.x*10;
        spY += acceleration.y*10;
        
        if (spX>100) {
            spX=100;
        }else if (spX<-100){
            spX=-100;
        }
        if (spY>100) {
            spY=100;
        }else if (spY<-100){
            spY=-100;
        }
        
        double angle = 0.0;
        
        if (acceleration.y>0) {
            angle = atan(-spX/spY);
        }else if(acceleration.y==0 && acceleration.x>0){
            angle = -1.6;
        }else if(acceleration.y==0 && acceleration.x<0){
            angle = 1.6;
        }else if(acceleration.y==0 && acceleration.x==0){
            angle = Gplayer.zRotation;
        }else{
            angle = atan(-spX/spY)+3.2;
        }
        
        Gplayer.zRotation = angle;
        
        Gplayer.physicsBody.velocity = CGVectorMake(spX, spY);
        

    }];
}

-(void)setplayer{
    NSString* color = [self randomcolor];
    Gplayer = [SKSpriteNode spriteNodeWithImageNamed:[color stringByAppendingString:@"p"]];
    Gplayer.name = color;
    
    
    [Gplayer setScale:2.0];
    Gplayer.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    Gplayer.size = CGSizeMake(25, 30);
    Gplayer.physicsBody.categoryBitMask = 0x01;
    Gplayer.physicsBody.friction = 0;
    
    CGMutablePathRef triangle = CGPathCreateMutable();
    CGPathMoveToPoint(triangle, nil, 0, Gplayer.size.height/2);
    CGPathAddLineToPoint(triangle, nil, Gplayer.size.width/2, -Gplayer.size.height/2 );
    CGPathAddLineToPoint(triangle, nil, -Gplayer.size.width/2, -Gplayer.size.height/2 );
    CGPathCloseSubpath(triangle);
    
    Gplayer.physicsBody = [SKPhysicsBody bodyWithPolygonFromPath:triangle];
    [self addChild:Gplayer];
    CGPathRelease(triangle);


}
-(void)addEnemy{
    SKSpriteNode *enemy;
    NSString* color = [self randomcolor];
    enemy = [SKSpriteNode spriteNodeWithImageNamed:color];
    enemy.name = color;
    [enemy setScale:2.0];
    enemy.size = CGSizeMake(20, 20);
    
    CGSize winSize = self.size;
    int minY = enemy.size.height/2;
    int maxY = winSize.height - enemy.size.height/2;
    int rangeY = maxY- minY;
    int actualY = (arc4random()%rangeY)+minY;
    int minX = enemy.size.width/2;
    int maxX = winSize.width - enemy.size.width/2;
    int rangeX = maxX- minX;
    int actualX = (arc4random()%rangeX)+minX;
    
    
    int sourceposition = (arc4random() % 4);
    switch (sourceposition) {
        case 0:
            enemy.position = CGPointMake(winSize.width+10, actualY);
            break;
        case 1:
            enemy.position = CGPointMake(-10, actualY);
            break;
        case 2:
            enemy.position = CGPointMake(actualX, winSize.height+10);
            break;
        default:
            enemy.position = CGPointMake(actualX, -10);
            break;
    }
    
   // enemy.position = CGPointMake(actualX, winSize.height-10);
    
    enemy.physicsBody.dynamic = NO;
    enemy.physicsBody.restitution = 0.5;
    enemy.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:10];
    
    enemy.physicsBody.categoryBitMask = 0x02;
    enemy.physicsBody.contactTestBitMask = 0x01;
    enemy.physicsBody.collisionBitMask = 0x02;
    
    int minDuration = 9;
    int maxDuration = 15;
    int rangeDuration = maxDuration - minDuration;
    int actualDuration = (arc4random() %rangeDuration)+minDuration;

    SKAction* actionit = [SKAction runBlock:^{
        
        SKAction *actionmove = [SKAction moveTo:Gplayer.position duration:actualDuration];
        [enemy runAction:actionmove];
    }];
    SKAction* actionwait = [SKAction waitForDuration:3];
    [enemy runAction:[SKAction repeatActionForever:[SKAction sequence:@[actionit,actionwait]]]];
    
    [Enemys addObject:enemy];
    [self addChild:enemy];
    
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [pong runAction:[SKAction play]];
    
    [self addEnemy];
    [self changeplayercolor];
    
    
}
- (void)didBeginContact:(SKPhysicsContact *)contact{
    SKPhysicsBody *firstBody, *secondBody;
    
    if (contact.bodyA.categoryBitMask==0x02)
    {
        firstBody = contact.bodyA;
        secondBody = contact.bodyB;
    }else if(contact.bodyB.categoryBitMask==0x02)
    {
        firstBody = contact.bodyB;
        secondBody = contact.bodyA;
    }
    
    if (secondBody.node.name != NULL) {
        [self touchanime: contact.contactPoint];
        [self touchenemy:(SKSpriteNode*)firstBody.node];
    }
    
}
- (void)touchenemy:(SKSpriteNode *)enemy {
    [Enemys removeObject:enemy];
    [enemy removeFromParent];
    [pong runAction:[SKAction play]];
    if (enemy.name == Gplayer.name) {
        score +=3;
        lblScore.text = [NSString stringWithFormat:@"%i",score];
    }else{
        heath  +=25;
        SKSpriteNode* failimg = [SKSpriteNode spriteNodeWithImageNamed:@"X"];
        failimg.position = CGPointMake(CGRectGetMaxX(self.frame)-heath, CGRectGetMaxY(self.frame)-25);
        failimg.size = CGSizeMake(20, 20);
        [self addChild:failimg];
        if (heath> 125) {
            [self GameOver:YES];
            NSLog(@"you die");
        } 
    }
    [self changeplayercolor];

    
}
-(void)changeplayercolor{
    NSString *newcolor = [self randomcolor];
    SKTexture *newtexture = [SKTexture textureWithImageNamed:[newcolor stringByAppendingString:@"p"]];
    newtexture.filteringMode = SKTextureFilteringNearest;
    
    Gplayer.name = newcolor;
    Gplayer.texture = newtexture;
}

-(NSString*)randomcolor{
    int randomcolor = (arc4random() % 5);
    NSString *newcolor;
    switch (randomcolor) {
        case 0:
        {
            newcolor = @"red";
        }
            break;
        case 1:{
            newcolor = @"green";
        }
            break;
        case 2:{
            newcolor = @"purple";
        }
            break;
        case 3:{
            newcolor = @"yellow";
        }
            break;
        case 4:{
            newcolor = @"blue";
        }
            break;
        default:
            break;
    }
    return newcolor;
}
-(void)GameOver:(BOOL)die{
    //self.paused = YES;
    SKTransition *reveal = [SKTransition flipHorizontalWithDuration:0.5];
    SKScene * gameOverScene = [[Gameover alloc] initWithSize:self.size die:die myScore:score];
    [self.view presentScene:gameOverScene transition: reveal];
    
}
-(void)touchanime:(CGPoint)tposiion{
    SKTextureAtlas* tanime = [SKTextureAtlas atlasNamed:@"touchanime"];
    NSMutableArray* touching = [NSMutableArray arrayWithCapacity:9];
    for (int i=1; i<9; i++) {
        NSString *name=[NSString stringWithFormat:@"touch%d",i];
        SKTexture* texture = [tanime textureNamed:name];
        [touching addObject:texture];
    }
    SKSpriteNode* touchanime = [SKSpriteNode spriteNodeWithTexture:touching[0]];
    touchanime.position = tposiion;
    touchanime.size = CGSizeMake(150, 150);
    double randrido = (arc4random() % 3);
    touchanime.zRotation = randrido;
    
    SKAction *actiontouch = [SKAction animateWithTextures:touching timePerFrame:0.1];
    
    [self addChild:touchanime];
    SKAction* removeit = [SKAction runBlock:^{
        [touchanime removeFromParent];
    }];

    [touchanime runAction:[SKAction sequence:@[actiontouch,removeit]]];

    
}
@end
