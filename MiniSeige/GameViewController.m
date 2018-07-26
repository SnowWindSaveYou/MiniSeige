//
//  GameViewController.m
//  MiniSeige
//
//  Created by JingyiWu on 2017/6/2.
//  Copyright © 2017年 JingyiWu. All rights reserved.
//

#import "GameViewController.h"
#import "GameScene.h"

@implementation GameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    SKView *skView = (SKView *)self.view;
    CGSize winsize = skView.bounds.size;
    Gamemenu *scene = [[Gamemenu alloc]initWithSize:CGSizeMake(winsize.width, winsize.height)];
    scene.scaleMode = SKSceneScaleModeAspectFill;
    
    [skView presentScene:scene];
    [self Backgroundmusic];
    skView.showsFPS = YES;
    skView.showsNodeCount = YES;
}

- (BOOL)shouldAutorotate {
    return YES;
}


- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

-(void)Backgroundmusic{
    NSURL* bgmurl = [[NSBundle mainBundle]URLForResource:@"BGM.mp3" withExtension:nil];
    self.bgm = [[AVAudioPlayer alloc]initWithContentsOfURL:bgmurl error:nil];
    self.bgm.numberOfLoops = -1;
    self.bgm.volume = 0.7;
    [self.bgm prepareToPlay];
    [self.bgm play];
}

@end
