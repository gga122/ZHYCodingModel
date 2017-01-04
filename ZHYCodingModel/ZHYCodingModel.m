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

NS_INLINE BOOL isAllowedEncodingIvar(const char typeFlag) {
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

NS_INLINE BOOL isObjectType(const char typeFlag) {
    return (typeFlag == _C_ID);
}

NS_INLINE BOOL supportWrapper(const char typeFlag) {
    switch (typeFlag) {
        case _C_SHT:
        case _C_USHT:
        case _C_INT:
        case _C_UINT:
        case _C_LNG:
        case _C_ULNG:
        case _C_LNG_LNG:
        case _C_ULNG_LNG:
        case _C_FLT:
        case _C_DBL:
        case _C_BOOL:
        case _C_BFLD:
        case _C_CHR:
        case _C_UCHR: {
            return YES;
        }
            
        default:
            return NO;
    }
}

NS_INLINE void *pointerToIvar(void *base, Ivar ivar) {
    ptrdiff_t offset = ivar_getOffset(ivar);
    void *ptrVar = base + offset;
    
    return ptrVar;
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

/**
 *
 *  Watch out!
 *
 *  To solve duplicate var name in sub class. I use the C-style operation.
 *  I assume you know Objective-C object ivar layout.
 *  
 *  Here is a sample to tell you Objective-C object ivar layout.
 *
 *  Assume I have a class called 'Class A' with 2 ivar, ivar a and ivar b.
 *  'Class B' is subclass of 'Class A' with 2 ivar, ivar c and ivar d.
 *  'Class C' is subclass of 'Class B' with 2 ivar, ivar e and ivar f.
 *
 *  
 *  Objective-C layout ivars from superclass to subclass.
 *  So, ivar layout order is   'isa' / Class A ivars / Class B ivars / Class C ivars
 *  Class C object ivar layout is    'isa' / Class A (ivar a, ivar b) / Class B (ivar c, ivar d) / Class C (ivar e, ivar f)
 *
 *  So, Here is the steps for 'Encoding'.
 *  
 *  1. obtain 'self' to a pointer(base pointer).
 *  2. traverse inherit chain from subclass to superclass.
 *  3. traverse ivars in each class.
 *  4. get ivar name and filter out if caller wanna skip it.
 *  5. get ivar encoding type and filter out if disallowed types.
 *  6. get ivar offset and add it to base pointer for getting ivar value.
 *  7. if ivar is C base type or CGRect/CGPoint etc., transform it.
 *  8. if ivar conforms to 'NSCoding' protocol, tell caller will encode ivar.
 *
 *  PS1. I use class name as prefix to solve duplicate name problem.
 *  PS2. To recognize replaced ivar, I add a unique prefix before original encode key.
 */

- (void)encodeWithCoder:(NSCoder *)aCoder {
    Class<ZHYCodingProtocol> cls = [self class];

    void *ptrBase = (__bridge void *)self;
    
    while (!reachRootClass(cls)) {        // recursion ivar to root class
        NSString *clsName = NSStringFromClass(cls);

        unsigned int ivarCount = 0;
        Ivar *ivars = class_copyIvarList(cls, &ivarCount);

        for (const Ivar *p = ivars; p < ivars + ivarCount; ++p) {   // traverse ivars in current class
            Ivar const ivar = *p;

            NSString *varName = NSStringFromIvarName(ivar);

            const char *encodingType = ivar_getTypeEncoding(ivar);
            const char typeFlag = encodingType[0];
            
            VAR_LENGTH_CHECK(varName);
            HAS_SKIP_CHECK(varName);
            ENCODE_TYPE_CHECK(typeFlag, varName);

            id var;
            if (isObjectType(typeFlag)) {
                var = object_getIvar(self, ivar);
            } else if (supportWrapper(typeFlag)) {
                void *ptrVar = pointerToIvar(ptrBase, ivar);
                NSValue *valueWrapper = [NSValue value:ptrVar withObjCType:encodingType]; // Wrap with NSValue
                
                var = valueWrapper;
            } else {
                NSAssert(NO, @"Invalid encode branch. <Type: %s>", encodingType);
            }
    
            ENCODE_NIL_CHECK(var, cls);

            id replaceVar = [self willEncodeValue:var forKey:varName inClass:cls];
            ENCODE_NIL_CHECK(replaceVar, cls);

            if ([replaceVar conformsToProtocol:@protocol(NSCoding)]) {
                /* use class name as prefix to avoid superclass' key over subclass' key */
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

    void *ptrBase = (__bridge void *)self;
    
    while (!reachRootClass(cls)) {        // recursion ivar to root class
        NSString *clsName = NSStringFromClass(cls);

        unsigned int ivarCount = 0;
        Ivar *ivars = class_copyIvarList(cls, &ivarCount);

        for (const Ivar *p = ivars; p < ivars + ivarCount; ++p) {   // traverse ivars in current class
            Ivar const ivar = *p;

            NSString *varName = NSStringFromIvarName(ivar);

            const char *encodingType = ivar_getTypeEncoding(ivar);
            const char typeFlag = encodingType[0];
            
            VAR_LENGTH_CHECK(varName);
            HAS_SKIP_CHECK(varName);
            ENCODE_TYPE_CHECK(typeFlag, varName);

            NSString *decodeKey = [NSString stringWithFormat:@"%@_%@", clsName, varName];

            id<NSCoding> var = [aDecoder decodeObjectForKey:decodeKey];
            if (!var) { // try replaceKey
                decodeKey = [NSString stringWithFormat:@"%@%@", kZHYCodingModelReplacePrefix, decodeKey];
                var = [aDecoder decodeObjectForKey:decodeKey];
            }

            if (var) {
                id replaceVar = [self willDecodeValue:var forKey:varName inClass:cls];
                
                if (isObjectType(typeFlag)) {
                    object_setIvar(self, ivar, replaceVar);
                } else if (supportWrapper(typeFlag)) {
                    if ([replaceVar isKindOfClass:[NSValue class]]) {
                        NSValue *wrapperValue = (NSValue *)replaceVar;
                        void *ivarPtr = pointerToIvar(ptrBase, ivar);
                        [wrapperValue getValue:ivarPtr];
                    } else {    // Unreachable
                        NSAssert(NO, @"Invalid class for decode. <Class: %@>", [replaceVar class]);
                    }
                } else {
                    NSAssert(NO, @"Invalid decode branch. <Type: %s>", encodingType);
                }
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
