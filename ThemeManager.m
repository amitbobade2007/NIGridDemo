//
//  ThemeManager.m
//  NITableGridDemo
//
//  Created by Your Company Name on 25/04/13.
//  Copyright (c) 2015 Your Company Name. All rights reserved.
//

#import "ThemeManager.h"


ThemeManager *g_ThemeManager;


@implementation ThemeManager




+ (void)initialize
{
    static BOOL man_initialized = NO;
    if(!man_initialized)
    {
        man_initialized = YES;
        g_ThemeManager = [[ThemeManager alloc] init];
    }
}


+ (ThemeManager *)instance
{
	return (g_ThemeManager);
}


- (ThemeManager*) init
{
//	[super init];
	
  	return self;
}


-(void) dealloc 
{
//	[super dealloc];
}


-(UIImage*) getActionButtonImage
{
    return [UIImage imageNamed:@"Go.png"];
}


-(UIColor*) getViewTextColor
{	
    return [UIColor whiteColor];
}



-(UIColor*) getThemeColor
{	
    return [UIColor blackColor];
}


-(UIColor*) getSecondThemeColor
{	
    return [UIColor colorWithRed:0.411 green:0.733 blue:0.203 alpha:1];
}


-(UIColor*) getThirdThemeColor
{	
    return [UIColor whiteColor];
}



-(UIColor*) getTableButtonBarColor
{
    return [self getSecondThemeColor];
}


-(UIColor*) getButtonBarTextColor
{
    return [UIColor whiteColor];
}


-(UIColor*) getCellTextColor
{
    return [UIColor blackColor];
}

@end












