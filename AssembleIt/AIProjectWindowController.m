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
    self.projectViewController = [[AIProjectViewController alloc] initWithNibName:@"AIProjectViewController" bundle:nil];
    self.contentViewController = self.projectViewController;
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}

@end
