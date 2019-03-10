//
//  AINavigatorViewController.m
//  AssembleIt
//
//  Created by Evian张 on 2019/3/9.
//  Copyright © 2019 Evian张. All rights reserved.
//

#import "AINavigatorViewController.h"

@interface AINavigatorViewController ()

@end

@implementation AINavigatorViewController

@synthesize projectURL = _projectURL;
@synthesize fileURLs = _fileURLs;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
}

- (BOOL)outlineView:(NSOutlineView *)outlineView isItemExpandable:(id)item {
    return YES;
}

@end
