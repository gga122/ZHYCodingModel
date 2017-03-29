//
//  ZHYRectModel.m
//  ZHYCodingModel
//
//  Created by MickyZhu on 29/3/2017.
//  Copyright © 2017 John Henry. All rights reserved.
//

#import "ZHYRectModel.h"

@interface ZHYRectModel ()

@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;

@end

@implementation ZHYRectModel

#pragma mark - DESIGNATED INITIALIZER

- (instancetype)initWithRectPtr:(CGRect *)rect {
    self = [super init];
    if (self) {
        _x = rect->origin.x;
        _y = rect->origin.y;
        _width = rect->size.width;
        _height = rect->size.height;
    }
    
    return self;
}

#pragma mark - ZHYStructConvertible

+ (instancetype)objectFromStruct:(void *)s {
    CGRect *rectPtr = s;
    
    ZHYRectModel *rectModel = [[ZHYRectModel alloc] initWithRectPtr:rectPtr];
    return rectModel;
}

- (void)restoreToStruct:(void *)s {
    CGRect *rectPtr = s;
    
    rectPtr->origin.x = _x;
    rectPtr->origin.y = _y;
    rectPtr->size.width = _width;
    rectPtr->size.height = _height;
}

- (NSString *)objCType {
    return [NSString stringWithCString:@encode(CGRect) encoding:NSASCIIStringEncoding];
}

@end
