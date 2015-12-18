//
//  MethodParserTests.m
//  Plugin
//
//  Created by materik on 18/12/15.
//  Copyright © 2015 Materik AB. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "Parser.h"

@interface MethodParserTests : XCTestCase

@end

@implementation MethodParserTests

- (void)test1 {
    NSString *p = [Parser parseCodeAsMethod:@"-(void)hej"];
    NSString *pe = @"- (void)hej {\n\t[super hej];\n}\n";
    XCTAssertEqualObjects(p, pe);
}

- (void)test2 {
    NSString *p = [Parser parseCodeAsMethod:@"-(void)hej {"];
    NSString *pe = @"- (void)hej {\n\t[super hej];\n}\n";
    XCTAssertEqualObjects(p, pe);
}

- (void)test3 {
    NSString *p = [Parser parseCodeAsMethod:@"-(void)hej:(id)x {"];
    NSString *pe = @"- (void)hej:(id)x {\n\t[super hej:x];\n}\n";
    XCTAssertEqualObjects(p, pe);
}

- (void)test4 {
    NSString *p = [Parser parseCodeAsMethod:@"-(void)viewDidLoad"];
    NSString *pe = @"- (void)viewDidLoad {\n\t[super viewDidLoad];\n}\n";
    XCTAssertEqualObjects(p, pe);
}

- (void)test5 {
    NSString *p = [Parser parseCodeAsMethod:@"-(id)init"];
    XCTAssertNil(p);
}

@end
