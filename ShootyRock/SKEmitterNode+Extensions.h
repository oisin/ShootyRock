//
//  SKEmitterNode+Extensions.h
//  Foo
//
//  Created by Oisin Hurley on 02/02/2015.
//  Copyright (c) 2015 me. All rights reserved.
//

#ifndef Foo_SKEmitterNode_Extensions_h
#define Foo_SKEmitterNode_Extensions_h

#import <SpriteKit/SpriteKit.h>

@interface SKEmitterNode (Extensions)

+(SKEmitterNode*)foo_nodeWithFile:(NSString *)filename;
-(void)foo_dieOutInDuration:(NSTimeInterval)duration;
@end
#endif
