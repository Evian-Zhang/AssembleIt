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
    self.projectNameField.delegate = self;
    self.okButton.action = @selector(handleOkButton);
    self.okButton.enabled = NO;
    self.cancelButton.action = @selector(handleCancelButton);
}


- (void)handleOkButton {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"AIProjectViewStartViewOkButtonPressed" object:self userInfo:@{@"AIProjectName":self.projectNameField.stringValue}];
}

- (void)handleCancelButton {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"AIProjectViewStartViewCancelButtonPressed" object:self];
}

- (void)controlTextDidChange:(NSNotification *)obj {
    if (self.projectNameField.stringValue.length > 0) {
        self.okButton.enabled = YES;
    } else {
        self.okButton.enabled = NO;
    }
}

@end
