//
//  TestSubClass.m
//  ZHYCodingModel
//
//  Created by John Henry on 2016/12/29.
//  Copyright © 2016年 John Henry. All rights reserved.
//

#import "TestSubClass.h"

@interface TestSubClass () {
    /** Basic data type */
    float _floatValue;
    double _doubleValue;
}

@end

@implementation TestSubClass

- (instancetype)init {
    self = [super init];
    if (self) {
        _floatValue = 2.0f;
        _doubleValue = 2017.0;
    }

    return self;
}

- (void)setFloat2:(float)f {
    _floatValue = f;
}

- (void)printAddress {
    NSLog(@"_floatValue %p\n", &_floatValue);
    NSLog(@"_doubleValue: %p\n", &_doubleValue);

    [super printAddress];
}

- (id<NSCoding>)willEncodeValue:(id)value forKey:(NSString *)key inClass:(Class)cls {
    if (cls == [self class]) {
        return value;
    }

    return [super willEncodeValue:value forKey:key inClass:cls];
}

@end
