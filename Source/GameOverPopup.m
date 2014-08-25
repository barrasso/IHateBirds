//
//  GameOverPopup.m
//  FirstGame
//
//  Created by Hans Yadav on 7/3/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "GameOverPopup.h"
#import "MainScene.h"

@implementation GameOverPopup
{
  // Labels
  CCLabelTTF *_currentScore;
  CCLabelTTF *_highScoreLabel;
  CCLabelTTF *_newHighScoreLabel;
  CCLabelTTF *_categoryNameLabel;
    
  // Scores
  CCNode *_scoreBox;
    
  // Random Index
  int randomIndex;
}

- (id)init
{
    self = [super init];
  
    if (self)
    {
      // Init scoreBoxes 
      self.scoreBoxes = [[NSMutableArray  alloc] initWithCapacity:categoriesCount];
      self.currentCategoryIndex = 0;
    }
   
    return self;
}

- (void)onEnter
{
    [super onEnter];
    
    // Load Score Box
    [self loadScoreBox:self.currentCategoryIndex];
}

# pragma mark - Scores

- (BOOL)isNewRecord:(NSString *)categoryName
{
    // Grab record from high score userdefaults
    float record = [[NSUserDefaults standardUserDefaults] floatForKey:categoryName];
    
    // Grab current score from gameplay
    float currentScore = [[self.mainScene valueForKey:categoryName] floatValue];
  
    // If current score is greater then the record, set it as the new record
    if (currentScore > record) {
      // set new highscore in NSUserDefaults
      [[NSUserDefaults standardUserDefaults] setFloat:currentScore forKey:categoryName];
      [[NSUserDefaults standardUserDefaults] synchronize];
      return TRUE;
    }   else {
      return FALSE;
    }

    return FALSE;
}

- (void)updateHighScoreLabel:(NSString *)categoryName
{
    // Update the highscore label with the new record
    id highScore = [[NSUserDefaults standardUserDefaults] objectForKey:categoryName];
    if (highScore)
      _highScoreLabel.string = [NSString stringWithFormat:@"Best: %@", highScore];
}

- (void)loadScoreBox:(NSInteger)index
{
    NSString *category = [self enumToString:(CategoryName)index];
  
    if (index < [self.scoreBoxes count]) {
      _scoreBox = [self.scoreBoxes objectAtIndex:index];
    } else {
      _scoreBox = (CCNode *)[CCBReader load:@"ScoreBox" owner:self];
      [self.scoreBoxes addObject:_scoreBox];
    }
  
    // Position the scoreBox
    _scoreBox.positionType = CCPositionTypeNormalized;
    _scoreBox.position = ccp(0.5, 0.5);
  
    // Change the category label to uppercase
    _categoryNameLabel.string = [category uppercaseString];
    _currentScore.string = [NSString stringWithFormat:@"%@", [self.mainScene valueForKey:category]];
  
    // Show high score label if new high score
    if ([self isNewRecord:category]) {
      _newHighScoreLabel.visible = TRUE;
    }
  
    // Update the highscore label and add the score box to parent
    [self updateHighScoreLabel:category];
    [self addChild:_scoreBox];
}

# pragma mark - Selectors

- (void)restartGame
{
    // Replay the game when pressed
    [[CCDirector sharedDirector] replaceScene:[CCBReader loadAsScene:@"MainScene"]];
}

- (void)openStore
{
    // Open the in game store
}

# pragma mark - Enum Functions

- (NSString *)enumToString:(CategoryName)name
{
    // Swtich to determine which label to show
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

- (void)previousCategory
{
    // Remove the score box from parent
    [_scoreBox removeFromParent];
    
    // Decrement the index
    NSInteger newIndex = --self.currentCategoryIndex;
    
    // Go to last index
    if (newIndex < 0)
      newIndex = self.currentCategoryIndex = categoriesCount-1;
  
    // Then reload the score box
    [self loadScoreBox:newIndex];
}

- (void)nextCategory
{
    // Remove the current score box
    [_scoreBox removeFromParent];
    
    // Increment the index of scorebox
    NSInteger newIndex = ++self.currentCategoryIndex;
    
    // Go to first index
    if (newIndex >= categoriesCount)
      newIndex = self.currentCategoryIndex = 0;
  
    // Load the new score box
    [self loadScoreBox:newIndex];
}

@end
