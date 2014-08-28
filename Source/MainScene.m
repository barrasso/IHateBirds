//
//  MainScene.m
//  I Hate Birds
//
//  Created by Mark on 08/01/14.
//  Copyright (c) 2014 Mark. All rights reserved.
//

#import "MainScene.h"
#import "GameOverPopup.h"
#import "PausePopup.h"
#import "Enemy.h"
#import "Dart.h"
#import "CoordinateUtils.h"
#import "GameState.h"
#import "CCPhysics+ObjectiveChipmunk.h"

@implementation MainScene {
  
    // Physics Node
    CCPhysicsNode *_physicsNode;
    
    // Labels
    CCLabelTTF *_waveLabel;
    CCLabelTTF *_scoreLabel;
    CCLabelTTF *_bonusPointsLabel;
  
    // Bonus
    CCNode *_bonusNode;
    
    // Buttons
    CCNode *_pauseButton;
    
    // Tutorial
    CCNode *_tutorialNode;

    // Touch Location
    CGPoint _startTouchLocation;
    
    // Timer
    float _timer;
    
    // Wave Number
    int waveNumber;
}

// Maximum Amount of enemies to spawn
static const int TOTAL_SIMULTANEOUS_ENEMIES = 2;

#pragma mark - Initialization

- (id)init {
    
    // Super init
    self = [super init];
  
    // If initialized
    if (self)
    {
        // Init variables to zero
        self.isGameOver = FALSE;
        self.currentEnemyCount = 0;
        self.score = 0;
        self.multiKills = 0;
        self.pinKills = 0;
    }
    
    return self;
}

#pragma mark - Lifecycle events

- (void)didLoadFromCCB
{
    // Enable touches
    self.userInteractionEnabled = TRUE;
    
    // Set Collision delegate
    _physicsNode.collisionDelegate = self;
}

- (void)onEnter
{
    [super onEnter];
    
    // Set tutorial to invisible
    _tutorialNode.visible = FALSE;
    
    // Hide and disable the pause button
    _pauseButton.visible = NO;
    _pauseButton.userInteractionEnabled = NO;
    
    // Set Score observer to 0
    [self addObserver:self forKeyPath:@"score" options:0 context:NULL];
    
    // Set wave label to invisible
    _waveLabel.visible = FALSE;
    
    // Set wave number to 0
    waveNumber = 0;
  
    // If Tutorial mode is enabled
    if ([GameState sharedInstance].tutorialModeOn)
    {
        // Display the tutorial
        _tutorialNode.visible = TRUE;
      
        // Load an enemy above the tutorial
        Enemy *enemy = (Enemy *)[CCBReader load:@"StupidBird"];
        enemy.mainScene = self;
        [enemy spawnInTutorialLocation];
    
        // Add tutorial enemy to physics node
        [_physicsNode addChild:enemy];
    }
}

- (void)update:(CCTime)delta
{
    // If tutorial mode is not enabled
    if (![GameState sharedInstance].tutorialModeOn)
    {
        // Show and enable the pause button
        _pauseButton.visible = YES;
        _pauseButton.userInteractionEnabled = YES;
      
        // Increment timer
        _timer += delta;
      
        /* Enemy Waves */
        // Wave 1
        // After 0 seconds, spawn 2 stupid birds
        if ((self.currentEnemyCount < TOTAL_SIMULTANEOUS_ENEMIES) && (self.currentEnemyCount >= 0) && (_timer < 20.f))
        {
            // Set wave number
            waveNumber = 1;
        
            // Continue spawning enemies
            [self spawnEnemy];
        }
      
        // Wave 2
        // After 20 seconds, spawn 3 stupid birds
        else if ((self.currentEnemyCount < TOTAL_SIMULTANEOUS_ENEMIES + 1) && (self.currentEnemyCount >= 0) && (_timer > 20.f) && (_timer < 40.f))
        {
            // Set wave number
            waveNumber = 2;
        
            // Continue spawning enemies
            [self spawnEnemy];
        }
      
        // Wave 3
        // After 40 seconds, spawn 4 stupid birds
        else if ((self.currentEnemyCount < TOTAL_SIMULTANEOUS_ENEMIES + 2) && (self.currentEnemyCount >= 0) && (_timer > 40.f) && (_timer < 60.f))
        {
            // Set wave number
            waveNumber = 3;
        
            // Continue spawning enemies
            [self spawnEnemy];
        }
      
        // Wave 4
        // After 60 seconds, spawn 5 stupid birds
        else if ((self.currentEnemyCount < TOTAL_SIMULTANEOUS_ENEMIES + 3) && (self.currentEnemyCount >= 0) && (_timer > 60.f))
        {
            // Set wave number
            waveNumber = 4;
        
            // Continue spawning enemies
            [self spawnEnemy];
        }
    }
    
        /*  Wave Labels */
        if (waveNumber == 1 && _timer < 1.f)
        {
            // Set wave label
            _waveLabel.string = [NSString stringWithFormat:@"Wave %i",waveNumber];
    
            // Set tutorial to be visible
            _waveLabel.visible = TRUE;
    
            // Set invisible on timer
            [self scheduleBlock:^(CCTimer *timer) {
            _waveLabel.visible = FALSE;
            } delay:3.0f];
        
            // Set wave number to 0 on timer
            [self scheduleBlock:^(CCTimer *timer) {
            waveNumber = 0;
            } delay:0.1f];
        }
    
        else if (waveNumber == 2 && _timer < 21.f)
        {
            // Set wave label
            _waveLabel.string = [NSString stringWithFormat:@"Wave %i",waveNumber];
        
            // Set tutorial to be visible
            _waveLabel.visible = TRUE;
        
            // Set invisible on timer
            [self scheduleBlock:^(CCTimer *timer) {
                _waveLabel.visible = FALSE;
            } delay:3.0f];
        
            // Set wave number to 0 on timer
            [self scheduleBlock:^(CCTimer *timer) {
                waveNumber = 0;
            } delay:0.1f];
        }
    
        else if (waveNumber == 3 && _timer < 41.f)
        {
            // Set wave label
            _waveLabel.string = [NSString stringWithFormat:@"Wave %i",waveNumber];
        
            // Set tutorial to be visible
            _waveLabel.visible = TRUE;
        
            // Set invisible on timer
            [self scheduleBlock:^(CCTimer *timer) {
                _waveLabel.visible = FALSE;
            } delay:3.0f];
        
            // Set wave number to 0 on timer
            [self scheduleBlock:^(CCTimer *timer) {
                waveNumber = 0;
            } delay:0.1f];
        }
    
        else if (waveNumber == 4 && _timer < 61.f)
        {
            // Set wave label
            _waveLabel.string = [NSString stringWithFormat:@"Wave %i",waveNumber];
        
            // Set tutorial to be visible
            _waveLabel.visible = TRUE;
        
            // Set invisible on timer
            [self scheduleBlock:^(CCTimer *timer) {
                _waveLabel.visible = FALSE;
            } delay:3.0f];
        
            // Set wave number to 0 on timer
            [self scheduleBlock:^(CCTimer *timer) {
                waveNumber = 0;
            } delay:0.1f];
        }
    
    // Handle timer for game over
    if (self.isGameOver)
    {
        // Set timer to zero
        _timer = 0.f;
        
        // Hide and disable the pause button
        _pauseButton.visible = NO;
        _pauseButton.userInteractionEnabled = NO;
    }
}

- (void)onExit
{
    // Remove Score observer
    [self removeObserver:self forKeyPath:@"score"];

    // Deallocate memory
    [super onExit];
}

#pragma mark - Observers

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    // Set scoreLabel to current score
    if ([keyPath isEqualToString:@"score"])
        _scoreLabel.string = [NSString stringWithFormat:@"%li", (long)self.score];

}

#pragma mark - Bonus Points

- (void)displayBonusLabel:(NSString *)type points:(NSInteger)points
{
    // Show bonus node;
    _bonusNode.visible = TRUE;
    
    // Set bonus points label with current bonus points
    _bonusPointsLabel.string = [NSString stringWithFormat:@"%@ +%li", type, (long)points];
    // Show bonus points label
    _bonusPointsLabel.visible = TRUE;
  
    // Show bonus points label on timer
    [self scheduleBlock:^(CCTimer *timer) {
        _bonusNode.visible = FALSE;
        _bonusPointsLabel.visible = FALSE;
    } delay:1.5];
}

#pragma mark - Touch events

- (void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    // Get starting location of touch
    _startTouchLocation = [touch locationInNode:self];
}

- (void)touchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    // Set end location of touch
    CGPoint endLocation = [touch locationInNode:self];
  
    // Calculate difference of the start and end touch locations
    CGPoint diff = ccpSub(endLocation, _startTouchLocation);
    double distance = sqrt(diff.x*diff.x + diff.y*diff.y);
  
    // If swipe distance isn't sufficiently large, turn on "Tutorial Mode" which overlays
    // the controls for the game
    if (distance > 60)
    {
        // Check for horizontal swipe
        if (_startTouchLocation.y != endLocation.y)
            [self readyDartAt:_startTouchLocation endLoc:endLocation diff:diff];
    }
        // If user is bad at game, toggle tutorial node
        else
            [self toggleTutorialMode];
}

- (void)readyDartAt:(CGPoint)startPoint endLoc:(CGPoint)endPoint diff:(CGPoint)diff
{
    // Default start poisiton for dart
    float startX = startPoint.x;
    float startY = 0;
    
    
    // Downward swipe should spawn dart at top of screen instead of bottom
    if (endPoint.y < startPoint.y)
      startY = self.contentSizeInPoints.height;
    
    // checks for perfectly vertical swipe (infinite slope)
    if (startPoint.x == endPoint.x)
      [self spawnDartAtPosition:ccp(startX, startY) rotation:0 andShootInDirection:diff];
    
    // Calculate slope if not infinite
    else
    {
      float slope = [CoordinateUtils slopeBetweenFirstPoint:startPoint secondPoint:endPoint];
      float yIntercept = [CoordinateUtils yInterceptWithSlope:slope coordinate:startPoint];
      startX = (startY-yIntercept)/slope;
      
      // Spawn dart with direction and angle
      [self spawnDartAtPosition:ccp(startX, startY) rotation:[CoordinateUtils angleBetweenStartPoint:startPoint endPoint:endPoint] andShootInDirection:diff];
    }
}

#pragma mark - Physics/Collision events

- (void)ccPhysicsCollisionPostSolve:(CCPhysicsCollisionPair *)pair dart:(Dart *)dart enemy:(Enemy *)enemy
{
    // Set points to zero
    NSInteger points = 0;
  
    // If tutorial enemy dies, turn off tutorial mode
    if (enemy.isTutorialVersion)
    {
        // Turn off tutorial
        [GameState sharedInstance].tutorialModeOn = FALSE;
        _tutorialNode.visible = FALSE;
      
        // Show and enable the pause button
        _pauseButton.visible = YES;
        _pauseButton.userInteractionEnabled = YES;
    }
  
    // Turn colliding objects static so they no longer move
    dart.physicsBody.type = CCPhysicsBodyTypeStatic;
    enemy.physicsBody.type = CCPhysicsBodyTypeStatic;
  
    // Make dart collisionMask empty so nothing else can collide with it
    // Enemy doesn't have empty collisionMask because another dart is allowed to collide with it
    dart.physicsBody.collisionMask = @[];
  
    // Determine if dart is colliding with already-hit enemy (for extra points)
    if (enemy.isShot)
    {
        _bonusNode.position = ccp(enemy.positionInPoints.x, enemy.positionInPoints.y - 25.f) ;
        [self displayBonusLabel:@"PINNED" points:PINCUSHION_BONUS];
        self.pinKills++;
        points = PINCUSHION_BONUS;
    }
    // Give regular amount of points
    else
    {
        enemy.isShot = TRUE;
        points = enemy.points;
        self.currentEnemyCount--;
    }
  
    // Determine if dart has hit different enemy before (for extra points)
    if (dart.hasHitEnemy)
    {
        _bonusNode.position = ccp(enemy.positionInPoints.x, enemy.positionInPoints.y - 25.f) ;
        [self displayBonusLabel:@"MULTI KILL" points:MULTISHOT_BONUS];
        self.multiKills++;
        points += MULTISHOT_BONUS;
    }
    // Dart has hit one enemy
    else
    {
        dart.hasHitEnemy = TRUE;
    }
  
    // Display points update score
    [enemy displayPoints:points];
    self.score += points;
    
    // Increment darts hit
    self.dartsHit++;
  
    // Remove dart and enemy
    // First fade out both objects, then apply dissolve effect to enemy
    [[_physicsNode space] addPostStepBlock:^{
    [self fadeOut:dart];
    [self fadeOut:enemy];
    [self loadBloodyExplosion:enemy];
    [enemy beginDissolve];
    
    // Fade out both objects on a timer
    [self scheduleBlock:^(CCTimer *timer) {
    [dart removeFromParent];
    [enemy removeFromParent];
    } delay:.275];
  } key:enemy];
}

#pragma mark - Spawn objects

- (void)spawnEnemy
{
    // Load Enemy from CCB file
    Enemy *enemy = (Enemy *)[CCBReader load:@"StupidBird"];
    enemy.mainScene = self;
  
    // Set position of enemy
    int randomIndex = arc4random() % 2; // determines which side (left|right) enemy spawns
    CGPoint forceDirection = [enemy setRandomPosition:randomIndex];
  
    // Add enemy to physics node
    [_physicsNode addChild: enemy];
  
    // Apply force to enemy
    CGPoint force = ccpMult(forceDirection, 7000);
    [enemy.physicsBody applyForce:force];
}

- (void)spawnDartAtPosition:(CGPoint)position rotation:(float)angle andShootInDirection:(CGPoint)diffPoint
{
     // If the game is not paused, spawn a dart
    if (!(self.paused)) {
        
        // Load dart from CCB
        Dart *dart = (Dart *)[CCBReader load:@"Dart"];
    
        // Set dart position
        dart.position = position;
    
        // Set dart's angle
        dart.rotation = angle;
    
        // Add dart to main scene
        dart.mainScene = self;
  
        // Add dart to physics node
        [_physicsNode addChild:dart];
  
        // Apply force to dart
        CGPoint force = ccpMult(diffPoint, 600);
        [dart.physicsBody applyForce:force];
        
        // Increment total darts
        self.totalDarts++;
    }
}

#pragma mark - Selectors

- (void)pauseGame
{
    // Pause the game
    self.paused = YES;
    
    // Load Pause popup and set position
    PausePopup *pausePopover = (PausePopup *)[CCBReader load:@"PausePopup"];
    pausePopover.mainScene = self;
    pausePopover.positionType = CCPositionTypeNormalized;
    pausePopover.position = ccp(0.5, 0.5);
    pausePopover.zOrder = 999;
    
    // Add popup to mainscene
    [self addChild:pausePopover];
    
    // Disable and hide pause button
    _pauseButton.visible = NO;
    _pauseButton.userInteractionEnabled = NO;
    
    // Log paused game
    [MGWU logEvent:@"paused_game"];
}

#pragma mark - Game Over

- (void)gameOver
{
    // Damp the physics
    [_physicsNode space].damping = 0.2f;
    
    // Set to game over
    self.isGameOver = TRUE;
    
    // Disable user interaction
    self.userInteractionEnabled = FALSE;
  
    // Load explosion animation
    [self triggerExplosion];
  
    // Load GameOver popup and set position
    GameOverPopup *popover = (GameOverPopup *)[CCBReader load:@"GameOverPopup"];
    popover.mainScene = self;
    popover.positionType = CCPositionTypeNormalized;
    popover.position = ccp(0.5, 0.5);
    popover.zOrder = 999;
  
    // Remove score label
    [_scoreLabel removeFromParent];
    
    // Add popup to mainscene
    [self addChild:popover];
    
    // Log Game over
    [MGWU logEvent:@"game_over" withParams:nil];
    
    // Log wave number
    NSNumber *waveNum = [NSNumber numberWithInt:waveNumber];
    NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys: waveNum, @"wave_number", nil];
    [MGWU logEvent:@"waves_complete" withParams:params];
}

#pragma mark - Explosions

- (void)loadBloodyExplosion:(CCNode *)enemy
{
    // Load the bloody effect
    CCNode *bloodExplosion = (CCNode *)[CCBReader load:@"BloodyExplosion"];
    
    // Place bloody effect on enemy's position
    bloodExplosion.positionInPoints = enemy.positionInPoints;
    
    // Add bloody effect to same parent as enemy
    [enemy.parent addChild:bloodExplosion];
}

- (void)triggerExplosion
{
    // Load Explosion from CCB
    CCParticleSystem *explosion = (CCParticleSystem *)[CCBReader load:@"Explosion"];
    
    // Set position of explosion
    explosion.position = self.explosionPoint;

    // Set explosion gravity dependent on position
    if (explosion.position.x >= [CCDirector sharedDirector].viewSize.width)
        explosion.gravity = ccp(-80,80);
    else if (explosion.position.y <= 0)
        explosion.gravity = ccp(80,80);
    else if (explosion.position.y >= [CCDirector sharedDirector].viewSize.height)
        explosion.gravity = ccp(-80,-80);
  
    // Add explosion to parent
    [self addChild:explosion];
}

#pragma mark - Tutorial

- (void)toggleTutorialMode
{
    // Set tutorial to be visible
    _tutorialNode.visible = TRUE;
    
    // Set invisible on timer
    [self scheduleBlock:^(CCTimer *timer) {
        _tutorialNode.visible = FALSE;
    } delay:0.7f];
    
    // Log toggled tutorial
    [MGWU logEvent:@"tutorial_toggled"];
}

#pragma mark - Effects

// Fades out visual image associated with object (dart|enemy)
- (void)fadeOut:(id)obj
{
    // Fade out objects
    CCActionFadeOut *fadeOut = [CCActionFadeOut actionWithDuration:0.2f];
  
    // Get enemy image
    id image = [obj getChildByName:@"image" recursively:FALSE];
  
    // Fade enemy out
    [image runAction:fadeOut];
}

#pragma mark - Ads

//- (void)loadInterstitial
//{
//    // Load interstitial ads
//    _interstitial = [[GADInterstitial alloc] init];
//    _interstitial.adUnitID = @"ca-app-pub-6360908399010535/8481870209";
//    [_interstitial loadRequest:[GADRequest request]];
//    _interstitial.delegate = self;
//}
//
//- (void)interstitialDidReceiveAd:(GADInterstitial *)interstitial
//{
//    [_interstitial presentFromRootViewController:[UIApplication sharedApplication].keyWindow.rootViewController];
//}

@end
