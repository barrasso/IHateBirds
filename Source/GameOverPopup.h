//
//  GameOverPopup.h
//  FirstGame
//
//  Created by Hans Yadav on 7/3/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "CCNode.h"
@class MainScene;

@interface GameOverPopup : CCNode

// Score box Enum
typedef NS_ENUM(NSInteger, CategoryName) {
  score,
  pps,
  
  categoriesCount
};

// Main Scene
@property (nonatomic, weak) MainScene *mainScene;

// Score box array
@property (nonatomic, strong) NSMutableArray *scoreBoxes;

// Current Category
@property (nonatomic, assign) NSInteger currentCategoryIndex;

@end
