//
//  AIProjectWindowController.m
//  AssembleIt
//
//  Created by Evian张 on 2019/3/5.
//  Copyright © 2019 Evian张. All rights reserved.
//

#import "AIProjectWindowController.h"

@interface AIProjectWindowController ()

@end

@implementation AIProjectWindowController

@synthesize projectViewController = _projectViewController;

- (void)windowDidLoad {
    [super windowDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(windowDidAppear) name:@"AIProjectViewDidAppear" object:nil];
    
    self.projectViewController = [[AIProjectViewController alloc] initWithNibName:@"AIProjectViewController" bundle:nil];
    self.contentViewController = self.projectViewController;
}

- (void)displayStartView {
    AIProjectStartViewController *startViewController = self.projectViewController.startViewController;
    [self.contentViewController presentViewControllerAsSheet:startViewController];
}

- (void)windowDidAppear {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"AIProjectWindowSetUpComplete" object:nil];
}

@end
