//
//  BABLevelData.m
//  Bricks & Balls
//
//  Created by JOSH HENDERSHOT on 8/8/14.
//  Copyright (c) 2014 Joshua Hendershot. All rights reserved.
//

#import "BABLevelData.h"

@implementation BABLevelData
{
    NSArray * levels;
}

+(BABLevelData*) mainData
{
    static dispatch_once_t create;
    static BABLevelData * singleton = nil;
    dispatch_once(&create,
    ^{
        singleton = [[BABLevelData alloc]init];
    });
    return singleton;
}
-(id)init
{
    self = [super init];
    if (self)
    {
        NSUserDefaults * nsDefaults = [NSUserDefaults standardUserDefaults];
        self.topScore = (int)[nsDefaults integerForKey:@"topScore"];
        
        levels = @[
                   @{
                       @"cols":@6,
                       @"rows":@3
                       },
                   @{
                       @"cols": @7,
                       @"rows":@4
                      },
                   @{
                       @"cols": @8,
                       @"rows":@6
                       }
                   ];
    }
    return  self;
}

-(void)setTopScore:(int)topScore
{
    _topScore = topScore;
    NSUserDefaults * nsDefaults = [NSUserDefaults standardUserDefaults];
    [nsDefaults setInteger:topScore forKey:@"topScore"];
    [nsDefaults synchronize];
}
-(void)setCurrentLevel:(int)currentLevel
{
    _currentLevel = currentLevel;
    if (currentLevel >= levels.count)
    {
        _currentLevel = 0;
    }
}
-(NSDictionary*)levelInfo
{
    return levels[self.currentLevel];
}

@end
