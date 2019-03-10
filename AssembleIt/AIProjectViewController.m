//
//  AIProjectViewController.m
//  AssembleIt
//
//  Created by Evian张 on 2019/3/4.
//  Copyright © 2019 Evian张. All rights reserved.
//

#import "AIProjectViewController.h"

@interface AIProjectViewController ()

typedef enum AISplitViewIndex {
    NAVIGATORVIEW = 0,
    
} AISplitViewIndex;

@end

@implementation AIProjectViewController

@synthesize navigatorViewController = _navigatorViewController;
@synthesize startViewController = _startViewController;
@synthesize projectContents = _projectContents;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    self.startViewController = [[AIProjectStartViewController alloc] initWithNibName:@"AIProjectStartViewController" bundle:nil];
}

- (void)viewDidAppear {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"AIProjectViewDidAppear" object:self];
}

- (void)buildView {
    self.navigatorViewController = [[AINavigatorViewController alloc] initWithNibName:@"AINavigatorViewController" bundle:nil];
    [self.splitView addArrangedSubview:self.navigatorViewController.view];
}

@end
