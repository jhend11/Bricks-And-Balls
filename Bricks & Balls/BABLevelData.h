//
//  BABLevelData.h
//  Bricks & Balls
//
//  Created by JOSH HENDERSHOT on 8/8/14.
//  Copyright (c) 2014 Joshua Hendershot. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BABLevelData : NSObject

+(BABLevelData*) mainData;

@property (nonatomic) int topScore;

@property (nonatomic) int currentLevel;

-(NSDictionary*)levelInfo;

@end
