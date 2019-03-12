//
//  AIRulerView.h
//  AssembleIt
//
//  Created by Evian张 on 2019/3/3.
//  Copyright © 2019 Evian张. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "AIPrefix.h"

NS_ASSUME_NONNULL_BEGIN

@interface AIRulerView : NSRulerView

@property (nonatomic) NSFont *font;
@property (nonatomic) NSColor *textColor;
@property (nonatomic) NSColor *backgroundColor;
@property (nonatomic, getter=isLineInformationValid) BOOL lineInformationValid;
@property (nonatomic, readonly) NSTextStorage *currentTextStorage;
@property (nonatomic, readonly) NSDictionary* textAttributes;

@end

NS_ASSUME_NONNULL_END
