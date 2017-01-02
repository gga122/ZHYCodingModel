//
//  ZHYDuplicatedVarNameTestClass.m
//  ZHYCodingModel
//
//  Created by Henry on 2017/1/2.
//  Copyright © 2017年 John Henry. All rights reserved.
//

#import "ZHYDuplicatedVarNameTestClass.h"

@interface ZHYDuplicatedVarNameTestClass () {
    NSArray<NSNumber *> *_arrayValue;
    const char *_cStringValue;
}

@end

@implementation ZHYDuplicatedVarNameTestClass

@synthesize arrayDuplicatedValue = _arrayValue;
@synthesize cStringDuplicatedValue = _cStringValue;

#pragma mark - Overridden

- (instancetype)init {
    self = [super init];
    if (self) {
        _arrayValue = @[@(1991), @(8), @(26)];
        _cStringValue = "abc\0";
    }
    
    return self;
}

- (BOOL)isEqual:(id)object {
    if (![object isKindOfClass:[ZHYDuplicatedVarNameTestClass class]]) {
        return NO;
    }
    
    return [self isEqualToZHYDuplicatedVarNameTestClass:object];
}

#pragma mark - Private Methods

- (BOOL)isEqualToZHYDuplicatedVarNameTestClass:(ZHYDuplicatedVarNameTestClass *)object {
    if (object.arrayDuplicatedValue.count != _arrayValue.count) {
        return NO;
    }
    
    if (strcmp(object.cStringDuplicatedValue, _cStringValue) != 0) {
        return NO;
    }
    
    return [super isEqual:object];
}

@end
