//
//  Dart.h
//  FirstGame
//
//  Created by Hans Yadav on 7/2/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "CCNode.h"
@class MainScene;

@interface Dart : CCNode

extern NSInteger const MULTISHOT_BONUS;

@property (nonatomic, strong) CCMotionStreak *streak;
@property (nonatomic, weak) MainScene *mainScene;
@property (nonatomic, assign) BOOL hasHitEnemy;
@property (nonatomic, strong) CCParticleSystem *particles;
@property (nonatomic, strong) CCNode *particles2;

@end
