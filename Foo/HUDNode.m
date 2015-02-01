//
//  HUDNode.m
//  Foo
//
//  Created by Oisin Hurley on 01/02/2015.
//  Copyright (c) 2015 me. All rights reserved.
//

#import "HUDNode.h"

@interface HUDNode ()
@property (nonatomic, strong) NSNumberFormatter *scoreFormatter;
@property (nonatomic, strong) NSNumberFormatter *timeFormatter;
@end

@implementation HUDNode

-(instancetype)init {
    if (self == [super init]) {
        SKNode *scoreGroup = [SKNode node];
        scoreGroup.name = @"scoreGroup";
        
        SKLabelNode *scoreTitle = [self makeTitleNodeNamed:nil on:@"left" withText:@"SCORE"];
        [scoreGroup addChild:scoreTitle];
        
        SKLabelNode *scoreValue = [self makeValueNodeNamed:@"scoreValue" on:@"left" withText:@"0"];
        [scoreGroup addChild:scoreValue];
        
        [self addChild:scoreGroup];
        
        SKNode *elapsedGroup = [SKNode node];
        elapsedGroup.name = @"elapsedGroup";
        
        SKLabelNode *elapsedTitle = [self makeTitleNodeNamed:nil on:@"right" withText:@"TIME"];
        [elapsedGroup addChild:elapsedTitle];
        
        SKLabelNode *elapsedValue = [self makeValueNodeNamed:@"elapsedValue"    on:@"right" withText:@"0.0s"];
        [elapsedGroup addChild:elapsedValue];
        
        [self addChild:elapsedGroup];
        
        self.scoreFormatter = [NSNumberFormatter new];
        self.scoreFormatter.numberStyle = NSNumberFormatterDecimalStyle;
        
        self.timeFormatter = [NSNumberFormatter new];
        self.timeFormatter.numberStyle = NSNumberFormatterDecimalStyle;
        self.timeFormatter.minimumFractionDigits = 1;
        self.timeFormatter.maximumFractionDigits = 1;
    }
    return self;
}

-(SKLabelNode*)makeTitleNodeNamed:(NSString*)name on:(NSString*)side withText:(NSString*)text{
    SKLabelNode *label = [SKLabelNode labelNodeWithFontNamed:@"AvenirNext-Medium"];
    label.fontSize = 12;
    label.fontColor = [SKColor whiteColor];
    if ([side caseInsensitiveCompare:@"left"] == NSOrderedSame) {
        label.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft;
    } else {
        label.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeRight;
    }
    label.verticalAlignmentMode = SKLabelVerticalAlignmentModeBottom;
    label.text = text;
    label.position = CGPointMake(0.0, 4.0);
    if (name) {
        label.name = name;
    }
    return label;
}

-(SKLabelNode*)makeValueNodeNamed:(NSString*)name on:(NSString*)side withText:(NSString*)text{
    SKLabelNode *label = [SKLabelNode labelNodeWithFontNamed:@"AvenirNext-Bold"];
    label.fontSize = 20;
    label.fontColor = [SKColor whiteColor];
    if ([side caseInsensitiveCompare:@"left"] == NSOrderedSame) {
        label.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft;
    } else {
        label.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeRight;
    }
    label.verticalAlignmentMode = SKLabelVerticalAlignmentModeTop;
    label.text = text;
    label.position = CGPointMake(0.0, -4.0);
    if (name) {
        label.name = name;
    }
    return label;
}

- (void)layoutForScene {
    NSAssert(self.scene, @"Cannot be called unless added to a scene");
    CGSize sceneSize = self.scene.size;
    CGSize groupSize = CGSizeZero;
    SKNode *scoreGroup = [self childNodeWithName:@"scoreGroup"];
    groupSize = [scoreGroup calculateAccumulatedFrame].size;
    scoreGroup.position = CGPointMake(0 - sceneSize.width/2 + 20, sceneSize.height/2 - groupSize.height);
    SKNode *elapsedGroup = [self childNodeWithName:@"elapsedGroup"];
    groupSize = [elapsedGroup calculateAccumulatedFrame].size;
    elapsedGroup.position = CGPointMake(sceneSize.width/2 - 20, sceneSize.height/2 - groupSize.height);
}

-(void)addPoints:(NSInteger)points {
    self.score += points;
    
    SKLabelNode *scoreValue = (SKLabelNode*)[self childNodeWithName:@"scoreGroup/scoreValue"];
    scoreValue.text = [NSString stringWithFormat:@"%@", [self.scoreFormatter stringFromNumber:@(self.score)]];
    
    SKAction *scale = [SKAction scaleTo:1.1 duration:0.02];
    SKAction *shrink = [SKAction scaleTo:1.0 duration:0.07];
    SKAction *all = [SKAction sequence:@[scale, shrink]];
    [scoreValue runAction:all];
}

-(void)zero {
    self.score = 0;
    self.elapsedTime = 0;
    SKLabelNode *scoreValue = (SKLabelNode*)[self childNodeWithName:@"scoreGroup/scoreValue"];
    scoreValue.text = @"0";
    SKLabelNode *elapsedValue = (SKLabelNode*)[self childNodeWithName:@"elapsedGroup/elapsedValue"];
    elapsedValue.text = @"0.0s";
}

-(void)startGame {
    [self zero];
    NSTimeInterval startTime = [NSDate timeIntervalSinceReferenceDate];
    SKLabelNode *elapsedValue =
    (SKLabelNode *)[self childNodeWithName:@"elapsedGroup/elapsedValue"];
    
    __weak HUDNode *weakSelf = self;
    SKAction *update = [SKAction runBlock:^{
        NSTimeInterval now = [NSDate timeIntervalSinceReferenceDate];
        NSTimeInterval elapsed = now - startTime;
        weakSelf.elapsedTime = elapsed;
        elapsedValue.text = [NSString stringWithFormat:@"%@s", [weakSelf.timeFormatter stringFromNumber:@(elapsed)]];
    }];
    
    SKAction *delay = [SKAction waitForDuration:0.05];
    SKAction *updateAndDelay = [SKAction sequence:@[update, delay]];
    SKAction *timer = [SKAction repeatActionForever:updateAndDelay];
    [self runAction:timer withKey:@"elapsedGameTimer"];
}

-(void)endGame {
    [self removeActionForKey:@"elapsedGameTimer"];
}

@end
