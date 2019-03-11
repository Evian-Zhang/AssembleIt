//
//  AIProjectDocument.m
//  AssembleIt
//
//  Created by Evian张 on 2019/3/4.
//  Copyright © 2019 Evian张. All rights reserved.
//

#import "AIProjectDocument.h"

@implementation AIProjectDocument

@synthesize accessoryViewController = _accessoryViewController;
@synthesize projectName = _projectName;
@synthesize projectContents = _projectContents;
@synthesize panelStatus = _panelStatus;

#pragma mark - initializer
- (instancetype)init {
    if (self = [super init]) {
        self.projectContents = [NSMutableDictionary dictionary];
        [self initNotifications];
        return self;
    }
    return nil;
}

- (instancetype)initWithType:(NSString *)typeName error:(NSError * _Nullable __autoreleasing *)outError {
    if (self = [super initWithType:typeName error:outError]) {
        return self;
    }
    return nil;
}

- (void)initNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(windowDidAppear) name:@"AIProjectWindowSetUpComplete" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleAIProjectViewStartViewOkButtonPressedNotification:) name:@"AIProjectViewStartViewOkButtonPressed" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleAIProjectViewStartViewCancelButtonPressedNotification) name:@"AIProjectViewStartViewCancelButtonPressed" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleCreateFileForNodeNotification:) name:@"AICreateFileForNode" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleAddFilesForNodeNotification:) name:@"AIAddFilesForNode" object:nil];
}

#pragma mark - window controller of document
- (NSString *)windowNibName {
    // Override to return the nib file name of the document.
    // If you need to use a subclass of NSWindowController or if your document supports multiple NSWindowControllers, you should remove this method and override -makeWindowControllers instead.
    return @"AIProjectWindowController";
}

- (void)makeWindowControllers {
    AIProjectWindowController *projectWindowController = [[AIProjectWindowController alloc] initWithWindowNibName:@"AIProjectWindowController" owner:self];
    [projectWindowController awakeFromNib];
    [self addWindowController:projectWindowController];
}

- (void)windowControllerDidLoadNib:(AIProjectWindowController *)aController {
    [super windowControllerDidLoadNib:aController];
    // Add any code here that needs to be executed once the windowController has loaded the document's window.
}

- (void)windowDidAppear {
    if (self.fileURL) {
        [self buildWindow];
    } else {
        AIProjectWindowController *projectWindowController = (AIProjectWindowController *)self.windowControllers[0];
        [projectWindowController displayStartView];
    }
}

#pragma mark - build window
- (void)buildWindow {
    AIProjectWindowController *projectWindowController = (AIProjectWindowController *)self.windowControllers[0];
    [projectWindowController buildViewWithProjectContents:self.projectContents];
}

#pragma mark - write
- (NSData *)dataOfType:(NSString *)typeName error:(NSError **)outError {
    // Insert code here to write your document to data of the specified type. If outError != NULL, ensure that you create and set an appropriate error if you return nil.
    // Alternatively, you could remove this method and override -fileWrapperOfType:error:, -writeToURL:ofType:error:, or -writeToURL:ofType:forSaveOperation:originalContentsURL:error: instead.
    NSError *error;
    NSData *data = [self dataWithDictionary:self.projectContents];
    
    if (error) {
        NSLog(@"%@", error);
    }
    
    if (outError) {
        *outError = [NSError errorWithDomain:NSOSStatusErrorDomain code:unimpErr userInfo:nil];
    }
    return data;
}

- (BOOL)writeToURL:(NSURL *)url ofType:(NSString *)typeName error:(NSError * _Nullable __autoreleasing *)outError {
    
    return [super writeToURL:url ofType:typeName error:outError];
}

- (BOOL)writeSafelyToURL:(NSURL *)url ofType:(NSString *)typeName forSaveOperation:(NSSaveOperationType)saveOperation error:(NSError * _Nullable __autoreleasing *)outError {
    
    return [super writeSafelyToURL:url ofType:typeName forSaveOperation:saveOperation error:outError];
}

- (NSData *)dataWithDictionary:(NSDictionary *)dictionary {
    NSError *error;
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:dictionary requiringSecureCoding:YES error:&error];
    if (error) {
        NSLog(@"%@", error);
    }
    return data;
}

#pragma mark - read
- (BOOL)readFromData:(NSData *)data ofType:(NSString *)typeName error:(NSError **)outError {
    // Insert code here to read your document from the given data of the specified type. If outError != NULL, ensure that you create and set an appropriate error if you return NO.
    // Alternatively, you could remove this method and override -readFromFileWrapper:ofType:error: or -readFromURL:ofType:error: instead.
    // If you do, you should also override -isEntireFileLoaded to return NO if the contents are lazily loaded.
    //self.projectContents = [NSDictionary propertyList];
    self.projectContents = [self dictionaryWithData:data];
    return YES;
}

- (NSMutableDictionary *)dictionaryWithData:(NSData *)data {
    NSSet *unarchivedClasses = [NSSet setWithObjects:[NSDictionary class], [AIFileNode class], [NSURL class], [NSMutableArray class], nil];
    NSError *error;
    NSDictionary *dictionary = [NSKeyedUnarchiver unarchivedObjectOfClasses:unarchivedClasses fromData:data error:&error];
    if (error) {
        NSLog(@"%@", error);
    }
    return [dictionary mutableCopy];
}

#pragma mark - autosave
+ (BOOL)autosavesInPlace {
    return YES;
}


#pragma mark - create new file
- (void)handleCreateFileForNodeNotification:(NSNotification *)aNotification {
    NSDictionary *userInfo = aNotification.userInfo;
    AIFileNode *fileNode = [userInfo valueForKey:@"fileNode"];
    NSSavePanel *savePanel = [NSSavePanel savePanel];
    savePanel.prompt = NSLocalizedString(@"create", @"Button Prompt of create panel in new asm file");
    savePanel.allowedFileTypes = @[@"asm"];
    savePanel.allowsOtherFileTypes = NO;
    savePanel.nameFieldStringValue = @"untitled.asm";
    if (fileNode.fileNodeType == AIFileNodeFolderType) {
        [savePanel setDirectoryURL:fileNode.nodeURL];
    } else {
        AIFileNode *root = [userInfo valueForKey:@"root"];
        savePanel.directoryURL = root.nodeURL;
    }
    if (!self.accessoryViewController) {
        self.accessoryViewController = [[AIOpenSavePanelAccessoryViewController alloc] initWithNibName:@"AIOpenSavePanelAccessoryViewController" bundle:nil];
    }
    NSMutableArray<AIFileNode *> *folders = [NSMutableArray<AIFileNode *> array];
    NSMutableArray<AIFileNode *> *fileNodes = [self.projectContents valueForKey:@"AIFileNodes"];
    for (AIFileNode *tmpFileNode in fileNodes) {
        if (tmpFileNode.fileNodeType == AIFileNodeFolderType) {
            [folders addObject:tmpFileNode];
        }
    }
    self.accessoryViewController.folders = folders;
    self.accessoryViewController.directoryNode = [self.projectContents valueForKey:@"AISrcNode"];
    savePanel.accessoryView = self.accessoryViewController.view;
    [savePanel beginSheetModalForWindow:self.windowForSheet completionHandler:^(NSModalResponse result) {
        switch (result) {
            case NSModalResponseOK:
            {
                [[NSFileManager defaultManager] createFileAtPath:savePanel.URL.path contents:nil attributes:nil];
                AIFileNode *fileNode = [AIFileNode fileNodeWIthURL:savePanel.URL fileNodeType:AIFileNodeASMType toParentNode:self.accessoryViewController.currentFolder isLeaf:YES];
                [fileNodes addObject:fileNode];
                AIProjectWindowController *projectWindowController = (AIProjectWindowController *)self.windowControllers[0];
                [projectWindowController.projectViewController.navigatorViewController changeCurrentFileNodeTo:fileNode];
                [self updateChangeCount:NSChangeDone];
            }
                break;
                
            case NSModalResponseCancel:
            {
                
            }
                break;
                
            default:
                break;
        }
    }];
}

#pragma mark - add new files
- (void)handleAddFilesForNodeNotification:(NSNotification *)aNotification {
    NSDictionary *userInfo = aNotification.userInfo;
    AIFileNode *fileNode = [userInfo valueForKey:@"fileNode"];
    NSOpenPanel *openPanel = [NSOpenPanel openPanel];
    openPanel.allowedFileTypes = @[@"asm"];
    openPanel.allowsOtherFileTypes = NO;
    openPanel.canChooseDirectories = YES;
    AIFileNode *directoryNode;
    if (fileNode.fileNodeType == AIFileNodeFolderType) {
        directoryNode = fileNode;
    } else {
        directoryNode = fileNode.parent;
        if (!directoryNode) {
            directoryNode = (AIFileNode *)[self.projectContents valueForKey:@"AIFileTree"];
        }
    }
    if (!self.accessoryViewController) {
        self.accessoryViewController = [[AIOpenSavePanelAccessoryViewController alloc] initWithNibName:@"AIOpenSavePanelAccessoryViewController" bundle:nil];
    }
    NSMutableArray<AIFileNode *> *folders = [NSMutableArray<AIFileNode *> array];
    NSMutableArray<AIFileNode *> *fileNodes = [self.projectContents valueForKey:@"AIFileNodes"];
    for (AIFileNode *tmpFileNode in fileNodes) {
        if (tmpFileNode.fileNodeType == AIFileNodeFolderType) {
            [folders addObject:tmpFileNode];
        }
    }
    self.accessoryViewController.folders = folders;
    self.accessoryViewController.directoryNode = directoryNode;
    openPanel.accessoryView = self.accessoryViewController.view;
    openPanel.accessoryViewDisclosed = YES;
    openPanel.delegate = self;
    self.panelStatus = AIOpenPanelStatus;
    [openPanel beginSheetModalForWindow:self.windowForSheet completionHandler:^(NSModalResponse result) {
        switch (result) {
            case NSModalResponseOK:
            {
                for (NSURL *url in openPanel.URLs) {
                    AIFileNodeType fileNodeType = AIFileNodeASMType;
                    BOOL isDirectory;
                    [[NSFileManager defaultManager] fileExistsAtPath:url.path isDirectory:&isDirectory];
                    if (isDirectory) {
                        fileNodeType = AIFileNodeFolderType;
                    }
                    AIFileNode *addedFileNode = [AIFileNode fileNodeWIthURL:url fileNodeType:fileNodeType toParentNode:self.accessoryViewController.currentFolder isLeaf:!isDirectory];
                    [fileNodes addObject:addedFileNode];
                    AIProjectWindowController *projectWindowController = (AIProjectWindowController *)self.windowControllers[0];
                    [projectWindowController.projectViewController.navigatorViewController.outlineView reloadData];
                    [self updateChangeCount:NSChangeDone];
                }
            }
                break;
                
            default:
                break;
        }
    }];
    
}

#pragma mark - open a new document and save
- (void)handleAIProjectViewStartViewOkButtonPressedNotification:(NSNotification *)aNotification {
    NSDictionary *userInfo = aNotification.userInfo;
    self.projectName = [userInfo valueForKey:@"AIProjectName"];
    
    AIProjectWindowController *projectWindowController = (AIProjectWindowController *)self.windowControllers[0];
    [projectWindowController dismissStartView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(startViewDidClose) name:NSWindowDidEndSheetNotification object:nil];
    NSOpenPanel *createPanel = [NSOpenPanel openPanel];
    createPanel.prompt = NSLocalizedString(@"Create", @"Button Prompt of create panel");
    createPanel.delegate = self;
    createPanel.canChooseFiles = NO;
    createPanel.canChooseDirectories = YES;
    self.panelStatus = AICreatePanelStatus;
    [createPanel beginSheetModalForWindow:self.windowForSheet completionHandler:^(NSModalResponse result) {
        switch (result) {
            case NSModalResponseOK:
            {
                NSString *primaryPath = [createPanel.URLs[0] absoluteString];
                NSString *mainDirectoryPath = [NSString stringWithFormat:@"%@%@/", primaryPath, self.projectName];
                NSString *projectPath = [NSString stringWithFormat:@"%@%@.aiproj", mainDirectoryPath, self.projectName];
                NSURL *projectURL = [NSURL URLWithString:projectPath];
                
                [self appendProjectNodeWithURL:projectURL andSrcNodeAndProductNodeAndMainDirectoryURL:[NSURL URLWithString:mainDirectoryPath]];
                
                NSError *error;
                [self writeSafelyToURL:projectURL ofType:@"com.zhang.evian.aiproj" forSaveOperation:NSSaveAsOperation error:&error];
                if (error) {
                    NSLog(@"%@", error);
                }
                
                self.fileURL = projectURL;
                self.fileType = @"com.zhang.evian.aiproj";
                [self saveDocument:self];
            }
                break;

            case NSModalResponseCancel:
            {
                
            }
                break;

            default:
                break;
        }
    }];
}

- (void)handleAIProjectViewStartViewCancelButtonPressedNotification {
    AIProjectWindowController *projectWindowController = (AIProjectWindowController *)self.windowControllers[0];
    [projectWindowController dismissStartView];
    [self close];
}

- (void)startViewDidClose {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NSWindowDidEndSheetNotification object:nil];
    if (self.fileURL) {
        [self buildWindow];
    } else {
        AIProjectWindowController *projectWindowController = (AIProjectWindowController *)self.windowControllers[0];
        [projectWindowController displayStartView];
    }
}

- (void)appendProjectNodeWithURL:(NSURL *)projectUrl andSrcNodeAndProductNodeAndMainDirectoryURL:(NSURL *)mainDirectoryUrl {
    NSException *fileTreeEmptyException = [[NSException alloc] initWithName:@"AIFileTreeEmptyError" reason:@"fileTree == nil" userInfo:nil];
    NSException *fileURLsEmptyException = [[NSException alloc] initWithName:@"AIFileURLsEmptyError" reason:@"fileURLs == nil" userInfo:nil];
    @try {
        AIFileNode *root = [self.projectContents valueForKey:@"AIFileTree"];
        if (!root) {
            @throw(fileTreeEmptyException);
        }
        AIFileNode *projectNode = [[AIFileNode alloc] init];
        projectNode.nodeURL = projectUrl;
        projectNode.parent = root;
        projectNode.leaf = YES;
        projectNode.fileNodeType = AIFileNodeProjectType;
        root.children = [NSMutableArray<AIFileNode *> array];
        [root.children addObject:projectNode];
        [self.projectContents setValue:projectNode forKey:@"AIProjectNode"];
        
        NSURL *srcURL = [mainDirectoryUrl URLByAppendingPathComponent:@"src/" isDirectory:YES];
        [[NSFileManager defaultManager] createDirectoryAtURL:srcURL  withIntermediateDirectories:NO attributes:nil error:nil];
        AIFileNode *srcNode = [[AIFileNode alloc] init];
        srcNode.nodeURL = srcURL;
        srcNode.parent = root;
        srcNode.fileNodeType = AIFileNodeFolderType;
        srcNode.leaf = NO;
        [root.children addObject:srcNode];
        [self.projectContents setValue:srcNode forKey:@"AISrcNode"];
        
        NSURL *productURL = [mainDirectoryUrl URLByAppendingPathComponent:@"product/" isDirectory:YES];
        [[NSFileManager defaultManager] createDirectoryAtURL:productURL withIntermediateDirectories:NO attributes:nil error:nil];
        AIFileNode *productNode = [[AIFileNode alloc] init];
        productNode.nodeURL = productURL;
        productNode.parent = root;
        productNode.fileNodeType = AIFileNodeFolderType;
        productNode.leaf = NO;
        [root.children addObject:productNode];
        [self.projectContents setValue:productNode forKey:@"AIProductNode"];
        
        NSMutableArray<AIFileNode *> *fileNodes = [self.projectContents valueForKey:@"AIFileNodes"];
        if (!fileNodes) {
            @throw(fileURLsEmptyException);
        }
        [fileNodes addObject:projectNode];
        [fileNodes addObject:srcNode];
        [fileNodes addObject:productNode];
    }
    @catch (NSException *exception) {
        NSLog(@"%@\nReason:%@", exception.name, exception.reason);
    }
}

#pragma mark conform to <NSOpenSavePanelDelegate>
- (BOOL)panel:(id)sender validateURL:(NSURL *)url error:(NSError * _Nullable __autoreleasing *)outError {
    switch (self.panelStatus) {
        case AICreatePanelStatus:
        {
            NSString *primaryPath = [url absoluteString];
            NSString *processedPath = [NSString stringWithFormat:@"%@%@/", primaryPath, self.projectName];
            NSURL *processedURL = [NSURL URLWithString:processedPath];
            BOOL hasCreatedDirectory = [[NSFileManager defaultManager] createDirectoryAtURL:processedURL withIntermediateDirectories:NO attributes:nil error:outError];
            if (hasCreatedDirectory) {
                AIFileNode *root = [[AIFileNode alloc] init];
                root.nodeURL = processedURL;
                root.parent = nil;
                root.leaf = NO;
                root.fileNodeType = AIFileNodeFolderType;
                [self.projectContents setObject:root forKey:@"AIFileTree"];
                
                NSMutableArray<AIFileNode *> *fileNodes = [NSMutableArray<AIFileNode *> array];
                [fileNodes addObject:root];
                [self.projectContents setObject:fileNodes forKey:@"AIFileNodes"];
            }
            return hasCreatedDirectory;
        }
            break;
            
        case AIOpenPanelStatus:
        {
            NSMutableArray<AIFileNode *> *fileNodes = [self.projectContents valueForKey:@"AIFileNodes"];
            for (AIFileNode *fileNode in fileNodes) {
                if ([fileNode.nodeURL isEqualTo:url]) {
                    NSError *error = [[NSError alloc] initWithDomain:NSCocoaErrorDomain code:516 userInfo:@{NSLocalizedDescriptionKey:NSLocalizedString(@"This file or folder has existed in the project", @"error description of duplicated files"), NSLocalizedRecoverySuggestionErrorKey:NSLocalizedString(@"To solve this problem, you should select another file or folder", @"error suggestion of duplicated files")}];
                    *outError = error;
                    return NO;
                }
            }
            return YES;
        }
            break;
    }
    return YES;
}

@end
