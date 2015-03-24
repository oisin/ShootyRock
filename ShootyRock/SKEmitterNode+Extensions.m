//
//  SKEmitterNode+SKEmitterNode_Extensions.m
//  Foo
//
//  Created by Oisin Hurley on 02/02/2015.
//  Copyright (c) 2015 me. All rights reserved.
//

#import "SKEmitterNode+Extensions.h"

@implementation SKEmitterNode (Extensions)

+(SKEmitterNode*)foo_nodeWithFile:(NSString *)filename {
    NSString *basename = [filename stringByDeletingPathExtension];
    NSString *extension = [filename pathExtension];
    if ([extension length] == 0) {
        extension = @"sks";
    }
    NSString *path = [[NSBundle mainBundle] pathForResource:basename ofType:@"sks"];
    SKEmitterNode *node = (id)[NSKeyedUnarchiver unarchiveObjectWithFile:path];
    return node;
}

-(void)foo_dieOutInDuration:(NSTimeInterval)duration {
    SKAction *firstWait = [SKAction waitForDuration:duration];
    __weak SKEmitterNode *weakSelf = self;
    
    SKAction *stop = [SKAction runBlock:^{
        weakSelf.particleBirthRate = 0;
    }];
    
    SKAction *secondWait = [SKAction waitForDuration:self.particleLifetime];
    SKAction *remove = [SKAction removeFromParent];
    SKAction *dieOut = [SKAction sequence:@[firstWait, stop, secondWait, remove]];
    [self runAction:dieOut];
}

@end
