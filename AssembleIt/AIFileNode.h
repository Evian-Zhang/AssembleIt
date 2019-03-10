//
//  AIFileNode.h
//  AssembleIt
//
//  Created by Evian张 on 2019/3/10.
//  Copyright © 2019 Evian张. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AIFileNode : NSObject <NSSecureCoding>

@property (nonatomic) NSURL *rootURL;
@property (nonatomic) NSMutableArray<AIFileNode *> *children;
@property (nonatomic, getter = isLeaf) BOOL leaf;

@end

NS_ASSUME_NONNULL_END
