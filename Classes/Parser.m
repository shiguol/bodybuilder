//
//  Parser.m
//  Plugin
//
//  Created by materik on 17/12/15.
//  Copyright © 2015 Materik AB. All rights reserved.
//

#import "Parser.h"

#import "NSString+Helper.h"

typedef NS_ENUM(NSUInteger, ParserType) {
    ParserTypeLazy,
    ParserTypeMethod,
    ParserTypeInit,
};

static NSString *const kLazyRegex = @"-\\s?\\(([^\\)\\*]+)\\s?\\*\\)\\s?([^\\s{]+)";
static NSString *const kLazyParsed = @"- (<className> *)<varName> {\n\tif (!_<varName>) {\n\t\t_<varName> = "
                                     @"[[<className> alloc] init];\n\t}\n\treturn _<varName>;\n}\n";
static NSString *const kInitRegex =
    @"(?:-\\s?\\((id|instancetype)\\)\\s?)?\\s?(?:([^:\\s\\{]+)(?::\\(([^\\)]+)\\)([^\\s\\{]+)\\s?\\{?)?)";
static NSString *const kInitParsed =
    @"- (<typeName>)<methodName> {\n\tself = [super <funcCall>];\n\tif (self) {\n\t}\n\treturn self;\n}\n";
static NSString *const kMethodRegex =
    @"(?:-\\s?\\(void\\)\\s?)\\s?(?:([^:\\s\\{]+)(?::\\(([^\\)]+)\\)([^\\s\\{]+)\\s?\\{?)?)";
static NSString *const kMethodParsed = @"- (void)<methodName> {\n\t[super <funcCall>];\n}\n";

static NSString *const kMethodNameParsed = @"<funcName>:(<className>)<varName>";
static NSString *const kFuncCallParsed = @"<funcName>:<varName>";

@implementation Parser

+ (NSString *)parseCode:(NSString *)code type:(ParserType)type {
    NSString *parsedCode;
    switch (type) {
        case ParserTypeLazy:
            parsedCode = [self parseCodeAsLazy:code];
            break;
        case ParserTypeInit:
            parsedCode = [self parseCodeAsInit:code];
            break;
        case ParserTypeMethod:
            parsedCode = [self parseCodeAsMethod:code];
            break;
        default:
            return nil;
    }
    return parsedCode ?: [self parseCode:code type:type + 1];
}

+ (NSString *)parseCode:(NSString *)code {
    if (code) {
        @try {
            return [self parseCode:code type:0];
        } @catch (NSException *exception) {
            return nil;
        }
    }
}

+ (NSString *)parseCodeAsLazy:(NSString *)code {
    NSArray *matches = [self matchesOfString:code withPattern:kLazyRegex];
    if ([matches count]) {
        NSString *parsedCode = kLazyParsed;
        parsedCode = [self parseCode:parsedCode replaceKey:@"className" withValue:[matches objectAtIndex:0]];
        parsedCode = [self parseCode:parsedCode replaceKey:@"varName" withValue:[matches objectAtIndex:1]];
        return parsedCode;
    }
    return nil;
}

+ (NSString *)parseCodeAsInit:(NSString *)code {
    NSArray *matches = [self matchesOfString:code withPattern:kInitRegex];
    if ([matches count]) {
        NSString *parsedCode = kInitParsed;
        parsedCode = [self parseCode:parsedCode replaceKey:@"typeName" withValue:[matches objectAtIndex:0]];
        NSString *methodName = [self parseMethodNameOfMatches:matches startIndex:1];
        parsedCode = [self parseCode:parsedCode replaceKey:@"methodName" withValue:methodName];
        NSString *funcCall = [self parseFuncCallOfMatches:matches startIndex:1];
        parsedCode = [self parseCode:parsedCode replaceKey:@"funcCall" withValue:funcCall];
        return parsedCode;
    }
    return nil;
}

+ (NSString *)parseCodeAsMethod:(NSString *)code {
    NSArray *matches = [self matchesOfString:code withPattern:kMethodRegex];
    if ([matches count]) {
        NSString *parsedCode = kMethodParsed;
        NSString *methodName = [self parseMethodNameOfMatches:matches startIndex:0];
        parsedCode = [self parseCode:parsedCode replaceKey:@"methodName" withValue:methodName];
        NSString *funcCall = [self parseFuncCallOfMatches:matches startIndex:0];
        parsedCode = [self parseCode:parsedCode replaceKey:@"funcCall" withValue:funcCall];
        return parsedCode;
    }
    return nil;
}

#pragma mark - Helper

+ (NSString *)parseMethodNameOfMatches:(NSArray *)matches startIndex:(NSUInteger)index {
    NSString *methodName;
    if ([matches count] >= index + 2) {
        while ([matches count] >= index + 2) {
            NSString *funcName = [matches objectAtIndex:index];
            NSString *className = [matches objectAtIndex:index + 1];
            NSString *varName = [matches objectAtIndex:index + 2];

            NSString *_methodName = kMethodNameParsed;
            _methodName = [self parseCode:_methodName replaceKey:@"funcName" withValue:funcName];
            _methodName = [self parseCode:_methodName replaceKey:@"className" withValue:className];
            _methodName = [self parseCode:_methodName replaceKey:@"varName" withValue:varName];
            methodName = [(methodName ?: @"") stringByAppendingFormat:@" %@", _methodName];

            index += 3;
        }
    } else {
        methodName = [matches objectAtIndex:index];
    }
    return methodName;
}

+ (NSString *)parseFuncCallOfMatches:(NSArray *)matches startIndex:(NSUInteger)index {
    NSString *funcCall;
    if ([matches count] >= index + 2) {
        while ([matches count] >= index + 2) {
            NSString *funcName = [matches objectAtIndex:index];
            NSString *varName = [matches objectAtIndex:index + 2];

            NSString *_funcCall = kFuncCallParsed;
            _funcCall = [self parseCode:_funcCall replaceKey:@"funcName" withValue:funcName];
            _funcCall = [self parseCode:_funcCall replaceKey:@"varName" withValue:varName];
            funcCall = [(funcCall ?: @"") stringByAppendingFormat:@" %@", _funcCall];

            index += 3;
        }
    } else {
        funcCall = [matches objectAtIndex:index];
    }
    return funcCall;
}

+ (NSArray *)matchesOfString:(NSString *)string withPattern:(NSString *)pattern {
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:0 error:nil];
    NSArray *matches = [regex matchesInString:string options:0 range:string.fullRange];
    NSMutableArray *matchStrings = [[NSMutableArray alloc] init];
    for (NSTextCheckingResult *match in matches) {
        for (int i = 1; i < [match numberOfRanges]; i++) {
            NSRange range = [match rangeAtIndex:i];
            if (range.length) {
                NSString *matchString = [[string substringWithRange:range] trim];
                [matchStrings addObject:matchString];
            }
        }
    }
    return matchStrings;
}

+ (NSString *)extractFromString:(NSString *)string withMatch:(NSTextCheckingResult *)match atIndex:(NSUInteger)index {
    if (index < [match numberOfRanges]) {
        NSRange range = [match rangeAtIndex:index];
        if (range.length > 0) {
            return [[string substringWithRange:range] trim];
        }
    }
    return nil;
}

+ (NSString *)parseCode:(NSString *)parsedCode replaceKey:(NSString *)key withValue:(NSString *)value {
    key = [NSString stringWithFormat:@"<%@>", key];
    return [parsedCode stringByReplacingOccurrencesOfString:key withString:[value trim]];
}

@end
