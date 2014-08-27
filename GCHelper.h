//
//  GCHelper.h
//  Tyle
//
//  Created by Mark on 7/29/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GameKit/GameKit.h>

@interface GCHelper : NSObject <GKGameCenterControllerDelegate>
{
    BOOL gameCenterAvailable;
    BOOL userAuthenticated;
}

// Check if Game Center available
@property (assign, readonly) BOOL gameCenterAvailable;

// Dictionary containing all achievements
@property (nonatomic, strong) NSMutableDictionary *achievementsDictionary;

// Singletons
+ (GCHelper *)sharedInstance;
+ (GCHelper *)defaultHelper;

// Authenticate User
- (void)authenticateLocalUser;

// Leaderboards
- (void)showLeaderboard;
- (void)reportScore:(float)score forLeaderboardID:(NSString*)identifier;
- (void)gameCenterViewControllerDidFinish:(GKGameCenterViewController *)gameCenterViewController;

// Achievements
- (void)loadAchievements;
- (GKAchievement*)getAchievementForIdentifier: (NSString*) identifier;
- (void)reportAchievementIdentifier: (NSString*) identifier percentComplete: (float) percent;

@end