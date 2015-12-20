//
//  BodyBuilder.m
//  BodyBuilder
//
//  Created by materik on 13/12/15.
//  Copyright © 2015 Materik AB. All rights reserved.
//

#import "BodyBuilder.h"

#import "DTXcodeHeaders.h"
#import "DTXcodeUtils.h"
#import "Parser.h"

static BodyBuilder *_sharedPlugin;
static NSString *const kMenuTitle = @"Edit";
static NSString *const kMenuItemTitle = @"BodyBuilder";
static NSString *const kKeyEquivalent = @"B";

@interface BodyBuilder ()

@property(nonatomic, strong) NSBundle *bundle;

@end

@implementation BodyBuilder

+ (void)pluginDidLoad:(NSBundle *)plugin {
    static dispatch_once_t onceToken;
    if ([[[NSBundle mainBundle].infoDictionary objectForKey:@"CFBundleName"] isEqual:@"Xcode"]) {
        dispatch_once(&onceToken, ^{
          _sharedPlugin = [[BodyBuilder alloc] initWithBundle:plugin];
        });
    }
}

#pragma mark - Initilizer

- (id)initWithBundle:(NSBundle *)plugin {
    self = [super init];
    if (self) {
        [self setBundle:plugin];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(didApplicationFinishLaunchingNotification:)
                                                     name:NSApplicationDidFinishLaunchingNotification
                                                   object:nil];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Life cycle

- (void)didApplicationFinishLaunchingNotification:(NSNotification *)notification {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:NSApplicationDidFinishLaunchingNotification
                                                  object:nil];

    NSMenuItem *mainMenuItem = [[NSApp mainMenu] itemWithTitle:kMenuTitle];
    if (mainMenuItem) {
        [[mainMenuItem submenu] addItem:[NSMenuItem separatorItem]];
        [[mainMenuItem submenu] addItem:self.menuItem];
    }
}

- (NSMenuItem *)menuItem {
    NSMenuItem *menuItem =
        [[NSMenuItem alloc] initWithTitle:kMenuItemTitle action:@selector(action) keyEquivalent:kKeyEquivalent];
    [menuItem setTarget:self];
    [menuItem setKeyEquivalentModifierMask:NSControlKeyMask | NSShiftKeyMask];
    return menuItem;
}

#pragma mark - Action

- (void)action {
    NSString *parsedCode = [Parser parseCode:[self currentLineOfCode]];
    if (parsedCode) {
        [[DTXcodeUtils currentTextStorage] beginEditing];
        [[DTXcodeUtils currentTextStorage] replaceCharactersInRange:self.currentLineRange withString:parsedCode];
        [[DTXcodeUtils currentTextStorage] endEditing];
    }
}

- (NSRange)currentLineRange {
    DVTSourceTextView *sourceTextView = [DTXcodeUtils currentSourceTextView];
    return [sourceTextView.string lineRangeForRange:NSMakeRange(sourceTextView.selectedRange.location, 0)];
}

- (NSString *)currentLineOfCode {
    DVTSourceTextView *sourceTextView = [DTXcodeUtils currentSourceTextView];
    return [sourceTextView.textStorage.string substringWithRange:self.currentLineRange];
}

@end
