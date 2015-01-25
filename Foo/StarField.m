//
//  StarField.m
//  Foo
//
//  Created by Oisin Hurley on 25/01/2015.
//  Copyright (c) 2015 me. All rights reserved.
//

#import "StarField.h"

@implementation StarField

-(id)init {
    if (self = [super init]) {
        __weak StarField *weakSelf = self;
        SKAction *update = [SKAction runBlock:^{
            if (arc4random_uniform(10) < 3) {
                [weakSelf launchStar];
            }
        }];
        
        SKAction *delay = [SKAction waitForDuration:0.01];
        SKAction *updateLoop = [SKAction sequence:@[delay, update]];
        [self runAction:[SKAction repeatActionForever:updateLoop]];
    }
    return self;
}

-(void)launchStar {
    CGFloat randX = arc4random_uniform(self.scene.size.width);
    CGFloat maxY = self.scene.size.height;
    CGPoint randomStart = CGPointMake(randX, maxY);
    
    SKSpriteNode *star = [SKSpriteNode spriteNodeWithImageNamed:@"shootingstar"];
    star.position = randomStart;
    star.size = CGSizeMake(4, 10);
    star.alpha = 0.1 + (arc4random_uniform(10) / 10.0f);
    [self addChild:star];
    
    CGFloat destY = 0 - self.scene.size.height - star.size.height;
    CGFloat duration = 0.4 + arc4random_uniform(20) / 10.0f;
    SKAction *move = [SKAction moveByX:0 y:destY duration:duration];
    SKAction *remove = [SKAction removeFromParent];
    [star runAction:[SKAction sequence:@[move, remove]]];
}
@end
