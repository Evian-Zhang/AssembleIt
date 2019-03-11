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
@synthesize currentFolder = _currentFolder;
@synthesize directoryNode = _directoryNode;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    self.folderChooseButton.target = self;
    self.folderChooseButton.action = @selector(handleFolderChooseButton:);
}

- (void)viewDidAppear {
    [self.folderChooseButton.menu removeAllItems];
    NSMenuItem *directoryMenuItem;
    for (AIFileNode *folderNode in self.folders) {
        NSMenuItem *menuItem = [[NSMenuItem alloc] initWithTitle:folderNode.fileName action:nil keyEquivalent:@""];
        menuItem.representedObject = folderNode;
        if (folderNode == self.directoryNode) {
            directoryMenuItem = menuItem;
        }
        [self.folderChooseButton.menu addItem:menuItem];
    }
    [self.folderChooseButton selectItem:directoryMenuItem];
    self.currentFolder = self.directoryNode;
}

- (void)handleFolderChooseButton:(id)sender {
    NSPopUpButton *popUpButton = (NSPopUpButton *)sender;
    self.currentFolder = (AIFileNode *)popUpButton.selectedItem.representedObject;
}

@end
