//
//  ZHYPointModel.m
//  ZHYCodingModel
//
//  Created by MickyZhu on 29/3/2017.
//  Copyright © 2017 John Henry. All rights reserved.
//

#import "ZHYPointModel.h"

@interface ZHYPointModel ()

@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;

@end

@implementation ZHYPointModel

#pragma mark - DESIGNATED INITIALIZER

- (instancetype)initWithPointPtr:(CGPoint *)point {
    self = [super init];
    if (self) {
        _x = point->x;
        _y = point->y;
    }
    
    return self;
}

#pragma mark - ZHYStructConvertible

+ (instancetype)objectFromStruct:(void *)s {
    CGPoint *pointPtr = s;
    
    ZHYPointModel *pointModel = [[ZHYPointModel alloc] initWithPointPtr:pointPtr];
    return pointModel;
}

- (void)restoreToStruct:(void *)s {
    CGPoint *pointPtr = s;
    
    pointPtr->x = _x;
    pointPtr->y = _y;
}

- (NSString *)objCType {
    return [NSString stringWithCString:@encode(CGPoint) encoding:NSASCIIStringEncoding];
}

@end
