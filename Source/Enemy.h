//
//  Enemy.h
//  FirstGame
//
//  Created by Hans Yadav on 7/3/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "CCNode.h"
@class MainScene;

@interface Enemy : CCNode

extern NSInteger const PINCUSHION_BONUS;

@property (nonatomic, weak) MainScene *mainScene;
@property (nonatomic, assign) NSInteger direction;
@property (nonatomic, assign) BOOL isShot;
@property (nonatomic, assign) NSInteger points;
@property (nonatomic, assign) BOOL isTutorialVersion;

- (void)displayPoints:(NSInteger)points;
- (CGPoint)setRandomPosition:(int)randomIndex;
- (void)spawnInTutorialLocation;
- (void)beginDissolve;

@end
