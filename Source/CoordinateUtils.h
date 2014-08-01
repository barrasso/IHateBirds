//
//  CoordinateUtils.h
//  FirstGame
//
//  Created by Hans Yadav on 7/14/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CoordinateUtils : NSObject

+ (float)slopeBetweenFirstPoint:(CGPoint)first secondPoint:(CGPoint)second;
+ (float)yInterceptWithSlope:(float)slope coordinate:(CGPoint)coordinate;
+ (float)angleBetweenStartPoint:(CGPoint)start endPoint:(CGPoint)end;

@end
