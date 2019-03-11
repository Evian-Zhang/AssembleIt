//
//  AICodeViewController2.m
//  AssembleIt
//
//  Created by Evian张 on 2019/3/3.
//  Copyright © 2019 Evian张. All rights reserved.
//

#import "AICodeViewController2.h"

@interface AICodeViewController2 ()

@end

@implementation AICodeViewController2

@synthesize codeView = _codeView;
@synthesize scrollView = _scrollView;

@synthesize content = _content;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    AIRulerView *rulerView = [[AIRulerView alloc] initWithScrollView:self.scrollView orientation:NSVerticalRuler];
    rulerView.clientView = self.codeView;
    rulerView.backgroundColor = self.codeView.backgroundColor;
    
    self.scrollView.verticalRulerView = rulerView;
    self.scrollView.rulersVisible = YES;
    // Do view setup here.
}

- (void)viewDidAppear {
    if (self.content && self.content.length > 0) {
        self.codeView.string = self.content;
    }
}

- (void)updateContent {
    if (self.content && self.content.length > 0) {
        self.codeView.string = self.content;
    }
}

@end
