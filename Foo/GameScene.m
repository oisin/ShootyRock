//
//  GameScene.m
//  Foo
//
//  Created by Oisin Hurley on 24/01/2015.
//  Copyright (c) 2015 me. All rights reserved.
//

#import "GameScene.h"
#import "GameOver.h"
@implementation GameScene

-(void)didMoveToView:(SKView *)view {
    self.backgroundColor = [SKColor blackColor];
    [self addSpaceship];
}

-(void)addSpaceship {
    SKSpriteNode *ship = [SKSpriteNode spriteNodeWithImageNamed:@"Spaceship"];
    ship.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    ship.size = CGSizeMake(40, 40);
    ship.name = @"ship";
    [self addChild:ship];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    self.shipTouch = [touches anyObject];
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */

    if (self.lastUpdateTime == 0) {
        self.lastUpdateTime = currentTime;
    }
    
    CFTimeInterval timeDelta = currentTime - self.lastUpdateTime;

    if (self.shipTouch) {
        [self moveShipTowardPoint:[self.shipTouch locationInNode:self]
                      byTimeDelta:timeDelta];
        
        if (currentTime - self.lastShotFiredTime > 0.5) {
            [self shoot];
            self.lastShotFiredTime = currentTime;
        }
    }
    
    if (arc4random_uniform(1000) <= 15) {
        [self dropAsteroid];
    }
    
    [self checkCollisions];
    
    self.lastUpdateTime = currentTime;
}

-(void)endGame {
    self.tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped)];
    [self.view addGestureRecognizer:self.tapRecognizer];
    GameOver *go = [GameOver node];
    go.position = CGPointMake(self.size.width / 2, self.size.height / 2);
    go.name = @"gameover";
    [self addChild:go];
}

-(void)tapped {
    [self.view removeGestureRecognizer:self.tapRecognizer];
    self.tapRecognizer = nil;
    [[self childNodeWithName:@"gameover"] removeFromParent];
    [self addSpaceship];
}

-(void)checkCollisions {
    SKNode *ship = [self childNodeWithName:@"ship"];
    [self enumerateChildNodesWithName:@"obstacle" usingBlock:^(SKNode *obstacle, BOOL *stop) {
        if ([ship intersectsNode:obstacle]) {
            self.shipTouch = nil;
            [ship removeFromParent];
            [obstacle removeFromParent];
            [self endGame];
        }
    }];
}

-(void)dropAsteroid {
    CGFloat sideSize = 15 + arc4random_uniform(30);
    CGFloat maxX = self.size.width;
    CGFloat quarterX = maxX / 4;
    CGFloat startX = arc4random_uniform(maxX + (quarterX * 2)) - quarterX;
    CGFloat startY = self.size.height + sideSize;
    CGFloat endX = arc4random_uniform(maxX);
    CGFloat endY = 0 - sideSize;
    
    SKSpriteNode *asteroid = [SKSpriteNode spriteNodeWithImageNamed:@"asteroid"];
    asteroid.size = CGSizeMake(sideSize, sideSize);
    asteroid.position = CGPointMake(startX, startY);
    asteroid.name = @"obstacle";
    [self addChild:asteroid];
    
    SKAction *move = [SKAction moveTo:CGPointMake(endX, endY) duration:3 + arc4random_uniform(4)];
    SKAction *remove = [SKAction removeFromParent];
    SKAction *travelAndRemove = [SKAction sequence:@[move, remove]];
    
    SKAction *spin = [SKAction rotateByAngle:3 duration:1 + arc4random_uniform(2)];
    SKAction *spinForever = [SKAction repeatActionForever:spin];
    
    SKAction *all = [SKAction group:@[spinForever, travelAndRemove]];
    [asteroid runAction:all];
}

-(void)shoot {
    SKNode *ship = [self childNodeWithName:@"ship"];
    
    SKSpriteNode *photon = [SKSpriteNode spriteNodeWithImageNamed:@"photon"];
    photon.name = @"photon";
    photon.position = ship.position;
    [self addChild:photon];
    
    SKAction *fly = [SKAction moveByX:0 y:self.size.height + photon.size.height duration:0.5];
    SKAction *remove = [SKAction removeFromParent];
    SKAction *fireAndRemove = [SKAction sequence:@[fly, remove]];
    [photon runAction:fireAndRemove];
}

-(void)moveShipTowardPoint:(CGPoint)point byTimeDelta:(CFTimeInterval)timeDelta {
    CGFloat shipSpeed = 130;
    SKNode *ship = [self childNodeWithName:@"ship"];
    CGFloat distanceLeft = sqrt(pow(ship.position.x - point.x, 2) + pow(ship.position.y - point.y, 2));
    
    if (distanceLeft > 4) {
        CGFloat distanceToTravel = timeDelta * shipSpeed;
        CGFloat angle = atan2(point.y - ship.position.y,
                              point.x - ship.position.x);
        CGFloat yOffset = distanceToTravel * sin(angle);
        CGFloat xOffset = distanceToTravel * cos(angle);
        ship.position = CGPointMake(ship.position.x + xOffset, ship.position.y + yOffset);
    }
}
@end
