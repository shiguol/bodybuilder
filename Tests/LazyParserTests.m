//
//  LazyParserTests.m
//  LazyParserTests
//
//  Created by materik on 17/12/15.
//  Copyright © 2015 Materik AB. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "Parser.h"

@interface LazyParserTests : XCTestCase

@end

@implementation LazyParserTests

- (void)test1 {
    NSString *p = [Parser parseCodeAsLazy:@"-(NSString *)x"];
    NSString *pe = @"- (NSString *)x {\n\tif (!_x) {\n\t\t_x = [[NSString alloc] init];\n\t}\n\treturn _x;\n}\n";
    XCTAssertEqualObjects(p, pe);
}

- (void)test2 {
    NSString *p = [Parser parseCodeAsLazy:@"-(NSString *)x {"];
    NSString *pe = @"- (NSString *)x {\n\tif (!_x) {\n\t\t_x = [[NSString alloc] init];\n\t}\n\treturn _x;\n}\n";
    XCTAssertEqualObjects(p, pe);
}

- (void)test3 {
    NSString *p = [Parser parseCodeAsLazy:@"-(id)init"];
    XCTAssertNil(p);
}

- (void)test4 {
    NSString *p = [Parser parseCodeAsLazy:@"-(id)initWithString:(NSString *)x"];
    XCTAssertNil(p);
}

@end
