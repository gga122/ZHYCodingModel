//
//  ZHYSystemStructTestClass.m
//  ZHYCodingModel
//
//  Created by MickyZhu on 8/3/2017.
//  Copyright © 2017 John Henry. All rights reserved.
//

#import "ZHYSystemStructTestClass.h"

@implementation ZHYSystemStructTestClass

- (instancetype)init {
    self = [super init];
    if (self) {
        _rect = CGRectMake(1, 2, 3, 4);
        _point = CGPointMake(8, 26);
        _size = CGSizeMake(7, 25);
    }
    
    return self;
}

- (BOOL)isEqual:(id)object {
    if (![object isKindOfClass:[ZHYSystemStructTestClass class]]) {
        return NO;
    }
    
    return [self isEqualToZHYSystemStructTestClass:object];
}

- (BOOL)isEqualToZHYSystemStructTestClass:(ZHYSystemStructTestClass *)object {
    if (!CGRectEqualToRect(object->_rect, _rect)) {
        return NO;
    }
    
    if (!CGPointEqualToPoint(object->_point, _point)) {
        return NO;
    }
    
    if (!CGSizeEqualToSize(object->_size, _size)) {
        return NO;
    }
    
    return YES;
}

@end
