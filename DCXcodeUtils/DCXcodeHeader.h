//
//  DCXcodeHeader.h
//  DCLazyInstantiate
//
//  Created by Youwei Teng on 7/15/15.
//  Copyright (c) 2015 dcard. All rights reserved.
//

@interface DVTTextStorage : NSTextStorage
/** Whether to syntax highlight the current editor */
@property(getter=isSyntaxColoringEnabled) BOOL syntaxColoringEnabled;

/** Converts from a character number in the text to a line number */
- (NSRange)lineRangeForCharacterRange:(NSRange)characterRange;

/** Converts from a line number in the text to a character number */
- (NSRange)characterRangeForLineRange:(NSRange)lineRange;

- (void)replaceCharactersInRange:(NSRange)range withString:(NSString *)string withUndoManager:(id)undoManager;
@end

@interface DVTCompletingTextView : NSTextView
@end

@interface DVTSourceTextView : DVTCompletingTextView
@end

@interface DVTViewController : NSViewController
@end

@interface IDEViewController : DVTViewController
@end

@class IDEEditorContext;
@interface IDEEditorArea : IDEViewController
@property(retain, nonatomic) IDEEditorContext *lastActiveEditorContext;
@end

@interface IDEEditor : IDEViewController
@end

@interface IDEEditorContext : IDEViewController
@property(retain, nonatomic) IDEEditor *editor;
@property(retain, nonatomic) IDEEditorArea *editorArea;
@end

@interface IDEEditorDocument : NSDocument
@end

@interface DVTSourceTextStorage : NSTextStorage
@end

@interface IDESourceCodeDocument : IDEEditorDocument
- (DVTTextStorage *)textStorage;
- (NSUndoManager *)undoManager;
@end

@interface IDESourceCodeEditor : IDEEditor
@property(readonly) IDESourceCodeDocument *sourceCodeDocument;
@property(retain) DVTSourceTextView *textView;
@end

@interface IDEComparisonEditor : IDEEditor
@property(retain) IDEEditorDocument *secondaryDocument;
@property(retain) IDEEditorDocument *primaryDocument;
@end

@interface IDESourceCodeComparisonEditor : IDEComparisonEditor
@property(readonly) DVTSourceTextView *keyTextView;
@end

@interface IDEWorkspaceWindowController : NSWindowController
@property(readonly) IDEEditorArea *editorArea;

@end