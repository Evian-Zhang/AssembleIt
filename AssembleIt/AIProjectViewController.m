//
//  AIProjectViewController.m
//  AssembleIt
//
//  Created by Evian张 on 2019/3/4.
//  Copyright © 2019 Evian张. All rights reserved.
//

#import "AIProjectViewController.h"

@interface AIProjectViewController ()

@end

@implementation AIProjectViewController

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

@end
