//
//  Enemy.m
//  FirstGame
//
//  Created by Hans Yadav on 7/3/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Enemy.h"
#import "MainScene.h"

@implementation Enemy {
  CCLabelTTF *_pointsLabel;
  CCNodeColor *_colorNode;
  CCLabelTTF *_bonusPointsLabel;
}

const NSInteger PINCUSHION_BONUS = 10;
static const NSInteger STARTING_POINT_VALUE = 3;

- (id)init {
  self = [super init];
  
  if (self) {
    self.points = STARTING_POINT_VALUE;
    self.isShot = FALSE;
    self.isTutorialVersion = FALSE;
  }
  
  return self;
}

# pragma mark - Lifecycle events

- (void)didLoadFromCCB {
  self.physicsBody.collisionType = @"enemy"; // for collision detection
  self.physicsBody.collisionGroup = @"enemy"; // so enemies can't collide with each other
}

- (void)onEnter {
  [super onEnter];
  
  self.mainScene.currentEnemyCount++;
}

- (void)update:(CCTime)delta {
  if (self.direction == 0) {
    if (self.position.x + self.contentSizeInPoints.width > ([CCDirector sharedDirector].viewSize.width + 100.f)) {
      self.mainScene.explosionPoint = ccp([CCDirector sharedDirector].viewSize.width, self.position.y);
      if (self.mainScene.isGameOver) {
        [self gameOverActions];
      } else {
        [self.mainScene gameOver];
      }
      
    } else {
      [self decreasePointsAndChangeColorOverDistanceTraveled:(self.position.x)];
    }
  } else {
    if (self.position.x < 0) {
      self.mainScene.explosionPoint = ccp(0, self.position.y);
      if (self.mainScene.isGameOver) {
        [self gameOverActions];
      } else {
        [self.mainScene gameOver];
      }
    } else {
      [self decreasePointsAndChangeColorOverDistanceTraveled:([CCDirector sharedDirector].viewSize.width - self.position.x)];
    }
  }
}

# pragma mark - Points

- (void)displayPoints:(NSInteger)points {
  if ([_pointsLabel convertToWorldSpace:_pointsLabel.positionInPoints].x + _pointsLabel.contentSizeInPoints.width > [CCDirector sharedDirector].viewSize.width) {
      
    _pointsLabel.anchorPoint = ccp(1, 1);
    _pointsLabel.positionType = CCPositionTypeNormalized;
    _pointsLabel.position = ccp(0, 0);
  }
  
//  if (bonus) {
//    [_pointsLabel setColor:[CCColor colorWithCcColor3b:ccRED]];
//    _pointsLabel.fontSize = 12;
//    _pointsLabel.string = [NSString stringWithFormat:@"BONUS\n+%li", (long)points];
//  } else {
  _pointsLabel.string = [NSString stringWithFormat:@"+%li", (long)points];
//  }
  _pointsLabel.zOrder = 999;
  _pointsLabel.visible = TRUE;
}

- (void)decreasePointsAndChangeColorOverDistanceTraveled:(NSInteger)distance {
  NSInteger viewSizeWidth = [CCDirector sharedDirector].viewSize.width;
  
  if (distance > (viewSizeWidth*2)/3) {
    self.points = STARTING_POINT_VALUE/3;
    // [_colorNode setColor:[CCColor colorWithCcColor3b:ccRED]];
  } else if (distance > viewSizeWidth/3) {
    self.points = (STARTING_POINT_VALUE*2)/3;
    // [_colorNode setColor:[CCColor colorWithCcColor3b:ccBLUE]];
  }
}

# pragma mark - Game over

- (void)gameOverActions {
  [self.mainScene triggerExplosion];
  [self removeFromParent];
}

# pragma mark - Remove

- (void)beginDissolve {
  
  for(int i=1; i<=4; i++) {
    CCNode *part = [self getChildByName:[NSString stringWithFormat:@"part%i",i] recursively:TRUE];
    
    float redValue = [self randomRGBValue];
    float greenValue = [self randomRGBValue];
    float blueValue = [self randomRGBValue];
    
    CCColor *color = [CCColor colorWithRed:redValue green:greenValue blue:blueValue];
    
    [part setColor:color];
  }
}

# pragma mark - Positioning

/* 
 * Positions enemy on random point along y-axis on either left or right side of screen
 *   depending on value of randomIndex
 * randomIndex is either 0 or 1: 0 means left-side, 1 means right-side
 * Returns a CGPoint that will be used to determine direction of force to be applied on
 *   enemy to make it move
*/
- (CGPoint)setRandomPosition:(int)randomIndex {
  self.direction = randomIndex;
  
  // Determine range along y-axis where enemy can spawn
  int minY = self.mainScene.contentSizeInPoints.height*.5;
  int maxY = self.mainScene.contentSizeInPoints.height-(self.contentSizeInPoints.height*1.5);
  int rangeY = maxY - minY;
  
  // Get random point on y-axis between range
  int randomY = (arc4random() % rangeY) + minY;
  
  if (randomIndex == 0)
  {
    // Position enemy initially off-screen (so to simulate it flying in)
    self.position = ccp(0-(self.contentSizeInPoints.width/2), randomY);
    return ccp(1,0); // force direction to the right
  }
    
  else
  {
    self.position = ccp(self.mainScene.contentSizeInPoints.width, randomY);
    
    // flip image so it points left
    id image = [self getChildByName:@"image" recursively:FALSE];
    [image setScaleX:-1];
    
    return ccp(-1,0); // force direction to the left
  }
}

// spawns enemy in middle of screen
- (void)spawnInTutorialLocation{
  self.isTutorialVersion = TRUE;
  
  self.anchorPoint = ccp(0.5,0.5);
  self.positionType = CCPositionTypeNormalized;
  self.position = ccp(0.55,0.65);
}

# pragma mark - Colors

- (float)randomRGBValue {
  return (arc4random() % 255)/255.0f;
}

@end
