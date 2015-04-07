//
//  GenericTableColumn.h
//  NITableGridDemo
//
//  Created by Your Company Name on 25/04/13.
//  Copyright (c) 2015 Your Company Name. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Definitions.h"




@interface GenericTableColumn : NSObject 
{
    NSString* name;
    NSString* header;
    
    NSNumber* width;
    ColumnType columnType;
    NSInteger precision;
    NSTextAlignment alignment;
}


@property (nonatomic, retain) NSString* name;
@property (nonatomic, retain) NSString* header;
@property (nonatomic, retain) NSNumber* width;
@property (nonatomic, assign) ColumnType columnType;
@property (nonatomic, assign) NSInteger precision;
@property (nonatomic, assign) NSTextAlignment alignment;

-(GenericTableColumn*) copyColumn;

@end
