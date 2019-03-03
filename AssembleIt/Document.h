//
//  Document.h
//  AssembleIt
//
//  Created by Evian张 on 2019/3/3.
//  Copyright © 2019 Evian张. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "AICodeViewController.h"

@interface Document : NSDocument

@property (nonatomic) AICodeViewController *codeViewController;

@property (nonatomic, copy) NSArray<NSString*> *codeLines;

@end

