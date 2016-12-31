//
//  ZHYCodingModel.m
//  ZHYCodingModel
//
//  Created by John Henry on 2016/12/28.
//  Copyright © 2016年 John Henry. All rights reserved.
//

#import "ZHYCodingModel.h"
#import <objc/objc-runtime.h>

#define LOG_CONDITION(condition)                    (condition) && ENCODING_MODEL_ENABLE_LOG

NS_INLINE NSString *NSStringFromIvarName(Ivar ivar) {
    if (!ivar) {
        return nil;
    }

    const char *cVarName = ivar_getName(ivar);
    NSString *varName = [NSString stringWithUTF8String:cVarName];

    return varName;
}

NS_INLINE BOOL isAllowedEncodingIvar(Ivar ivar) {
    if (!ivar) {
        return NO;
    }

    const char *encodingType = ivar_getTypeEncoding(ivar);
    const char typeFlag = encodingType[0];

    /**
     *  Objective-C runtime encoding type.
     *  See https://developer.apple.com/library/content/documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Articles/ocrtTypeEncodings.html
     *
     *  In C array/union/struct etc. may have 'object' type or basic data type (like int/float/double). It's hard to figure out which part need to encode as 
     *  caller wished. So, I ban those type.
     *  See https://developer.apple.com/library/content/documentation/Cocoa/Conceptual/Archiving/Articles/codingctypes.html#//apple_ref/doc/uid/20001294-BBCBDHBI
     */
    switch (typeFlag) {
        case _C_CLASS:
        case _C_SEL:
        case _C_VOID:
        case _C_UNDEF:
        case _C_PTR:
        case _C_CHARPTR:
        case _C_ATOM:
        case _C_ARY_B:
        case _C_ARY_E:
        case _C_UNION_B:
        case _C_UNION_E:
        case _C_STRUCT_B:
        case _C_STRUCT_E:
        case _C_VECTOR:
        case _C_CONST: {
            return NO;
        }

        default:
            return YES;
    }
}

NS_INLINE BOOL reachRootClass(Class cls) { return cls == [ZHYCodingModel class]; }

static NSString * const kZHYCodingModelErrorDomain = @"cn.zhy.error.codingModel";

static NSString * const kZHYCodingModelReplacePrefix = @"_zhy_replace_";

@implementation ZHYCodingModel

#pragma mark - NSCoding

#define VAR_LENGTH_CHECK(name)\
if ((name).length == 0) {\
    NSAssert(NO, @"Unexpected branch reached. Contact to author for help. <CallStack: %@>", [NSThread callStackSymbols]);\
    continue;\
}\

#define HAS_SKIP_CHECK(name)\
if ([cls.skipIvarKeys containsObject:(name)]) {\
    continue;\
}\

#define ENCODE_TYPE_CHECK(ivar, varName)\
if (!isAllowedEncodingIvar(ivar)) {\
    if (ENCODING_MODEL_ENABLE_LOG) {\
        NSLog(@"***** Warn ***** Invalid type for coding. <varName: %@>", varName);\
    }\
    continue;\
}\

#define ENCODE_NIL_CHECK(object, cls)\
if (!object) {\
    [self encodeNilValueForKey:object inClass:cls];\
    continue;\
}\

- (void)encodeWithCoder:(NSCoder *)aCoder {
    Class<ZHYCodingProtocol> cls = [self class];

    while (!reachRootClass(cls)) {        // recursion ivar to root class
        NSString *clsName = NSStringFromClass(cls);

        unsigned int ivarCount = 0;
        Ivar *ivars = class_copyIvarList(cls, &ivarCount);

        for (const Ivar *p = ivars; p < ivars + ivarCount; ++p) {   // traverse ivars in current class
            Ivar const ivar = *p;

            NSString *varName = NSStringFromIvarName(ivar);

            VAR_LENGTH_CHECK(varName);
            HAS_SKIP_CHECK(varName);
            ENCODE_TYPE_CHECK(ivar, varName);

            id var = [self valueForKey:varName];
            ENCODE_NIL_CHECK(var, cls);

            id replaceVar = [self willEncodeValue:var forKey:varName inClass:cls];
            ENCODE_NIL_CHECK(replaceVar, cls);

            if ([replaceVar conformsToProtocol:@protocol(NSCoding)]) {
                /* Use class name as prefix to avoid superclass' key over subclass' key */
                NSString *encodeKey = [NSString stringWithFormat:@"%@_%@", clsName, varName];
                BOOL didReplace = (var != replaceVar);
                if (didReplace) {
                    encodeKey = [NSString stringWithFormat:@"%@%@", kZHYCodingModelReplacePrefix, encodeKey];
                }

                [aCoder encodeObject:replaceVar forKey:encodeKey];
            } else {
                NSLog(@"***** Warn ***** Invalid value for encode. <varName: %@><var: %@>", varName, var);
            }
        }

        if (ivars) {
            free(ivars);
        }

        cls = class_getSuperclass(cls);
    }
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        [self coderWillDecode:aDecoder];
    }

    return self;
}

#pragma mark - Public Methods

- (void)coderWillDecode:(NSCoder *)aDecoder {
    Class<ZHYCodingProtocol> cls = [self class];

    while (!reachRootClass(cls)) {        // recursion ivar to root class
        NSString *clsName = NSStringFromClass(cls);

        unsigned int ivarCount = 0;
        Ivar *ivars = class_copyIvarList(cls, &ivarCount);

        for (const Ivar *p = ivars; p < ivars + ivarCount; ++p) {   // traverse ivars in current class
            Ivar const ivar = *p;

            NSString *varName = NSStringFromIvarName(ivar);

            VAR_LENGTH_CHECK(varName);
            HAS_SKIP_CHECK(varName);
            ENCODE_TYPE_CHECK(ivar, varName);

            NSString *decodeKey = [NSString stringWithFormat:@"%@_%@", clsName, varName];

            id<NSCoding> var = [aDecoder decodeObjectForKey:decodeKey];
            if (!var) { // try replaceKey
                decodeKey = [NSString stringWithFormat:@"%@%@", kZHYCodingModelReplacePrefix, decodeKey];
                var = [aDecoder decodeObjectForKey:decodeKey];
            }

            if (var) {
                id replaceVar = [self willDecodeValue:var forKey:varName inClass:cls];

                object_setIvar(self, ivar, replaceVar);
//                [self setValue:replaceVar forKey:varName];
            } else {
                [self decodeNilValueForKey:varName inClass:cls];
            }
        }

        if (ivars) {
            free(ivars);
        }

        cls = class_getSuperclass(cls);
    }
}

#pragma mark - ZHYCodingClassProtocol

+ (NSArray<NSString *> *)skipIvarKeys {
    return nil;
}

- (void)encodeNilValueForKey:(NSString *)key inClass:(__unsafe_unretained Class)cls {
    if (LOG_CONDITION(![[self class].skipIvarKeys containsObject:key])) {
        NSLog(@"***** Info ***** Value for encode '%@' is nil in '%@'.", key, cls);   // nil object
    }
}

- (void)decodeNilValueForKey:(NSString *)key inClass:(__unsafe_unretained Class)cls {
    if (LOG_CONDITION(![[self class].skipIvarKeys containsObject:key])) {
        NSLog(@"***** Info ***** Value for decode '%@' is nil in '%@'.", key, cls);   // nil object
    }
}

- (id<NSCoding>)willEncodeValue:(id)value forKey:(NSString *)key inClass:(__unsafe_unretained Class)cls {
    return value;
}

- (id)willDecodeValue:(id<NSCoding>)value forKey:(NSString *)key inClass:(__unsafe_unretained Class)cls {
    return value;
}

@end
