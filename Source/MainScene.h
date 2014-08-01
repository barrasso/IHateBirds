//
//  MainScene.h
//  PROJECTNAME
//
//  Created by Viktor on 10/10/13.
//  Copyright (c) 2013 Apportable. All rights reserved.
//

#import "CCNode.h"

@interface MainScene : CCNode <CCPhysicsCollisionDelegate>

@property (nonatomic, assign) int currentEnemyCount;
@property (nonatomic, assign) CGPoint explosionPoint;
@property (nonatomic, assign) BOOL isGameOver;
@property (nonatomic, assign) NSInteger score;
@property (nonatomic, assign) float pps; // points per second

- (void)gameOver;
- (void)triggerExplosion;

@end
