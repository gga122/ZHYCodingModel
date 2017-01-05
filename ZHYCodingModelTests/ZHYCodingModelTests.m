//
//  ZHYCodingModelTests.m
//  ZHYCodingModelTests
//
//  Created by Henry on 2016/12/31.
//  Copyright © 2016年 John Henry. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ZHYDuplicatedVarNameTestClass.h"

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

- (id<NSCoding>)unarchiveObjectWithFileName:(NSString *)fileName {
    NSParameterAssert(fileName);
    
    NSString *filePath = [self pathForFileName:fileName];
    return [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
}

#pragma mark - Test

- (void)testPureObjectCoding {
    NSString *filePath = [self pathForFileName:@"pureObject.dat"];
    
    ZHYTestClass *archiverObject = [[ZHYTestClass alloc] init];
    
    
    
    
}


@end
