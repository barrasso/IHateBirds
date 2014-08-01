//
//  GameOverPopup.m
//  FirstGame
//
//  Created by Hans Yadav on 7/3/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "GameOverPopup.h"
#import "MainScene.h"

@implementation GameOverPopup {
  CCLabelTTF *_currentScore;
  CCLabelTTF *_highScoreLabel;
  CCLabelTTF *_newHighScoreLabel;
  CCLabelTTF *_categoryNameLabel;
  CCNode *_scoreBox;
}

- (id)init {
  self = [super init];
  
  if (self) {
    self.scoreBoxes = [[NSMutableArray  alloc] initWithCapacity:categoriesCount];
    self.currentCategoryIndex = 0;
  }
  
  return self;
}

- (void)onEnter {
  [super onEnter];
  
  [self loadScoreBox:self.currentCategoryIndex];
}

# pragma mark - Scores

- (BOOL)isNewRecord:(NSString *)categoryName {
  float record = [[NSUserDefaults standardUserDefaults] floatForKey:categoryName];
  float currentScore = [[self.mainScene valueForKey:categoryName] floatValue];
  
  if (currentScore > record) {
    // set new highscore in NSUserDefaults
    [[NSUserDefaults standardUserDefaults] setFloat:currentScore forKey:categoryName];
    [[NSUserDefaults standardUserDefaults] synchronize];
    return TRUE;
  } else {
    return FALSE;
  }

  return FALSE;
}

- (void)updateHighScoreLabel:(NSString *)categoryName {
  id highScore = [[NSUserDefaults standardUserDefaults] objectForKey:categoryName];
  if (highScore) {
    _highScoreLabel.string = [NSString stringWithFormat:@"Best: %@", highScore];
  }
}

- (void)loadScoreBox:(NSInteger)index {
  NSString *category = [self enumToString:(CategoryName)index];
  
  if (index < [self.scoreBoxes count]) {
    _scoreBox = [self.scoreBoxes objectAtIndex:index];
  } else {
    _scoreBox = (CCNode *)[CCBReader load:@"ScoreBox" owner:self];
    [self.scoreBoxes addObject:_scoreBox];
  }
  
  _scoreBox.positionType = CCPositionTypeNormalized;
  _scoreBox.position = ccp(0.5, 0.8);
  
  _categoryNameLabel.string = [category uppercaseString];
  _currentScore.string = [NSString stringWithFormat:@"%@", [self.mainScene valueForKey:category]];
  
  if ([self isNewRecord:category]) {
    _newHighScoreLabel.visible = TRUE;
  }
  
  [self updateHighScoreLabel:category];
  [self addChild:_scoreBox];
}

# pragma mark - Restart game

- (void)restartGame {
  [[CCDirector sharedDirector] replaceScene:[CCBReader loadAsScene:@"MainScene"]];
}

# pragma mark - Enum Functions

- (NSString *)enumToString:(CategoryName)name {
  switch (name) {
    case score:
      return @"score";
      break;
    case pps:
      return @"pps";
      break;
    default:
      return @"score";
  }
}

# pragma mark - Toggle score categories

- (void)previousCategory {
  [_scoreBox removeFromParent];
  NSInteger newIndex = --self.currentCategoryIndex;
  // go to last index
  if (newIndex < 0) {
    newIndex = self.currentCategoryIndex = categoriesCount-1;
  }
  
  [self loadScoreBox:newIndex];
}

- (void)nextCategory {
  [_scoreBox removeFromParent];
  NSInteger newIndex = ++self.currentCategoryIndex;
  // go to first index
  if (newIndex >= categoriesCount) {
    newIndex = self.currentCategoryIndex = 0;
  }
  
  [self loadScoreBox:newIndex];
}






@end
