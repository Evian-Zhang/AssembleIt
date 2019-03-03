//
//  AICodeViewController.h
//  AssembleIt
//
//  Created by Evian张 on 2019/3/3.
//  Copyright © 2019 Evian张. All rights reserved.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface AICodeViewController : NSViewController <NSTableViewDelegate, NSTableViewDataSource>

@property (nonatomic) IBOutlet NSTableView *codeTable;

@property (nonatomic, copy) NSMutableArray<NSString*> *codeLines;

@end

NS_ASSUME_NONNULL_END
