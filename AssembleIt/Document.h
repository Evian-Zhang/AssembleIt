//
//  Document.h
//  AssembleIt
//
//  Created by Evian张 on 2019/3/3.
//  Copyright © 2019 Evian张. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "AIPrefix.h"
#import "AICodeViewController.h"
#import "AICodeViewController2.h"

@interface Document : NSDocument

@property (nonatomic) AICodeViewController *codeViewController;
@property (nonatomic) AICodeViewController2 *codeViewController2;

@property (nonatomic, copy) NSString *codeContent;
@property (nonatomic, copy) NSArray<NSString*> *codeLines;

@end

