//
//  Parser.h
//  Plugin
//
//  Created by materik on 17/12/15.
//  Copyright © 2015 Materik AB. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Parser : NSObject

+ (NSString *)parseCode:(NSString *)code;
+ (NSString *)parseCodeAsLazy:(NSString *)code;
+ (NSString *)parseCodeAsInit:(NSString *)code;
+ (NSString *)parseCodeAsMethod:(NSString *)code;

@end
