//
//  AIProjectViewController.h
//  AssembleIt
//
//  Created by Evian张 on 2019/3/4.
//  Copyright © 2019 Evian张. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "AIProjectStartViewController.h"
#import "AINavigatorViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface AIProjectViewController : NSViewController

@property (nonatomic) IBOutlet NSSplitView *splitView;

@property (nonatomic) AINavigatorViewController *navigatorViewController;
@property (nonatomic) AIProjectStartViewController *startViewController;
@property (nonatomic, copy) NSMutableDictionary *projectContents;

- (void)buildView;

@end

NS_ASSUME_NONNULL_END
