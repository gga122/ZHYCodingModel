//
//  ZHYTestClass.h
//  ZHYCodingModel
//
//  Created by Henry on 2016/12/31.
//  Copyright © 2016年 John Henry. All rights reserved.
//

#import "ZHYCodingModel.h"

/**
 *  This class is designed to test Objective-C objects coding.
 */

@interface ZHYTestClass : ZHYCodingModel

@property (nonatomic, copy) NSString *stringValue;
@property (nonatomic, strong) NSArray<NSString *> *arrayValue;

@end
