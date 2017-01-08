//
//  ZHYNotPairTestClass.m
//  ZHYCodingModel
//
//  Created by Henry on 2017/1/9.
//  Copyright © 2017年 John Henry. All rights reserved.
//

#import "ZHYNotPairTestClass.h"

NSString * const kZHYNotPairTestClassDecodeReplacedVar = @"replacedVar";

@implementation ZHYNotPairTestClass

- (id<NSCoding>)willEncodeValue:(id)value forKey:(NSString *)key inClass:(Class)cls {
    if ([key isEqualToString:@"_stringValue"]) {
        NSNumber *replacedVar = @(2017);
        NSLog(@"%@ will replace encode %@ with %@ for '%@'", [self class], value, replacedVar, key);
        return replacedVar;
    }
    
    return value;
}

- (id)willDecodeValue:(id<NSCoding>)value forKey:(NSString *)key inClass:(Class)cls {
    if ([key isEqualToString:@"_stringValue"]) {
        NSString *replacedVar = [kZHYNotPairTestClassDecodeReplacedVar copy];
        NSLog(@"%@ will replace decode %@ with %@ for '%@'", [self class], value, replacedVar, key);
        return replacedVar;
    }
    
    return value;
}

@end
