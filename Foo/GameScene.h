//
//  GameScene.h
//  Foo
//

//  Copyright (c) 2015 me. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface GameScene : SKScene

@property (nonatomic, weak) UITouch *shipTouch;
@property (nonatomic) CFTimeInterval lastUpdateTime;
@property (nonatomic) CFTimeInterval lastShotFiredTime;
@property (nonatomic, strong) UITapGestureRecognizer *tapRecognizer;

@property (nonatomic, strong) SKAction *shootSound;
@property (nonatomic, strong) SKAction *shipExplodeSound;
@property (nonatomic, strong) SKAction *obstacleExplodeSound;

@end
