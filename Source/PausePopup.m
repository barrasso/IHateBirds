//
//  PausePopup.m
//  FirstGame
//
//  Created by Mark on 8/25/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "PausePopup.h"
#import "MainScene.h"

@implementation PausePopup

# pragma mark - Lifecycle

- (void)onEnter
{
    [super onEnter];
    
    // User enabled
    self.userInteractionEnabled = YES;
}

- (void)onExit
{
    // Deallocate memory
    [super onExit];
}

#pragma mark - Selectors

- (void)resumeGame
{
    // Resumes gameplay
    self.mainScene.paused = NO;
    
    // Removes popup
    [self removeFromParent];
}

- (void)restartGame
{
    // Restarts a new game
    [[CCDirector sharedDirector] replaceScene:[CCBReader loadAsScene:@"MainScene"]];
}

@end
