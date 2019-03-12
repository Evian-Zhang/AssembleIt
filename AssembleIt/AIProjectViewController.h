//
//  AIProjectViewController.h
//  AssembleIt
//
//  Created by Evian张 on 2019/3/4.
//  Copyright © 2019 Evian张. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "AIPrefix.h"
#import "AIProjectStartViewController.h"
#import "AINavigatorViewController.h"
#import "AICodeViewController2.h"

NS_ASSUME_NONNULL_BEGIN

@interface AIProjectViewController : NSViewController

@property (nonatomic) IBOutlet NSSplitView *splitView;

@property (nonatomic) AINavigatorViewController *navigatorViewController;
@property (nonatomic) AICodeViewController2 *codeViewController;
@property (nonatomic) AIProjectStartViewController *startViewController;
@property (nonatomic, strong) NSMutableDictionary *projectContents;
@property (nonatomic) NSMutableDictionary<NSURL *, NSMutableDictionary *> *fileInfos;

- (void)buildViewWithProjectContents:(NSMutableDictionary *)projectContents fileInfo:(NSMutableDictionary<NSURL *, NSMutableDictionary *> *)fileInfos;

@end

NS_ASSUME_NONNULL_END
