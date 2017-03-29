//
//  ZHYSizeModel.m
//  ZHYCodingModel
//
//  Created by MickyZhu on 29/3/2017.
//  Copyright © 2017 John Henry. All rights reserved.
//

#import "ZHYSizeModel.h"

@interface ZHYSizeModel ()

@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;

@end

@implementation ZHYSizeModel

#pragma mark - DESIGNATED INITIALIZER

- (instancetype)initWithSizePtr:(CGSize *)size {
    self = [super init];
    if (self) {
        _width = size->width;
        _height = size->height;
    }
    
    return self;
}

#pragma mark - ZHYStructConvertible

+ (instancetype)objectFromStruct:(void *)s {
    CGSize *sizePtr = s;
    
    ZHYSizeModel *sizeModel = [[ZHYSizeModel alloc] initWithSizePtr:sizePtr];
    return sizeModel;
}

- (void)restoreToStruct:(void *)s {
    CGSize *sizePtr = s;
    
    sizePtr->width = _width;
    sizePtr->height = _height;
}

- (NSString *)objCType {
    return [NSString stringWithCString:@encode(CGSize) encoding:NSASCIIStringEncoding];
}

@end
