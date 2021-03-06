//
//  AINavigatorViewController.h
//  AssembleIt
//
//  Created by Evian张 on 2019/3/9.
//  Copyright © 2019 Evian张. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "AIPrefix.h"
#import "AIFileNode.h"

NS_ASSUME_NONNULL_BEGIN

@interface AINavigatorViewController : NSViewController <NSOutlineViewDelegate, NSOutlineViewDataSource, NSTextFieldDelegate>

@property (nonatomic) IBOutlet NSOutlineView *outlineView;
@property (nonatomic) IBOutlet NSTableCellView *tableCellView;
@property (nonatomic) IBOutlet NSMenu *contextualMenu;
@property (nonatomic) IBOutlet NSMenuItem *createFileItem;
@property (nonatomic) IBOutlet NSMenuItem *createFolderItem;
@property (nonatomic) IBOutlet NSMenuItem *addFilesItem;

@property (nonatomic) AIFileNode *root;
@property (nonatomic) AIFileNode *currentFileNode;
@property (nonatomic) NSMutableArray<AIFileNode *> *fileNodes;
@property (nonatomic) AIFileNode *projectNode;

- (void)changeCurrentFileNodeTo:(AIFileNode *)fileNode;

@end

NS_ASSUME_NONNULL_END
