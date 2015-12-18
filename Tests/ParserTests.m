//
//  ParserTests.m
//  Plugin
//
//  Created by materik on 18/12/15.
//  Copyright © 2015 Materik AB. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "Parser.h"

@interface ParserTests : XCTestCase

@end

@implementation ParserTests

- (void)test1 {
    NSString *p = [Parser parseCode:@"-(void)hej"];
    NSString *pe = @"- (void)hej {\n\t[super hej];\n}\n";
    XCTAssertEqualObjects(p, pe);
}

- (void)test2 {
    NSString *p = [Parser parseCode:@"-(void)hej {"];
    NSString *pe = @"- (void)hej {\n\t[super hej];\n}\n";
    XCTAssertEqualObjects(p, pe);
}

- (void)test3 {
    NSString *p = [Parser parseCode:@"-(void)hej:(id)x {"];
    NSString *pe = @"- (void)hej:(id)x {\n\t[super hej:x];\n}\n";
    XCTAssertEqualObjects(p, pe);
}

- (void)test4 {
    NSString *p = [Parser parseCode:@"-(void)viewDidLoad"];
    NSString *pe = @"- (void)viewDidLoad {\n\t[super viewDidLoad];\n}\n";
    XCTAssertEqualObjects(p, pe);
}

- (void)test5 {
    NSString *p = [Parser parseCode:@"-(id)init"];
    NSString *pe = @"- (id)init {\n\tself = [super init];\n\tif (self) {\n\t}\n\treturn self;\n}\n";
    XCTAssertEqualObjects(p, pe);
}

- (void)test6 {
    NSString *p = [Parser parseCode:@"-(id)init {"];
    NSString *pe = @"- (id)init {\n\tself = [super init];\n\tif (self) {\n\t}\n\treturn self;\n}\n";
    XCTAssertEqualObjects(p, pe);
}

- (void)test7 {
    NSString *p = [Parser parseCode:@"-(id)initWithString:(NSString *)string"];
    NSString *pe = @"- (id)initWithString:(NSString *)string {\n\tself = [super initWithString:string];\n\tif (self) "
                   @"{\n\t}\n\treturn self;\n}\n";
    XCTAssertEqualObjects(p, pe);
}

- (void)test8 {
    NSString *p = [Parser parseCode:@"-(instancetype)init"];
    NSString *pe = @"- (instancetype)init {\n\tself = [super init];\n\tif (self) {\n\t}\n\treturn self;\n}\n";
    XCTAssertEqualObjects(p, pe);
}

- (void)test9 {
    NSString *p = [Parser parseCode:@"-(id)initWithString:(NSString *)string andNumber:(NSUInteger)number"];
    NSString *pe = @"- (id)initWithString:(NSString *)string andNumber:(NSUInteger)number {\n\tself = [super "
                   @"initWithString:string andNumber:number];\n\tif (self) "
                   @"{\n\t}\n\treturn self;\n}\n";
    XCTAssertEqualObjects(p, pe);
}

- (void)test10 {
    NSString *p = [Parser parseCode:@"-(id)initWithString:(NSString *)string andNumber:(NSUInteger)number {"];
    NSString *pe = @"- (id)initWithString:(NSString *)string andNumber:(NSUInteger)number {\n\tself = [super "
                   @"initWithString:string andNumber:number];\n\tif (self) "
                   @"{\n\t}\n\treturn self;\n}\n";
    XCTAssertEqualObjects(p, pe);
}

- (void)test11 {
    NSString *p = [Parser parseCode:@"-(id)initWithString:(NSString *)string andNumber:(NSUInteger)number  "
                                    @"andNumber:(NSUInteger)number  andNumber:(NSUInteger)number"];
    NSString *pe = @"- (id)initWithString:(NSString *)string andNumber:(NSUInteger)number andNumber:(NSUInteger)number "
                   @"andNumber:(NSUInteger)number {\n\tself = [super "
                   @"initWithString:string andNumber:number andNumber:number andNumber:number];\n\tif (self) "
                   @"{\n\t}\n\treturn self;\n}\n";
    XCTAssertEqualObjects(p, pe);
}

- (void)test12 {
    NSString *p = [Parser parseCode:@"-(NSString *)x"];
    NSString *pe = @"- (NSString *)x {\n\tif (!_x) {\n\t\t_x = [[NSString alloc] init];\n\t}\n\treturn _x;\n}\n";
    XCTAssertEqualObjects(p, pe);
}

- (void)test13 {
    NSString *p = [Parser parseCode:@"-(NSString *)x {"];
    NSString *pe = @"- (NSString *)x {\n\tif (!_x) {\n\t\t_x = [[NSString alloc] init];\n\t}\n\treturn _x;\n}\n";
    XCTAssertEqualObjects(p, pe);
}

@end
