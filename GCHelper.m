//
//  GCHelper.m
//  Tyle
//
//  Created by Mark on 7/29/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "GCHelper.h"
#import "AppDelegate.h"

@implementation GCHelper

@synthesize gameCenterAvailable;

#pragma mark Initialization

static GCHelper *_sharedHelper = nil;
static GCHelper *sharedHelper = nil;

+ (GCHelper *) sharedInstance {
    if (!sharedHelper) {
        sharedHelper = [[GCHelper alloc] init];
    }
    return sharedHelper;
}

+ (GCHelper*)defaultHelper {
    
    // dispatch_once will ensure that the method is only called once (thread-safe)
    static dispatch_once_t pred = 0;
    
    dispatch_once(&pred, ^{
        _sharedHelper = [[GCHelper alloc] init];
    });
    
    return _sharedHelper;
}

- (BOOL)isGameCenterAvailable
{
    // check for presence of GKLocalPlayer API
    Class gcClass = (NSClassFromString(@"GKLocalPlayer"));
    
    // check if the device is running iOS 4.1 or later
    NSString *reqSysVer = @"4.1";
    NSString *currSysVer = [[UIDevice currentDevice] systemVersion];
    BOOL osVersionSupported = ([currSysVer compare:reqSysVer
                                           options:NSNumericSearch] != NSOrderedAscending);
    
    return (gcClass && osVersionSupported);
}

- (id)init
{
    if ((self = [super init])) {
        gameCenterAvailable = [self isGameCenterAvailable];
        if (gameCenterAvailable) {
            NSNotificationCenter *nc =
            [NSNotificationCenter defaultCenter];
            [nc addObserver:self
                   selector:@selector(authenticationChanged)
                       name:GKPlayerAuthenticationDidChangeNotificationName
                     object:nil];
        }
    }
    return self;
}

- (void)authenticationChanged
{
    if ([GKLocalPlayer localPlayer].isAuthenticated && !userAuthenticated) {
        NSLog(@"Authentication changed: player authenticated.");
        userAuthenticated = TRUE;
    } else if (![GKLocalPlayer localPlayer].isAuthenticated && userAuthenticated) {
        NSLog(@"Authentication changed: player not authenticated");
        userAuthenticated = FALSE;
    }
}

#pragma mark User functions

- (void)authenticateLocalUser {
    
    if (!gameCenterAvailable) return;
    
    NSLog(@"Authenticating local user...");
    if ([GKLocalPlayer localPlayer].authenticated == NO) {
        [[GKLocalPlayer localPlayer] authenticateWithCompletionHandler:nil];
    } else {
        NSLog(@"Already authenticated!");
    }
}

#pragma mark Leaderboards

- (void)showLeaderboard
{
    GKGameCenterViewController *gameCenterController = [[GKGameCenterViewController alloc] init];
    gameCenterController.gameCenterDelegate = self;
    gameCenterController.leaderboardIdentifier = @"IHateBirdsLB";
    gameCenterController.viewState = GKGameCenterViewControllerStateLeaderboards;

    if (gameCenterController != nil)
    {
        AppController *delegate = (AppController *)[[UIApplication sharedApplication] delegate];
        [delegate.navController presentViewController:gameCenterController animated:YES completion:nil];
    }
}

- (void)gameCenterViewControllerDidFinish:(GKGameCenterViewController *)gameCenterViewController
{
    [gameCenterViewController dismissViewControllerAnimated:YES completion:^{
        
    }];
}

#pragma mark - Achievements

- (void)loadAchievements
{
    // Init achievements dictions
    self.achievementsDictionary = [[NSMutableDictionary alloc] init];
    
    // Load achievements
    [GKAchievement loadAchievementsWithCompletionHandler:^(NSArray *achievements, NSError *error) {
        
        if (error != nil)
        {
            // Handle the error.
            NSLog(@"Error while loading achievements: %@", error.description);
        }
        
        else if (achievements != nil)
        {
            // Process the array of achievements.
            for (GKAchievement* achievement in achievements)
                
                self.achievementsDictionary[achievement.identifier] = achievement;
        }
    }];
}

// Achievement Getter
- (GKAchievement*)getAchievementForIdentifier: (NSString*) identifier
{
    GKAchievement *achievement = [self.achievementsDictionary objectForKey:identifier];
    
    if (achievement == nil)
    {
        // Get schievement from id
        achievement = [[GKAchievement alloc] initWithIdentifier:identifier];
        
        // Set achievement
        self.achievementsDictionary[achievement.identifier] = achievement;
        
    }
    return achievement;
}

// Report achievements
- (void)reportAchievementIdentifier: (NSString*) identifier percentComplete: (float) percent
{
    GKAchievement *achievement = [self getAchievementForIdentifier:identifier];
    if (achievement && achievement.percentComplete != 100.0) {
        achievement.percentComplete = percent;
        achievement.showsCompletionBanner = YES;
        
        [GKAchievement reportAchievements:@[achievement] withCompletionHandler:^(NSError *error) {
            if (error != nil) {
                NSLog(@"Error while reporting achievement: %@", error.description);
            }
        }];
    }
}

#pragma mark - Report Score

- (void)reportScore:(float)score forLeaderboardID:(NSString*)identifier
{
    GKScore *scoreReporter = [[GKScore alloc] initWithLeaderboardIdentifier: identifier];
    scoreReporter.value = score;
    scoreReporter.context = 0;
    
    [GKScore reportScores:@[scoreReporter] withCompletionHandler:^(NSError *error) {
        if (error == nil) {
            NSLog(@"Score reported successfully!");
        } else {
            NSLog(@"Unable to report score!");
        }
    }];
}

@end
