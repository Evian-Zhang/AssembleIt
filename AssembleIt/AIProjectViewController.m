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
@synthesize codeViewController = _codeViewController;
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

- (void)buildViewWithProjectContents:(NSMutableDictionary *)projectContents {
    self.navigatorViewController = [[AINavigatorViewController alloc] initWithNibName:@"AINavigatorViewController" bundle:nil];
    self.navigatorViewController.root = [projectContents valueForKey:@"AIFileTree"];
    self.navigatorViewController.fileURLs = [projectContents valueForKey:@"AIFileURLs"];
    [self.splitView addArrangedSubview:self.navigatorViewController.view];
    
    
    self.codeViewController = [[AICodeViewController2 alloc] initWithNibName:@"AICodeViewController2" bundle:nil];
    self.codeViewController.content = [NSString string];
    [self.splitView addArrangedSubview:self.codeViewController.view];
}

@end
