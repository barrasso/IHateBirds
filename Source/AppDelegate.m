/*
 * SpriteBuilder: http://www.spritebuilder.org
 *
 * Copyright (c) 2012 Zynga Inc.
 * Copyright (c) 2013 Apportable Inc.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

#import "cocos2d.h"

#import "AppDelegate.h"
#import "CCBuilderReader.h"
#import "GameState.h"
#import "GCHelper.h"

@implementation AppController

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Configure Cocos2d with the options set in SpriteBuilder
    NSString* configPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Published-iOS"]; // TODO: add support for Published-Android support
    configPath = [configPath stringByAppendingPathComponent:@"configCocos2d.plist"];
    
    NSMutableDictionary* cocos2dSetup = [NSMutableDictionary dictionaryWithContentsOfFile:configPath];
    
    // Note: this needs to happen before configureCCFileUtils is called, because we need apportable to correctly setup the screen scale factor.
#ifdef APPORTABLE
    if([cocos2dSetup[CCSetupScreenMode] isEqual:CCScreenModeFixed])
        [UIScreen mainScreen].currentMode = [UIScreenMode emulatedMode:UIScreenAspectFitEmulationMode];
    else
        [UIScreen mainScreen].currentMode = [UIScreenMode emulatedMode:UIScreenScaledAspectFitEmulationMode];
#endif
    
    // Configure CCFileUtils to work with SpriteBuilder
    [CCBReader configureCCFileUtils];
    
    // Do any extra configuration of Cocos2d here (the example line changes the pixel format for faster rendering, but with less colors)
    //[cocos2dSetup setObject:kEAGLColorFormatRGB565 forKey:CCConfigPixelFormat];
  
    //[cocos2dSetup setObject:@YES forKey:CCSetupShowDebugStats];
      
    [self setupCocos2dWithOptions:cocos2dSetup];
    
    // Crashlytics
    //[Crashlytics startWithAPIKey:@"828dced47da406438127a82d9a9bb6663463722a"];
    
    //////// MGWU SDK ////////
    [MGWU loadMGWU:@"killurself"];
    [MGWU noFacebookPrompt];

    // Set reminder message
    [MGWU setReminderMessage:@"More birds need to die!"];
    
    // Prompt to rate game
    [MGWU setAppiraterAppId:@"913230912" andAppName:@"I Hate Birds"];
    
    // Set Game Link URL
    [MGWU setGameLinkURL:@""];
    
    // Set Icon URL
    [MGWU setIconURL:@""];
    
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    // attempt to extract a token from the url
    return [MGWU handleURL:url];
}

- (CCScene*) startScene
{
    // Background ambience
    [[OALSimpleAudio sharedInstance] playBg:@"birds-ambience.wav" volume:2.0f pan:0 loop:YES];
    
    // Background music
    [[OALSimpleAudio sharedInstance] playBg:@"wah.mp3" volume:0.4f pan:0 loop:YES];
    
    // Authenticate GameCenter User
    [[GCHelper sharedInstance] authenticateLocalUser];
    
    // Turn on tutorial mode
    [GameState sharedInstance].tutorialModeOn = TRUE;
    
    // Load MainScne
    return [CCBReader loadAsScene:@"MainScene"];
}

@end
