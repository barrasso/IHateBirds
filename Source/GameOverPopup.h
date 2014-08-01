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

typedef NS_ENUM(NSInteger, CategoryName) {
  score,
  pps,
  
  categoriesCount
};

@property (nonatomic, weak) MainScene *mainScene;
// @property (nonatomic, strong) NSMutableDictionary *categoryNames;
@property (nonatomic, strong) NSMutableArray *scoreBoxes;
@property (nonatomic, assign) NSInteger currentCategoryIndex;

@end
