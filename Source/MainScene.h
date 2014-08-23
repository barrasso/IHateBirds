//
//  MainScene.h
//  PROJECTNAME
//
//  Created by Viktor on 10/10/13.
//  Copyright (c) 2013 Apportable. All rights reserved.
//

#import "CCNode.h"

@interface MainScene : CCNode <CCPhysicsCollisionDelegate>

// Current amount of enemies
@property (nonatomic, assign) int currentEnemyCount;

// Point of Explosion
@property (nonatomic, assign) CGPoint explosionPoint;

// Check if game is over
@property (nonatomic, assign) BOOL isGameOver;

// Game score
@property (nonatomic, assign) NSInteger score;

// Points per second
@property (nonatomic, assign) float pps;

// End game
- (void)gameOver;

// Trigger game over explosion
- (void)triggerExplosion;

@end
