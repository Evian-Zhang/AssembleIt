//
//  AIProjectStartViewController.m
//  AssembleIt
//
//  Created by Evian张 on 2019/3/8.
//  Copyright © 2019 Evian张. All rights reserved.
//

#import "AIProjectStartViewController.h"

@interface AIProjectStartViewController ()

@end

@implementation AIProjectStartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
}

- (void)viewDidAppear {
    self.okButton.action = @selector(handleOkButton);
    self.cancelButton.action = @selector(handleCancelButton);
}


- (void)handleOkButton {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"AIProjectViewStartWindowOkButtonPressed" object:self];
}

- (void)handleCancelButton {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"AIProjectViewStartWindowCancelButtonPressed" object:self];
}

@end
