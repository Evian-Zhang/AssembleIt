//
//  AIFileNode.m
//  AssembleIt
//
//  Created by Evian张 on 2019/3/10.
//  Copyright © 2019 Evian张. All rights reserved.
//

#import "AIFileNode.h"

@implementation AIFileNode

@synthesize nodeURL = _nodeURL;
@synthesize parent = _parent;
@synthesize children = _children;
@synthesize leaf = _leaf;
@synthesize fileNodeType = _fileNodeType;

- (instancetype)init {
    if (self = [super init]) {
        self.leaf = NO;
        self.fileNodeType = AIFileNodeFolderType;
        return self;
    }
    return nil;
}

- (NSString *)fileName {
    return self.nodeURL.lastPathComponent;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.nodeURL forKey:@"nodeURL"];
    [aCoder encodeObject:self.parent forKey:@"parent"];
    [aCoder encodeObject:self.children forKey:@"children"];
    [aCoder encodeBool:self.isLeaf forKey:@"leaf"];
    [aCoder encodeInt:self.fileNodeType forKey:@"fileNodeType"];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        self.nodeURL = [aDecoder decodeObjectForKey:@"nodeURL"];
        self.parent = [aDecoder decodeObjectForKey:@"parent"];
        NSArray<AIFileNode *> *immutableChildren = [aDecoder decodeObjectForKey:@"children"];
        if (immutableChildren) {
            self.children = [immutableChildren mutableCopy];
        } else {
            self.children = nil;
        }
        self.leaf = [aDecoder decodeBoolForKey:@"leaf"];
        self.fileNodeType = [aDecoder decodeIntForKey:@"fileNodeType"];
        return self;
    }
    return nil;
}

+ (BOOL)supportsSecureCoding {
    return YES;
}

@end
