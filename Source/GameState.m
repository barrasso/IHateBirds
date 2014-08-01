//
//  GameState.m
//  FirstGame
//
//  Created by Hans Yadav on 7/3/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "GameState.h"

@implementation GameState

+ (GameState *)sharedInstance {
  static dispatch_once_t once;
  static GameState *instance;
  dispatch_once(&once, ^{
    instance = [[GameState alloc] init];
  });
  return instance;
}

@end
