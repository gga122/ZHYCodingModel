//
//  ZHYDuplicatedVarNameTestClass.h
//  ZHYCodingModel
//
//  Created by Henry on 2017/1/2.
//  Copyright © 2017年 John Henry. All rights reserved.
//

#import "ZHYBaseTypeTestClass.h"

/**
 *  This class is designed to test duplicated variable name with coding.
 *
 *  I declared 2 varibles, named them as same as super class declared.
 *
 *  Duplicated name:
 *  1. _charValue in class 'ZHYBaseTypeTestClass'
 *  2. _arrayValue in class 'ZHYTestClass'
 *
 */

@interface ZHYDuplicatedVarNameTestClass : ZHYBaseTypeTestClass

@property (nonatomic, strong) NSArray<NSNumber *> *arrayDuplicatedValue;
@property (nonatomic, assign) char charDuplicatedValue;

@end
