//
//  objects.m
//  NIGridDemo
//
//  Created by Your Company Name.
//  Copyright (c) 2015 Your Company Name. All rights reserved.
//

#import "objects.h"
#import "GenericTableColumn.h"
#import <objc/runtime.h>
@implementation objects
@synthesize description, subject;

-(id)init
{
    self = [super init];
    if(self)
    {

    }
    return self;
}

+(NSArray *)getClassColumns//:(NSArray*__autoreleasing *)a
{
    float totalWidth = 0.0;
    NSMutableArray* columns = [NSMutableArray arrayWithCapacity:0];
    GenericTableColumn* column = [[GenericTableColumn alloc] init];
    column.name = @"subject";
    column.header = @"subject";
    column.columnType = String;
    column.width = [NSNumber numberWithFloat:1.0];
    column.precision = 1.0;
    column.alignment = NSTextAlignmentLeft;
    
    GenericTableColumn* column1 = [[GenericTableColumn alloc] init];
    column1.name = @"description";
    column1.header = @"description";
    column1.columnType = Text;
    column1.width = [NSNumber numberWithFloat:2.0];
    column1.precision = 1.0;
    column1.alignment = NSTextAlignmentLeft;
    
    totalWidth += 3;

    [columns addObject:column];
    [columns addObject:column1];

    for (GenericTableColumn* column in columns)
    {
        CGFloat width = [column.width floatValue];
        column.width =[NSNumber numberWithInt: (width / totalWidth)  * FULLWIDTH];
    }
    return columns;

}

@end
