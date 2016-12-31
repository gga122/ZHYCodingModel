//
//  ZHYBaseTypeTestClass.h
//  ZHYCodingModel
//
//  Created by Henry on 2016/12/31.
//  Copyright © 2016年 John Henry. All rights reserved.
//

#import "ZHYTestClass.h"

/**
 *  This class is designed to test C base types coding.
 *  
 *  C base types
 *  1. short
 *  2. int
 *  3. long
 *  4. long long
 *  5. float
 *  6. double
 *  7. char 
 *  8. bool
 *  9. BOOL
 */

@interface ZHYBaseTypeTestClass : ZHYTestClass

@property (nonatomic, assign) short shortValue;
@property (nonatomic, assign) int intValue;
@property (nonatomic, assign) long longValue;
@property (nonatomic, assign) long long longLongValue;
@property (nonatomic, assign) float floatValue;
@property (nonatomic, assign) double doubleValue;
@property (nonatomic, assign) char charValue;
@property (nonatomic, assign) bool boolValue;
@property (nonatomic, assign) BOOL BOOLValue;

@end
