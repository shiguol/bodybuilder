//
//  InitParserTests.m
//  Plugin
//
//  Created by materik on 17/12/15.
//  Copyright © 2015 Materik AB. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "Parser.h"

@interface InitParserTests : XCTestCase

@end

@implementation InitParserTests

- (void)test1 {
    NSString *p = [Parser parseCodeAsInit:@"-(id)init"];
    NSString *pe = @"- (id)init {\n\tself = [super init];\n\tif (self) {\n\t}\n\treturn self;\n}\n";
    XCTAssertEqualObjects(p, pe);
}

- (void)test2 {
    NSString *p = [Parser parseCodeAsInit:@"-(id)init {"];
    NSString *pe = @"- (id)init {\n\tself = [super init];\n\tif (self) {\n\t}\n\treturn self;\n}\n";
    XCTAssertEqualObjects(p, pe);
}

- (void)test3 {
    NSString *p = [Parser parseCodeAsInit:@"-(id)initWithString:(NSString *)string"];
    NSString *pe = @"- (id)initWithString:(NSString *)string {\n\tself = [super initWithString:string];\n\tif (self) "
                   @"{\n\t}\n\treturn self;\n}\n";
    XCTAssertEqualObjects(p, pe);
}

- (void)test4 {
    NSString *p = [Parser parseCodeAsInit:@"-(instancetype)init"];
    NSString *pe = @"- (instancetype)init {\n\tself = [super init];\n\tif (self) {\n\t}\n\treturn self;\n}\n";
    XCTAssertEqualObjects(p, pe);
}

- (void)test5 {
    NSString *p = [Parser parseCodeAsInit:@"-(id)initWithString:(NSString *)string andNumber:(NSUInteger)number"];
    NSString *pe = @"- (id)initWithString:(NSString *)string andNumber:(NSUInteger)number {\n\tself = [super "
                   @"initWithString:string andNumber:number];\n\tif (self) "
                   @"{\n\t}\n\treturn self;\n}\n";
    XCTAssertEqualObjects(p, pe);
}

- (void)test6 {
    NSString *p = [Parser parseCodeAsInit:@"-(id)initWithString:(NSString *)string andNumber:(NSUInteger)number {"];
    NSString *pe = @"- (id)initWithString:(NSString *)string andNumber:(NSUInteger)number {\n\tself = [super "
                   @"initWithString:string andNumber:number];\n\tif (self) "
                   @"{\n\t}\n\treturn self;\n}\n";
    XCTAssertEqualObjects(p, pe);
}

- (void)test7 {
    NSString *p = [Parser parseCodeAsInit:@"-(id)initWithString:(NSString *)string andNumber:(NSUInteger)number  "
                                          @"andNumber:(NSUInteger)number  andNumber:(NSUInteger)number"];
    NSString *pe = @"- (id)initWithString:(NSString *)string andNumber:(NSUInteger)number andNumber:(NSUInteger)number "
                   @"andNumber:(NSUInteger)number {\n\tself = [super "
                   @"initWithString:string andNumber:number andNumber:number andNumber:number];\n\tif (self) "
                   @"{\n\t}\n\treturn self;\n}\n";
    XCTAssertEqualObjects(p, pe);
}

//- (void)test8 {
//    NSString *p = [Parser parseCodeAsInit:@"-(void)hej"];
//    XCTAssertNil(p);
//}

@end
