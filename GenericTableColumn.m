//
//  GenericTableColumn.m
//  NITableGridDemo
//
//  Created by Your Company Name on 25/04/13.
//  Copyright (c) 2015 Your Company Name. All rights reserved.
//

#import "GenericTableColumn.h"


@implementation GenericTableColumn

@synthesize name;
@synthesize header;
@synthesize width;
@synthesize columnType;
@synthesize precision;
@synthesize alignment;


-(GenericTableColumn*) copyColumn
{
    GenericTableColumn* returnColumn = [[GenericTableColumn alloc] init];
    
    returnColumn.name = self.name;
    returnColumn.header = self.header;
    returnColumn.width = self.width;
    returnColumn.columnType = self.columnType;
    returnColumn.precision = self.precision;
    returnColumn.alignment = self.alignment;
    
    return returnColumn;
}


- (void)dealloc
{
    self.name = nil;
    self.header = nil;
    self.width = nil;
}



- (void)encodeWithCoder:(NSCoder *)coder 
{
    //[super encodeWithCoder:coder];
    
    [coder encodeObject:name        forKey:@"name"];
    [coder encodeObject:header      forKey:@"header"];
    [coder encodeObject:width       forKey:@"width"];
    [coder encodeInt:columnType     forKey:@"columnType"];
    [coder encodeInteger:precision  forKey:@"precision"];
    [coder encodeInt:alignment      forKey:@"alignment"];
}



- initWithCoder:(NSCoder *)coder 
{
    self = [super init];
    
    self.name       = [coder decodeObjectForKey:@"name"];
    self.header     = [coder decodeObjectForKey:@"header"];
    self.width      = [coder decodeObjectForKey:@"width"];
    self.columnType = [coder decodeIntForKey:@"columnType"];
    self.precision  = [coder decodeIntegerForKey:@"precision"];
    self.alignment  = [coder decodeIntForKey:@"alignment"];
        
    return self;
}



@end
