//
//  MainScene.h
//  PROJECTNAME
//
//  Created by Viktor on 10/10/13.
//  Copyright (c) 2013 Apportable. All rights reserved.
//

#import "CCNode.h"
#import "GADInterstitial.h"

@interface MainScene : CCNode <CCPhysicsCollisionDelegate, GADInterstitialDelegate>

// Current amount of enemies
@property (nonatomic, assign) int currentEnemyCount;

// Check if game is over
@property (nonatomic, assign) BOOL isGameOver;

// Total amount of darts used
@property (nonatomic, assign) NSInteger totalDarts;

// Darts that hit an enemy
@property (nonatomic, assign) NSInteger dartsHit;

// Point of Explosion
@property (nonatomic, assign) CGPoint explosionPoint;

// Game score
@property (nonatomic, assign) NSInteger score;

// Number of Multi Kills
@property (nonatomic, assign) NSInteger multiKills;

// Number of Pin Kills
@property (nonatomic, assign) NSInteger pinKills;

// Interstitial
@property (nonatomic, strong) GADInterstitial *interstitial;

// Load Ad
- (void)loadInterstitial;

// End game
- (void)gameOver;

// Trigger game over explosion
- (void)triggerExplosion;

@end
