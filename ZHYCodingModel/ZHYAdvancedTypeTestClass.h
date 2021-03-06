//
//  ZHYAdvancedTypeTestClass.h
//  ZHYCodingModel
//
//  Created by Henry on 2016/12/31.
//  Copyright © 2016年 John Henry. All rights reserved.
//

#import "ZHYBaseTypeTestClass.h"
#import <CoreGraphics/CoreGraphics.h>

/**
 *  This class is designed to test C advanced types coding.
 *
 *  C advanced types
 *  1. pointer
 *  2. string
 *  3. array
 *  4. struct
 *  5. union
 *
 */

union unionType {
    CGRect rect;
    CGPoint point;
};

static int const kZHYAdvancedTypeTestClassArraySize = 3;

@interface ZHYAdvancedTypeTestClass : ZHYBaseTypeTestClass {
    @private
    char _charArray[kZHYAdvancedTypeTestClassArraySize];
}

@property (nonatomic, assign) void *ptrValue;
@property (nonatomic, assign) const char *cStringValue;

@property (nonatomic, assign) CGRect rectValue;
@property (nonatomic, assign) union unionType unionValue;

- (BOOL)isCArrayEqualTo:(ZHYAdvancedTypeTestClass *)object;

@end
