//
//  Dart.m
//  FirstGame
//
//  Created by Hans Yadav on 7/2/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Dart.h"
#import "MainScene.h"

@implementation Dart

const NSInteger MULTISHOT_BONUS = 10;

- (void)didLoadFromCCB {
  self.physicsBody.collisionType = @"dart";
  self.physicsBody.collisionGroup = @"dart";
  
  self.hasHitEnemy = FALSE;
}

- (void)onEnter {
  [super onEnter];

  // Dart Streak
  self.streak = [CCMotionStreak streakWithFade:0.7f minSeg:50 width:self.contentSizeInPoints.width color:[CCColor colorWithRed:181 green:0 blue:0 alpha:0.46f] textureFilename:@"ccbResources/ccbParticleStars.png"];
  self.streak.position = self.position;
  [self.parent addChild:self.streak z:2];

}

- (void)update:(CCTime)delta {
  
  if (!self.mainScene.isGameOver) {
    // update position of streak
    self.streak.position = self.position;
    
      // If the dart hit the side of the screen, or if the velocity is zero, remove it
    if ([self didHitSide] || (self.physicsBody.velocity.x == 0) || (self.physicsBody.velocity.y == 0)) {
        [self scheduleBlock:^(CCTimer *timer) {
            [self removeFromParent];
        } delay:1.0f];
    }
  }
}

- (BOOL)didHitSide {
  if (self.position.y < 0) {
    if (self.rotation > 90 && self.rotation < 270) {
      self.mainScene.explosionPoint = ccp(self.position.x, 0);
      return TRUE;
    }
  } else if (self.position.y > [CCDirector sharedDirector].viewSize.height) {
    if (self.rotation > -90 && self.rotation < 90) {
      self.mainScene.explosionPoint = ccp(self.position.x, [CCDirector sharedDirector].viewSize.height);
      return TRUE;
    }
  }
  
  if (self.position.x > [CCDirector sharedDirector].viewSize.width) {
    if (self.rotation > 0 && self.rotation < 180) {
      self.mainScene.explosionPoint = ccp([CCDirector sharedDirector].viewSize.width, self.position.y);
      return TRUE;
    }
  } else if (self.position.x < 0) {
    if (self.rotation < 0 || self.rotation > 180) {
      self.mainScene.explosionPoint = ccp(0, self.position.y);
      return TRUE;
    }
  }
  
  return FALSE;
}

@end
