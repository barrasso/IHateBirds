//
//  CoordinateUtils.h
//  FirstGame
//
//  Created by Hans Yadav on 7/14/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CoordinateUtils : NSObject

// Calculate Slope
+ (float)slopeBetweenFirstPoint:(CGPoint)first secondPoint:(CGPoint)second;

// Y Intercept
+ (float)yInterceptWithSlope:(float)slope coordinate:(CGPoint)coordinate;

// Calculate Angle
+ (float)angleBetweenStartPoint:(CGPoint)start endPoint:(CGPoint)end;

@end
