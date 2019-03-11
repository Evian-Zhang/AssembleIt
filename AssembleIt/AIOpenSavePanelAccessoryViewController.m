//
//  AIOpenSavePanelAccessoryViewController.m
//  AssembleIt
//
//  Created by Evian张 on 2019/3/11.
//  Copyright © 2019 Evian张. All rights reserved.
//

#import "AIOpenSavePanelAccessoryViewController.h"

@interface AIOpenSavePanelAccessoryViewController ()

@end

@implementation AIOpenSavePanelAccessoryViewController

@synthesize folders = _folders;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    self.folderChooseButton.target = self;
    self.folderChooseButton.action = @selector(handleFolderChooseButton:);
}

- (void)viewDidAppear {
    [self.folderChooseButton.menu removeAllItems];
    for (AIFileNode *folderNode in self.folders) {
        NSMenuItem *menuItem = [[NSMenuItem alloc] initWithTitle:folderNode.fileName action:nil keyEquivalent:@""];
        menuItem.representedObject = folderNode;
        [self.folderChooseButton.menu addItem:menuItem];
    }
    self.currentFolder = self.folderChooseButton.itemArray[0].representedObject;
}

- (void)handleFolderChooseButton:(id)sender {
    NSPopUpButton *popUpButton = (NSPopUpButton *)sender;
    self.currentFolder = (AIFileNode *)popUpButton.selectedItem.representedObject;
}

@end
