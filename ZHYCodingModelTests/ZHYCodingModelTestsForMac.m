//
//  ZHYCodingModelTests.m
//  ZHYCodingModelTests
//
//  Created by Henry on 2016/12/31.
//  Copyright © 2016年 John Henry. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ZHYTestClass.h"
#import "ZHYBaseTypeTestClass.h"
#import "ZHYAdvancedTypeTestClass.h"
#import "ZHYDuplicatedVarNameTestClass.h"
#import "ZHYNotPairTestClass.h"
#import "ZHYSystemStructTestClass.h"

@interface ZHYCodingModelTests : XCTestCase

@end

@implementation ZHYCodingModelTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

/** Create file at your user path */
- (NSString *)pathForFileName:(NSString *)name {
    if (name.length == 0) {
        return nil;
    }
    
    NSString *filePath = [NSString stringWithFormat:@"%@/%@", NSHomeDirectory(), name];
    
    return filePath;
}

- (BOOL)archiveObject:(id<NSCoding>)object withFileName:(NSString *)fileName {
    NSParameterAssert(object);
    
    NSString *filePath = [self pathForFileName:fileName];
    NSParameterAssert(filePath);
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:filePath]) {
        NSError *error;
        BOOL res = [fileManager removeItemAtPath:filePath error:&error];
        if (!res) {
            NSLog(@"Remove file failed. <Error: %@>", error);
        }
    }
    
    return [NSKeyedArchiver archiveRootObject:object toFile:filePath];
}

- (__kindof id<NSCoding>)unarchiveObjectWithFileName:(NSString *)fileName {
    NSParameterAssert(fileName);
    
    NSString *filePath = [self pathForFileName:fileName];
    return [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
}

#pragma mark - Test

- (void)testPureObjectCoding {
    static NSString * const kPureObjectFileName = @"pureObject.dat";
    
    ZHYTestClass *archiverObject = [[ZHYTestClass alloc] init];
    BOOL res = [self archiveObject:archiverObject withFileName:kPureObjectFileName];
    XCTAssertTrue(res);
    
    ZHYTestClass *unarchiverObject = [self unarchiveObjectWithFileName:kPureObjectFileName];
    XCTAssertNotNil(unarchiverObject);
    
    XCTAssertEqualObjects(archiverObject, unarchiverObject);
}

- (void)testBaseTypeObjectCoding {
    static NSString * const kBaseTypeObjectFileName = @"baseTypeObject.dat";
    
    ZHYBaseTypeTestClass *archiverObject = [[ZHYBaseTypeTestClass alloc] init];
    BOOL res = [self archiveObject:archiverObject withFileName:kBaseTypeObjectFileName];
    XCTAssertTrue(res);
    
    ZHYBaseTypeTestClass *unarchiverObject = [self unarchiveObjectWithFileName:kBaseTypeObjectFileName];
    XCTAssertNotNil(unarchiverObject);
    
    XCTAssertEqualObjects(archiverObject, unarchiverObject);
}

- (void)testAdvancedTypeObjectCoding {
    static NSString * const kAdvancedTypeObjectFileName = @"advancedTypeObject.dat";
    
    ZHYAdvancedTypeTestClass *archiverObject = [[ZHYAdvancedTypeTestClass alloc] init];
    BOOL res = [self archiveObject:archiverObject withFileName:kAdvancedTypeObjectFileName];
    XCTAssertTrue(res);
    
    ZHYAdvancedTypeTestClass *unarchiverObject = [self unarchiveObjectWithFileName:kAdvancedTypeObjectFileName];
    XCTAssertNotNil(unarchiverObject);
    
    XCTAssertNotEqualObjects(archiverObject, unarchiverObject);
    
    XCTAssertNotEqual(archiverObject.ptrValue, unarchiverObject.ptrValue);
    XCTAssertEqual(unarchiverObject.cStringValue, NULL);
    XCTAssertFalse([archiverObject isCArrayEqualTo:unarchiverObject]);
    XCTAssertTrue(NSEqualRects(archiverObject.rectValue, unarchiverObject.rectValue));
    
    union unionType aValue = archiverObject.unionValue;
    union unionType bValue = unarchiverObject.unionValue;
    XCTAssertNotEqual(memcmp(&aValue, &bValue, sizeof(union unionType)), 0);
}

- (void)testDuplicatedVarNameCoding {
    static NSString * const kDuplicatedVarNameObjectFileName = @"duplicatedVarNameObject.dat";
    
    ZHYDuplicatedVarNameTestClass *archiverObject = [[ZHYDuplicatedVarNameTestClass alloc] init];
    BOOL res = [self archiveObject:archiverObject withFileName:kDuplicatedVarNameObjectFileName];
    XCTAssertTrue(res);
    
    ZHYDuplicatedVarNameTestClass *unarchiverObject = [self unarchiveObjectWithFileName:kDuplicatedVarNameObjectFileName];
    XCTAssertNotNil(unarchiverObject);
    
    XCTAssertEqualObjects(archiverObject, unarchiverObject);
}

- (void)testNotPairMethodOverriddenCoding {
    static NSString * const kNotPairMethodOverriddenObjectFileName = @"notPairMethodOverriddenObject.dat";
    
    ZHYNotPairTestClass *archiverObject = [[ZHYNotPairTestClass alloc] init];
    BOOL res = [self archiveObject:archiverObject withFileName:kNotPairMethodOverriddenObjectFileName];
    XCTAssertTrue(res);
    
    ZHYNotPairTestClass *unarchiverObject = [self unarchiveObjectWithFileName:kNotPairMethodOverriddenObjectFileName];
    XCTAssertNotNil(unarchiverObject);
    
    XCTAssertNotEqualObjects(archiverObject, unarchiverObject);
    XCTAssertEqualObjects(unarchiverObject.stringValue, kZHYNotPairTestClassDecodeReplacedVar);
}

- (void)testSystemStructTypeObjectCoding {
    static NSString * const ksSystemStructObjectFileName = @"notPairMethodOverriddenObject.dat";
    
    ZHYSystemStructTestClass *archiverObject = [[ZHYSystemStructTestClass alloc] init];
    BOOL res = [self archiveObject:archiverObject withFileName:ksSystemStructObjectFileName];
    XCTAssertTrue(res);
    
    ZHYSystemStructTestClass *unarchiverObject = [self unarchiveObjectWithFileName:ksSystemStructObjectFileName];
    XCTAssertNotNil(unarchiverObject);
    
    XCTAssertEqualObjects(archiverObject, unarchiverObject);
}

@end
