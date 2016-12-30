//
//  ZHYCodingModel.h
//  ZHYCodingModel
//
//  Created by John Henry on 2016/12/28.
//  Copyright © 2016年 John Henry. All rights reserved.
//

#import <Foundation/Foundation.h>

#define ENCODING_MODEL_ENABLE_LOG           1

/**
 *  Automatic encode and decode model for Objective-C
 *
 *  If you want to encode and decode automatic, inherit this class.
 *
 *  NOTICE:
 *  1. Support 'Object Type' in Objective-C and 'Non-Object Type' which supported by KVC. See https://developer.apple.com/library/content/documentation/Cocoa/Conceptual/KeyValueCoding/DataTypes.html#//apple_ref/doc/uid/20002171-BAJEAIEE
 *  2. Support skip specified keys for subclass. skipKey is your instance variable name.
 *  3. Support to replace value when encode/decode.
 *  4. Pointer, C Array, struct, union, C String are NOT support. 
 */

/**
 *  Define behavior for coding class.
 */
@protocol ZHYCodingClassProtocol <NSObject>

@optional

@property (nonatomic, class, readonly) NSArray<NSString *> *skipIvarKeys;

- (void)encodeNilValueForKey:(NSString *)key;
- (void)decodeNilValueForKey:(NSString *)key;

- (id<NSCoding>)willEncodeValue:(id)value forKey:(NSString *)key inClass:(Class)cls;
- (id)willDecodeValue:(id<NSCoding>)value forKey:(NSString *)key inClass:(Class)cls;

@end


@interface ZHYCodingModel : NSObject <NSCoding, ZHYCodingClassProtocol>

/**
 *  Mark the keys that you dont want to encode/decode. Key is your instance variable name in class. Like NSString *_string, key is '_string'.
 */
@property (nonatomic, class, readonly) NSArray<NSString *> *skipIvarKeys;

/**
 *  This method will call after found a nil variable in class encode. Default implementation is print log in console.
 */
- (void)encodeNilValueForKey:(NSString *)key inClass:(Class)cls;

/**
 *  This method will call after found a nil variable in class decode. Default implementation is print log in console.
 */
- (void)decodeNilValueForKey:(NSString *)key inClass:(Class)cls;

/**
 *  You can replace encode value for specified key.
 *
 *  NOTICE:
 *  1. You MUST ensure a same key has same type value.
 */
- (id<NSCoding>)willEncodeValue:(id)value forKey:(NSString *)key inClass:(Class)cls;

/**
 *  Your can replace decode value for specified key.
 */
- (id)willDecodeValue:(id<NSCoding>)value forKey:(NSString *)key inClass:(Class)cls;

/**
 *  Coding model will call [super init] in '-init' method.
 *  If you implement custom designated initializer method and expect to use it with decode. Do like this.
 *
 *  1. Overridden '-initWithCoder:'
 *  2. Call your custom designated initializer method.
 *  3. call '-coderWillDecode:'
 *
 *  Templete:
 *  - (instancetype)initWithCoder:(NSCoder *)aDecoder {
 *      self = [super initWithXXX:<#arguement#>];
 *      if (self) {
 *          [self coderWillDecode:aDecoder];
 *      }
 *
 *      return self;
 *  }
 *
 */
- (void)coderWillDecode:(NSCoder *)aDecoder;

@end
