//
//  ZHYStructConvertible.h
//  ZHYCodingModel
//
//  Created by MickyZhu on 29/3/2017.
//  Copyright © 2017 John Henry. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ZHYStructConvertible <NSObject>

@required

+ (instancetype)objectFromStruct:(void *)s;
- (void)restoreToStruct:(void *)s;

@property (nonatomic, copy, readonly) NSString *objCType;

@end
