//
//  Def.m
//  NITableGridDemo
//
//  Created by Your Company Name on 25/04/13.
//  Copyright (c) 2015 Your Company Name. All rights reserved.
//

#import "Definitions.h"

char* reportNames[] = {"DemoTable"};



NSString* convertField(id field)
{
    NSString* value = @"";
    
    if ([field isKindOfClass:[NSNumber class]])
    {
        value = [field stringValue];
    }
    else if ([field isKindOfClass:[NSString class]])
    {
        value = field;
    }
    else if (field == nil || [field isKindOfClass:[NSNull class]])
    {
        //NSLog(@"Error: Definitions: null value");
    }
    else
    {
        //NSLog(@"Error: Definitions: dont know what to get out of this value");
    }
    // NSLog(@"Values is %@", value);
    return value;
}

