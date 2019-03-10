//
//  AINavigatorViewController.h
//  AssembleIt
//
//  Created by Evian张 on 2019/3/9.
//  Copyright © 2019 Evian张. All rights reserved.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface AINavigatorViewController : NSViewController <NSOutlineViewDelegate, NSOutlineViewDataSource>

@property (nonatomic) IBOutlet NSOutlineView *outlineView;

@property (nonatomic) NSString *projectURL;
@property (nonatomic) NSArray *fileURLs;

@end

NS_ASSUME_NONNULL_END
