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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleCreateFileForNodeNotification:) name:@"AICreateFileForNode" object:nil];
    
    self.projectViewController = [[AIProjectViewController alloc] initWithNibName:@"AIProjectViewController" bundle:nil];
    self.contentViewController = self.projectViewController;
}

- (void)windowDidAppear {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"AIProjectWindowSetUpComplete" object:nil];
}

- (void)displayStartView {
    AIProjectStartViewController *startViewController = self.projectViewController.startViewController;
    [self.contentViewController presentViewControllerAsSheet:startViewController];
}

- (void)dismissStartView {
    AIProjectStartViewController *startViewController = self.projectViewController.startViewController;
    [self.contentViewController dismissViewController:startViewController];
}

- (void)buildViewWithProjectContents:(NSMutableDictionary *)projectContents {
    [self.projectViewController buildViewWithProjectContents:projectContents];
}

- (void)handleCreateFileForNodeNotification:(NSNotification *)aNotification {
    NSDictionary *userInfo = aNotification.userInfo;
    AIFileNode *fileNode = [userInfo valueForKey:@"fileNode"];
    NSSavePanel *savePanel = [NSSavePanel savePanel];
    savePanel.prompt = NSLocalizedString(@"create", @"Button Prompt of create panel in new asm file");
    savePanel.allowedFileTypes = @[@"asm"];
    savePanel.allowsOtherFileTypes = NO;
    savePanel.nameFieldStringValue = @"untitled.asm";
    if (fileNode.fileNodeType == AIFileNodeFolderType) {
        [savePanel setDirectoryURL:fileNode.nodeURL];
    } else {
        AIFileNode *root = [userInfo valueForKey:@"root"];
        savePanel.directoryURL = root.nodeURL;
    }
    [savePanel beginSheetModalForWindow:self.window completionHandler:^(NSModalResponse result) {
        switch (result) {
            case NSModalResponseOK:
            {
                [[NSFileManager defaultManager] createFileAtPath:savePanel.URL.path contents:nil attributes:nil];
                [self.projectViewController.navigatorViewController createNewFileWithURL:savePanel.URL andDirectoryURL:savePanel.directoryURL forParent:fileNode];
            }
                break;
                
            case NSModalResponseCancel:
            {
                
            }
                break;
                
            default:
                break;
        }
    }];
}

@end
