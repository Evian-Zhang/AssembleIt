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

@synthesize root = _root;
@synthesize currentFileNode = _currentFileNode;
@synthesize fileNodes = _fileNodes;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    self.outlineView.delegate = self;
    self.outlineView.dataSource = self;
    self.tableCellView.textField.delegate = self;
    self.createFileItem.target = self;
    self.createFileItem.action = @selector(handleCreateFileItem);
    self.createFolderItem.target = self;
    self.createFolderItem.action = @selector(handleCreateFolderItem);
    self.addFilesItem.target = self;
    self.addFilesItem.action = @selector(handleAddFilesItem);
}

- (void)viewDidAppear {
    [self.outlineView reloadData];
    
    self.currentFileNode = self.projectNode;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"AIFileTableSelectionDidChangeNotification" object:nil userInfo:@{@"currentFileNode":self.currentFileNode}];
}

- (void)handleCreateFileItem {
    AIFileNode *clickedFileNode = [self.outlineView itemAtRow:self.outlineView.clickedRow];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"AICreateFileForNode" object:nil userInfo:@{@"fileNode":clickedFileNode, @"root":self.root}];
}

- (void)handleCreateFolderItem {
    AIFileNode *clickedFileNode = [self.outlineView itemAtRow:self.outlineView.clickedRow];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"AICreateFolderForNode" object:nil userInfo:@{@"fileNode":clickedFileNode, @"root":self.root}];
}

- (void)handleAddFilesItem {
    AIFileNode *clickedFileNode = [self.outlineView itemAtRow:self.outlineView.clickedRow];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"AIAddFilesForNode" object:nil userInfo:@{@"fileNode":clickedFileNode, @"root":self.root}];
}

- (void)changeCurrentFileNodeTo:(AIFileNode *)fileNode {
    self.currentFileNode = fileNode;
    [self.outlineView reloadData];
}

#pragma mark - conform to <NSOutlineViewDataSource>
- (BOOL)outlineView:(NSOutlineView *)outlineView isItemExpandable:(id)item {
    if (item) {
        AIFileNode *fileNode = item;
        return !fileNode.isLeaf;
    }
    return YES;
}

- (NSInteger)outlineView:(NSOutlineView *)outlineView numberOfChildrenOfItem:(id)item {
    if (item) {
        AIFileNode *fileNode = item;
        if (fileNode.children) {
            return fileNode.children.count;
        }
        return 0;
    }
    return 1;
}

- (id)outlineView:(NSOutlineView *)outlineView child:(NSInteger)index ofItem:(id)item {
    if (item) {
        AIFileNode *fileNode = item;
        if (fileNode.children) {
            return fileNode.children[index];
        }
        return nil;
    }
    return self.root;
}

- (id)outlineView:(NSOutlineView *)outlineView objectValueForTableColumn:(NSTableColumn *)tableColumn byItem:(id)item {
    return item;
}

#pragma mark - conform to <NSOutlineViewDelegate>
- (NSView *)outlineView:(NSOutlineView *)outlineView viewForTableColumn:(NSTableColumn *)tableColumn item:(id)item {
    AIFileNode *fileNode = item;
    NSTableCellView *tableCellView = [outlineView makeViewWithIdentifier:@"AIFileTableIdentifier" owner:self];
    tableCellView.textField.stringValue = fileNode.fileName;
    tableCellView.textField.delegate = self;
    return tableCellView;
}

- (void)outlineViewSelectionDidChange:(NSNotification *)notification {
    AIFileNode *selectedFileNode = [self.outlineView itemAtRow:self.outlineView.selectedRow];
    if (selectedFileNode) {
        BOOL isFile = YES;
        switch (selectedFileNode.fileNodeType) {
            case AIFileNodeFolderType:
                isFile = NO;
                break;
                
            default:
                break;
        }
        if (isFile) {
            self.currentFileNode = selectedFileNode;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"AIFileTableSelectionDidChangeNotification" object:nil userInfo:@{@"currentFileNode":self.currentFileNode}];
        }
    }
}


- (void)controlTextDidEndEditing:(NSNotification *)obj {
    NSDictionary *userInfo = obj.userInfo;
    NSTextView *textView = [userInfo objectForKey:@"NSFieldEditor"];
    AIFileNode *fileNode = [self.outlineView itemAtRow:self.outlineView.selectedRow];
    NSString *newName = [textView.string copy];
    if (![newName isEqualToString:fileNode.fileName]) {
        NSURL *oldURL = [fileNode.nodeURL copy];
        NSURL *newURL = [[oldURL URLByDeletingLastPathComponent] URLByAppendingPathComponent:newName isDirectory:(fileNode.fileNodeType == AIFileNodeFolderType)];
        BOOL hasFile = [[NSFileManager defaultManager] fileExistsAtPath:newURL.path];
        if (hasFile) {
            textView.string = fileNode.fileName;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"AIFileNameHasExistedNotification" object:nil];
        } else {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"AIFileNameDidChangeNotification" object:nil userInfo:@{@"newName":newName, @"fileNode":fileNode}];
        }
    }
}

@end
