//
//  ZHYTestClass.m
//  ZHYCodingModel
//
//  Created by Henry on 2016/12/31.
//  Copyright © 2016年 John Henry. All rights reserved.
//

#import "ZHYTestClass.h"

@implementation ZHYTestClass

#pragma mark - Overridden

- (instancetype)init {
    self = [super init];
    if (self) {
        _stringValue = @"testStringValue";
        
        _arrayValue = @[@"test1", @"test2", @"test3"];
    }
    
    return self;
}

- (BOOL)isEqual:(id)object {
    if (![object isKindOfClass:[ZHYTestClass class]]) {
        return NO;
    }
    
    return [self isEqualToZHYTestClass:object];
}

#pragma mark - ZHYCodingProtocol

- (id<NSCoding>)willEncodeValue:(id)value forKey:(NSString *)key inClass:(Class)cls {
    return value;
}

- (id)willDecodeValue:(id<NSCoding>)value forKey:(NSString *)key inClass:(Class)cls {
    return value;
}

#pragma mark - Private Methods

- (BOOL)isEqualToZHYTestClass:(ZHYTestClass *)object {
    if (![object.stringValue isEqualToString:_stringValue]) {
        return NO;
    }
    
    if (object.arrayValue.count != _arrayValue.count) {
        return NO;
    }
    
    NSInteger count = _arrayValue.count;
    for (NSInteger i = 0; i < count; ++i) {
        NSString *aString = object.arrayValue[i];
        NSString *bString = _arrayValue[i];
        
        if (![aString isEqualToString:bString]) {
            return NO;
        }
    }
    
    return YES;
}

@end
