//
//  AIFileNode.h
//  AssembleIt
//
//  Created by Evian张 on 2019/3/10.
//  Copyright © 2019 Evian张. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AIPrefix.h"

NS_ASSUME_NONNULL_BEGIN

@interface AIFileNode : NSObject <NSSecureCoding>

typedef enum {
    AIFileNodeProjectType,
    AIFileNodeFolderType,
    AIFileNodeASMType
} AIFileNodeType;

@property (nonatomic) NSURL *nodeURL;
@property (nonatomic, readonly) NSString *fileName;
@property (nonatomic, nullable) AIFileNode *parent;
@property (nonatomic, nullable) NSMutableArray<AIFileNode *> *children;
@property (nonatomic, getter = isLeaf) BOOL leaf;
@property (nonatomic) AIFileNodeType fileNodeType;

+ (AIFileNode *)fileNodeWIthURL:(NSURL *)nodeURL fileNodeType:(AIFileNodeType)fileNodeType toParentNode:(AIFileNode *)parent isLeaf:(BOOL)leaf;

@end

NS_ASSUME_NONNULL_END
