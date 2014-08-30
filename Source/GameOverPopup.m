//
//  GameOverPopup.m
//  FirstGame
//
//  Created by Hans Yadav on 7/3/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "GameOverPopup.h"
#import "MainScene.h"
#import "GCHelper.h"

@implementation GameOverPopup
{
    // Labels
    CCLabelTTF *_currentScore;
    CCLabelTTF *_highScoreLabel;
    CCLabelTTF *_newHighScoreLabel;
    CCLabelTTF *_multiKillsLabel;
    CCLabelTTF *_pinKillsLabel;
    CCLabelTTF *_accuracyLabel;
    CCLabelTTF *_bonusLabel;
    
    // Scores
    CCNode *_scoreBox;
    
    // Random Index
    int randomIndex;
    
    // Strings
    NSString *highScorePost;
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
    
    // Play wat sound
    [[OALSimpleAudio sharedInstance] playEffect:@"Wat.wav" volume:1.75f pitch:1.0f pan:1.0f loop:NO];
    
    // MGWU Analytics
    NSNumber *gameScore = [NSNumber numberWithFloat:[self.mainScene score]];
    NSNumber *mks = [NSNumber numberWithFloat:[self.mainScene multiKills]];
    NSNumber *pks = [NSNumber numberWithFloat:[self.mainScene pinKills]];
    NSDictionary *userStats = [[NSDictionary alloc] initWithObjectsAndKeys:gameScore,@"score", mks, @"multi kills", pks, @"pin kills", nil];
    
    // Log user scores
    [MGWU logEvent:@"game_complete_with_stats" withParams:userStats];
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
    
    // Update multikill and pin kill labels
    _multiKillsLabel.string = [NSString stringWithFormat:@"MK: %ld",(long)[self.mainScene multiKills]];
    _pinKillsLabel.string = [NSString stringWithFormat:@"PK: %ld",(long)[self.mainScene pinKills]];
    
    // Calculate accuracy and update label as percent
    _accuracyLabel.string = [NSString stringWithFormat:@"%0.1f%% Hit",(float)[self.mainScene dartsHit]/[self.mainScene totalDarts] * 100.f];
    
    // Calculate bonus points
    NSInteger bonusPoints = ([self.mainScene multiKills]+[self.mainScene pinKills] * 10);
    _bonusLabel.string = [NSString stringWithFormat:@"+%ld Bonus",(long)bonusPoints];
    
    // Change current score string
    _currentScore.string = [NSString stringWithFormat:@"%d", ([self.mainScene score] + bonusPoints)];
    
    // Show high score label if new high score
    if ([self isNewRecord:category]) {
      _newHighScoreLabel.visible = TRUE;
    }
  
    // Update the highscore label and add the score box to parent
    [self updateHighScoreLabel:category];
    [self addChild:_scoreBox];
}

#pragma mark - Selectors

- (void)restartGame
{
    // Play button click sound
    [[OALSimpleAudio sharedInstance] playEffect:@"button_click.wav"];
    
    // Log restarted game
    [MGWU logEvent:@"restarted_game"];
    
    // Replay the game when pressed
    [[CCDirector sharedDirector] replaceScene:[CCBReader loadAsScene:@"MainScene"]];
}

- (void)openGameCenter
{
    // Play button click sound
    [[OALSimpleAudio sharedInstance] playEffect:@"button_click.wav"];
    
    // Opens GameCenter
    [[GCHelper sharedInstance] showLeaderboard];
    
    // Log opened gamecenter
    [MGWU logEvent:@"opened_gamecenter"];
}

- (void)shareToFacebook
{
    // Play button click sound
    [[OALSimpleAudio sharedInstance] playEffect:@"button_click.wav"];
    
    // Log pressed facebook
    [MGWU logEvent:@"pressed_facebook"];
    
    // High score post
    highScorePost = [NSString stringWithFormat:@"Just scored %i!  #IHateBirds",[self.mainScene score]];
    
    // Shares score to Facebook
    // If the user is logged in to Facebook
    if ([MGWU isFacebookActive])
    {
        // Create a new facebook share post
        [MGWU shareWithTitle:@"I Really Do Hate Birds" caption:highScorePost andDescription:@"Think you can kill more birds than me?"];
        
        // Log facebook shares
        [MGWU logEvent:@"shared_to_facebook"];
    }
    
    else
    {
        // Prompt the user to log into facebook
        [MGWU loginToFacebook];
        
        // Create a new facebook share post
        [MGWU shareWithTitle:@"I Really Do Hate Birds" caption:highScorePost andDescription:@"Think you can kill more birds than me?"];
        
        // Log facebook shares
        [MGWU logEvent:@"shared_to_facebook"];
    }
    
}

# pragma mark - Enum Functions

- (NSString *)enumToString:(CategoryName)name
{
    // Swtich to determine which label to show
    switch (name) {
      case score:
        return @"score";
        break;
      default:
        return @"score";
    }
}

#pragma mark - Toggle score categories

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
