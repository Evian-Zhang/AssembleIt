//
//  AIRulerView.m
//  AssembleIt
//
//  Created by Evian张 on 2019/3/3.
//  Copyright © 2019 Evian张. All rights reserved.
//

#import "AIRulerView.h"

@implementation AIRulerView

@synthesize font = _font;
@synthesize textColor = _textColor;
@synthesize backgroundColor = _backgroundColor;
@synthesize lineInformationValid = _lineInformationValid;

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

- (instancetype)initWithScrollView:(NSScrollView *)scrollView orientation:(NSRulerOrientation)orientation {
    if (self = [super initWithScrollView:scrollView orientation:orientation]) {
        self.font = [NSFont labelFontOfSize:[NSFont systemFontSizeForControlSize:NSControlSizeMini]];
        self.textColor = [NSColor darkGrayColor];
//        self.backgroundColor = [NSColor colorWithCalibratedWhite:0.9 alpha:1.0];
        return self;
    }
    return nil;
}

- (BOOL)isFlipped {
    return YES;
}

- (void)setClientView:(NSView *)clientView {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NSTextStorageDidProcessEditingNotification object:nil];
    
    [super setClientView:clientView];
    
    if ([clientView isKindOfClass:[NSTextView class]]) {
        NSTextStorage *textStorage = [(NSTextView*)clientView textStorage];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clientTextStorageDidProcessEditing:) name:NSTextStorageDidProcessEditingNotification object:textStorage];
    }
}

- (void)clientTextStorageDidProcessEditing:(NSNotification*)notification {
    self.lineInformationValid = NO;
    
    [self setNeedsDisplay:YES];
}

- (NSTextStorage*)currentTextStorage {
    NSView *clientView = [self clientView];
    if ([clientView isKindOfClass:[NSTextView class]]) {
        return [(NSTextView*)clientView textStorage];
    }
    return nil;
}

- (NSDictionary *)textAttributes {
    return [NSDictionary dictionaryWithObjectsAndKeys:self.font, NSFontAttributeName, self.textColor, NSForegroundColorAttributeName, nil];
}

- (void)updateLineInformation {
    NSMutableIndexSet *mutableLineStartCharacterIndexes = [NSMutableIndexSet indexSet];
    
    NSString *clientString = self.currentTextStorage.string;
    
    [clientString enumerateSubstringsInRange:NSMakeRange(0, clientString.length) options:NSStringEnumerationByLines | NSStringEnumerationSubstringNotRequired usingBlock:^(NSString * _Nullable substring, NSRange substringRange, NSRange enclosingRange, BOOL * _Nonnull stop) {
        [mutableLineStartCharacterIndexes addIndex:substringRange.location];
    }];
    
    NSUInteger numberOfLines = mutableLineStartCharacterIndexes.count;

    self.lineInformationValid = YES;
    double numberOfDigits = 1;
    if (numberOfLines > 0) {
        numberOfDigits = ceil(log10(numberOfLines));
    }
    
    NSSize digitSize = [@"0" sizeWithAttributes:self.textAttributes];
    CGFloat newRuleThickness = MAX(ceil(digitSize.width * numberOfDigits + 8.0), 10.0);
    
    [self setRuleThickness:newRuleThickness];
}

- (void)viewWillDraw {
    [super viewWillDraw];
    
    if (!self.isLineInformationValid) {
        [self updateLineInformation];
    }
}

- (NSUInteger)lineIndexForCharacterIndex:(NSUInteger)characterIndex {
    NSString *textString = self.currentTextStorage.string;
    if (characterIndex >= textString.length) {
        return NSNotFound;
    }
    NSUInteger lineIndex = 0;
    for (NSUInteger tmpCharacterIndex = 0; tmpCharacterIndex < characterIndex; tmpCharacterIndex++) {
        if ([textString characterAtIndex:tmpCharacterIndex] == '\n') {
            lineIndex++;
        }
    }
    return lineIndex;
}

- (void)drawHashMarksAndLabelsInRect:(NSRect)dirtyRect {
    NSRect bounds = self.bounds;
    
    [self.backgroundColor set];
    NSRectFill(dirtyRect);
    
    NSRect borderLineRect = NSMakeRect(NSMaxX(bounds) - 1.0, 0, 1.0, NSHeight(bounds));
    
    if ([self needsToDrawRect:borderLineRect]) {
        [[self.backgroundColor shadowWithLevel:0.4] set];
        NSRectFill(borderLineRect);
    }
    
    NSView *clientView = self.clientView;
    if (![clientView isKindOfClass:[NSTextView class]]) {
        return;
    }
    
    NSTextView *textView = (NSTextView*)clientView;
    
    NSLayoutManager *layoutManager = textView.layoutManager;
    NSTextContainer *textContainer = textView.textContainer;
    NSTextStorage *textStorage = textView.textStorage;
    NSString *textString = textStorage.string;
    
    NSRect visibleRect = self.scrollView.contentView.bounds;
    NSSize textContainerInset = textView.textContainerInset;
    NSUInteger textLength = textString.length;
    CGFloat rightMostDrawableLocation = NSMinX(borderLineRect);
    
    NSRange visibleGlyphRange = [layoutManager glyphRangeForBoundingRect:visibleRect inTextContainer:textContainer];
    NSRange visibleCharacterRange = [layoutManager characterRangeForGlyphRange:visibleGlyphRange actualGlyphRange:NULL];
    
    CGFloat lastLinePositionY = -1.0;
    
    for (NSUInteger characterIndex = visibleCharacterRange.location; characterIndex < textLength;) {
        NSUInteger lineNumber = [self lineIndexForCharacterIndex:characterIndex];
        if (lineNumber == NSNotFound) {
            break;
        }
        
        NSUInteger layoutRectCount;
        NSRectArray layoutRects = [layoutManager rectArrayForCharacterRange:(NSRange){characterIndex, 0} withinSelectedCharacterRange:(NSRange){NSNotFound, 0} inTextContainer:textContainer rectCount:&layoutRectCount];
        
        if (layoutRectCount == 0) {
            break;
        }
        
        NSString *lineString = [NSString stringWithFormat:@"%lu", (unsigned long)lineNumber + 1];
        
        NSSize lineStringSize = [lineString sizeWithAttributes:self.textAttributes];
        NSRect lineStringRect = NSMakeRect(rightMostDrawableLocation - lineStringSize.width - 2.0, NSMinY(layoutRects[0]) + textContainerInset.height - NSMinY(visibleRect) + (NSHeight(layoutRects[0]) - lineStringSize.height) / 2.0, lineStringSize.width, lineStringSize.height);
        
        if ([self needsToDrawRect:NSInsetRect(lineStringRect, -4.0, -4.0)] && (NSMinY(lineStringRect) != lastLinePositionY)) {
            [lineString drawWithRect:lineStringRect options:NSStringDrawingUsesLineFragmentOrigin attributes:self.textAttributes];
        }
        
        lastLinePositionY = NSMinY(lineStringRect);
        
        [textString getLineStart:NULL end:&characterIndex contentsEnd:NULL forRange:(NSRange){characterIndex, 0}];
    }
}

@end
