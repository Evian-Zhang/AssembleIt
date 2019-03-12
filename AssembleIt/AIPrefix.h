//
//  AIPrefix.h
//  AssembleIt
//
//  Created by Evian张 on 2019/3/12.
//  Copyright © 2019 Evian张. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AIPrefix : NSObject

typedef enum AIPanelStatus {
    AICreatePanelStatus,
    AIOpenPanelStatus
} AIPanelStatus;

typedef enum AISplitViewIndex {
    NAVIGATORVIEW = 0,
    CODEVIEW,
} AISplitViewIndex;

typedef struct AIFileInfo {
    BOOL hasChanged;
    NSString *fileContent;
} AIFileInfo;

@end

NS_ASSUME_NONNULL_END
