//
//  AINavigatorViewController.h
//  AssembleIt
//
//  Created by Evian张 on 2019/3/9.
//  Copyright © 2019 Evian张. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "AIFileNode.h"

NS_ASSUME_NONNULL_BEGIN

@interface AINavigatorViewController : NSViewController <NSOutlineViewDelegate, NSOutlineViewDataSource>

@property (nonatomic) IBOutlet NSOutlineView *outlineView;
@property (nonatomic) IBOutlet NSMenu *contextualMenu;
@property (nonatomic) IBOutlet NSMenuItem *createFileItem;

@property (nonatomic) AIFileNode *root;
@property (nonatomic) AIFileNode *currentFileNode;
@property (nonatomic) NSMutableArray<AIFileNode *> *fileNodes;

- (void)createNewFileWithURL:(NSURL *)url andDirectoryURL:(NSURL *)directoryUrl forParent:(AIFileNode *)parentNode;

@end

NS_ASSUME_NONNULL_END
