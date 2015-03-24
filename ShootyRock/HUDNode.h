//
//  HUDNode.h
//  Foo
//
//  Created by Oisin Hurley on 01/02/2015.
//  Copyright (c) 2015 me. All rights reserved.
//

#ifndef Foo_HUDNode_h
#define Foo_HUDNode_h

#import <SpriteKit/SpriteKit.h>

@interface HUDNode : SKNode

@property (nonatomic) NSTimeInterval elapsedTime;
@property (nonatomic) NSInteger score;

-(void)layoutForScene;

-(void)addPoints:(NSInteger)points;
-(void)startGame;
-(void)endGame;

@end

#endif
