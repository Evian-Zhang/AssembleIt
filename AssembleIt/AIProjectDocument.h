//
//  AIProjectDocument.h
//  AssembleIt
//
//  Created by Evian张 on 2019/3/4.
//  Copyright © 2019 Evian张. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "AIProjectViewController.h"
#import "AIProjectWindowController.h"

NS_ASSUME_NONNULL_BEGIN

@interface AIProjectDocument : NSDocument

@property (nonatomic, getter = isCreated) BOOL created;
@property (nonatomic, copy) NSDictionary *projectContents;

@end

NS_ASSUME_NONNULL_END

