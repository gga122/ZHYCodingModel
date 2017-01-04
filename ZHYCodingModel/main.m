//
//  main.m
//  ZHYCodingModel
//
//  Created by John Henry on 2016/12/28.
//  Copyright © 2016年 John Henry. All rights reserved.
//

#import "TestClass.h"
#import "TestSubClass.h"
#import <Cocoa/Cocoa.h>
#import <objc/objc-runtime.h>

int main(int argc, const char * argv[]) {
    TestSubClass *archiverObject = [[TestSubClass alloc] init];

    NSMutableString *path = [NSMutableString stringWithFormat:@"%@/test.dat", NSHomeDirectory()];
    NSFileManager *fileManager = [NSFileManager defaultManager];

    BOOL existed = [fileManager fileExistsAtPath:path];
    if (existed) {
        NSError *error;
        BOOL res = [fileManager removeItemAtPath:path error:&error];
        if (!res) {
            NSLog(@"Error: %@", error);
        }
    }

    BOOL archiverSucceed = [NSKeyedArchiver archiveRootObject:archiverObject toFile:path];
    NSLog(@"Test encode: %@\n", (archiverSucceed ? @"YES" : @"NO"));

    id unarchiverObject = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    NSLog(@"Test decode: %@\n", unarchiverObject);

    return NSApplicationMain(argc, argv);
}
