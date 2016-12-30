//
//  TestClass.m
//  ZHYCodingModel
//
//  Created by John Henry on 2016/12/29.
//  Copyright © 2016年 John Henry. All rights reserved.
//

#import "TestClass.h"

struct cStruct1 {
    int arguement1;
    double arguement2;
};

struct cStruct2 {
    char arguement1;
    float arguement2;
};

union cUnion {
    struct cStruct1 cStruct1;
    struct cStruct2 cStruct2;
};

@interface TestClass () {

    /** Basic data type */
    float _floatValue;
    double _doubleValue;

    short _shortValue;
    unsigned short _unsignedShortValue;

    int _intValue;
    unsigned int _unsignedIntValue;

    long _longValue;
    unsigned long _unsignedLongValue;

    long long _longlongValue;
    unsigned long long _unsignedLongLongValue;

    char _charValue;
    bool _cBoolValue;
    BOOL _boolValue;

    void *_ptrValue;

    /** C data type */
    const char *_cStringValue;
    char _cArrayValue[3];

    struct cStruct1 _cStructValue;
    union cUnion _cUnionValue;
    CGRect _rectValue;

    /** Objective-C data type */
    const NSString *_stringValue;
    NSDictionary *_dictionaryValue;
}

@end

@implementation TestClass

- (instancetype)init {
    self = [super init];
    if (self) {
        _floatValue = 1.0f;
        _doubleValue = 2016.0;

        _shortValue = -1;
        _unsignedShortValue = 1;

        _intValue = - 10000;
        _unsignedIntValue = 10000;

        _longValue = -10000000;
        _unsignedLongValue = 10000000;

        _longlongValue = -10000000000;
        _unsignedLongLongValue = 10000000000;

        _charValue = 'c';
        _cBoolValue = true;
        _boolValue = YES;

        _ptrValue = (__bridge void *)(self);

        _cStringValue = "hello world\0";

        _cArrayValue[0] = 'a';
        _cArrayValue[1] = 'b';
        _cArrayValue[2] = 'c';

        _cStructValue.arguement1 = 9;
        _cStructValue.arguement2 = 19.0;

        _cUnionValue.cStruct2.arguement1 = 'z';
        _cUnionValue.cStruct2.arguement2 = 11.0f;

        _rectValue = CGRectMake(0, 1, 2, 3);

        _stringValue = @"string";
        _dictionaryValue = @{@"key": @"value"};
    }

    return self;
}

- (void)printAddress {
    NSLog(@"_floatValue %p\n", &_floatValue);
    NSLog(@"_doubleValue: %p\n", &_doubleValue);

    NSLog(@"_shortValue: %p\n", &_shortValue);
}

- (void)setFloat:(float)f {
    _floatValue = f;
}

+ (NSArray<NSString *> *)skipIvarKeys {
    return @[@"_ptrValue"];
}

- (id<NSCoding>)willEncodeValue:(id)value forKey:(NSString *)key inClass:(Class)cls {
    if ([key isEqualToString:@"_stringValue"]) {
        return @"dummyString_1";
    }
    return value;
}

- (id)willDecodeValue:(id<NSCoding>)value forKey:(NSString *)key inClass:(Class)cls {
    if ([key isEqualToString:@"_stringValue"]) {
        return @"dummyString_2";
    }
    return value;
}

@end
