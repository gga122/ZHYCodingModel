//
//  ZHYBaseTypeTestClass.m
//  ZHYCodingModel
//
//  Created by Henry on 2016/12/31.
//  Copyright © 2016年 John Henry. All rights reserved.
//

#import "ZHYBaseTypeTestClass.h"

@implementation ZHYBaseTypeTestClass

#pragma mark - Overridden

- (instancetype)init {
    self = [super init];
    if (self) {
        _shortValue = 1;
        _intValue = 2;
        _longValue = 3;
        _longLongValue = 4;
        _floatValue = 5.0f;
        _doubleValue = 6.0;
        _charValue = 'a';
        _boolValue = true;
        _BOOLValue = YES;
    }
    
    return self;
}

- (BOOL)isEqual:(id)object {
    if (![object isKindOfClass:[ZHYBaseTypeTestClass class]]) {
        return NO;
    }
    
    return [self isEqualToZHYBaseTypeTestClass:object];
}

#pragma mark - Private Methods

- (BOOL)isEqualToZHYBaseTypeTestClass:(ZHYBaseTypeTestClass *)object {
    if (object.shortValue != _shortValue) {
        return NO;
    }
    
    if (object.intValue != _intValue) {
        return NO;
    }
    
    if (object.longValue != _longValue) {
        return NO;
    }
    
    if (object.longLongValue != _longLongValue) {
        return NO;
    }
    
    if (object.floatValue != _floatValue) {
        return NO;
    }
    
    if (object.doubleValue != _doubleValue) {
        return NO;
    }
    
    if (object.charValue != _charValue) {
        return NO;
    }
    
    if (object.boolValue != _boolValue) {
        return NO;
    }
    
    if (object.BOOLValue != _BOOLValue) {
        return NO;
    }
    
    return [super isEqual:object];
}

@end
