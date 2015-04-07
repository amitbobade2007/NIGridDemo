//
//  GenericModelClass.h
//  NIGridDemo
//
//  Created by Your Company Name.
//  Copyright (c) 2015 Your Company Name. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GenericModelClass : NSObject

- (NSDictionary *)allPropertyNamesAndValues;
+(NSArray *)getClassColumns;//:(NSArray *__autoreleasing *)a;

@end
