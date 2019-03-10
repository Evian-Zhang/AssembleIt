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
@synthesize fileURLs = _fileURLs;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    self.outlineView.delegate = self;
    self.outlineView.dataSource = self;
}

- (void)viewDidAppear {
    [self.outlineView reloadData];
}

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
    return self.root.children.count;
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

- (NSView *)outlineView:(NSOutlineView *)outlineView viewForTableColumn:(NSTableColumn *)tableColumn item:(id)item {
    AIFileNode *fileNode = item;
    NSTableCellView *tableCellView = [outlineView makeViewWithIdentifier:@"AIFileTableIdentifier" owner:self];
    tableCellView.textField.stringValue = fileNode.fileName;
    return tableCellView;
}

@end
