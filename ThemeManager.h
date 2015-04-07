//
//  ThemeManager.h
//  NITableGridDemo
//
//  Created by Your Company Name on 25/04/13.
//  Copyright (c) 2015 Your Company Name. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Definitions.h"

@class ThemeManager;


extern ThemeManager *g_ThemeManager; 



@interface ThemeManager : NSObject 
{
	
}



+ (ThemeManager *)instance;


-(UIColor*) getThemeColor;
-(UIColor*) getTableButtonBarColor;
-(UIColor*) getButtonBarTextColor;
-(UIColor*) getCellTextColor;
-(UIColor*) getViewTextColor;
-(UIImage*) getActionButtonImage;

-(UIColor*) getSecondThemeColor;
-(UIColor*) getThirdThemeColor;

@end