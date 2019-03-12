//
//  AIOpenSavePanelAccessoryViewController.h
//  AssembleIt
//
//  Created by Evian张 on 2019/3/11.
//  Copyright © 2019 Evian张. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "AIPrefix.h"
#import "AIFileNode.h"

NS_ASSUME_NONNULL_BEGIN

@interface AIOpenSavePanelAccessoryViewController : NSViewController

@property (nonatomic) IBOutlet NSPopUpButton *folderChooseButton;

@property (nonatomic) NSMutableArray<AIFileNode *> *folders;
@property (nonatomic) AIFileNode *currentFolder;
@property (nonatomic) AIFileNode *directoryNode;

@end

NS_ASSUME_NONNULL_END
