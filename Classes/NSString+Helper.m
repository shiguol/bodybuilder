//
//  NSString+Helper.m
//  Plugin
//
//  Created by materik on 17/12/15.
//  Copyright © 2015 Materik AB. All rights reserved.
//

#import "NSString+Helper.h"

@implementation NSString (Helper)

- (NSRange)fullRange {
    return NSMakeRange(0, self.length);
}

- (NSString *)trim {
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

@end
