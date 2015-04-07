//
//  GenericModelClass.m
//  NIGridDemo
//
//  Created by Your Company Name.
//  Copyright (c) 2015 Your Company Name. All rights reserved.
//

#import "GenericModelClass.h"
#import <objc/runtime.h>
@implementation GenericModelClass


- (NSDictionary *)allPropertyNamesAndValues
{
    unsigned count;
    objc_property_t *properties = class_copyPropertyList([self class], &count);
    
//    NSMutableArray *rv = [NSMutableArray array];
    NSMutableDictionary *tempDict = [NSMutableDictionary dictionaryWithCapacity:0];
    unsigned i;
    for (i = 0; i < count; i++)
    {
        
        objc_property_t property = properties[i];
        NSString *key = [NSString stringWithUTF8String:property_getName(property)];
//        [rv addObject:key];
        
        const char *attr = property_getAttributes(property);
        const char *ivarName = strchr(attr, 'V') + 1;
        Ivar ivar = class_getInstanceVariable([self class], ivarName);
        NSString *keyValue = object_getIvar(self, ivar);
        
        [tempDict setValue:keyValue forKey:key];
//        [rv addObject:tempDict];
        
//        free(property);
    }
    
    free(properties);
    
    return tempDict;
}


#pragma class methods
+(NSArray *)getClassColumns//:(NSArray *__autoreleasing *)a
{
    return @[];
}

@end
