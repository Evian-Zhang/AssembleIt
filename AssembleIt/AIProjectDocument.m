//
//  AIProjectDocument.m
//  AssembleIt
//
//  Created by Evian张 on 2019/3/4.
//  Copyright © 2019 Evian张. All rights reserved.
//

#import "AIProjectDocument.h"

@implementation AIProjectDocument

@synthesize projectContents = _projectContents;

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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleAIProjectViewStartViewOkButtonPressedNotification) name:@"AIProjectViewStartViewOkButtonPressed" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleAIProjectViewStartViewCancelButtonPressedNotification) name:@"AIProjectViewStartViewCancelButtonPressed" object:nil];
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
    NSData *data = [NSPropertyListSerialization dataWithPropertyList:self.projectContents format:NSPropertyListXMLFormat_v1_0 options:0 error:&error];
    
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
    [self.projectContents setValue:[url absoluteString] forKey:@"AIProjectURL"];
    return [super writeSafelyToURL:url ofType:typeName forSaveOperation:saveOperation error:outError];
}

- (void)document:(NSDocument *)doc didSave:(BOOL)didSave contextInfo:(void  *)contextInfo {
    if (didSave) {
        [self buildWindow];
    } else {
        AIProjectWindowController *projectWindowController = (AIProjectWindowController *)self.windowControllers[0];
        [projectWindowController displayStartView];
    }
}

- (void)saveDocumentWithDelegate:(id)delegate didSaveSelector:(SEL)didSaveSelector contextInfo:(void *)contextInfo {
    [super saveDocumentWithDelegate:self didSaveSelector:@selector(document:didSave:contextInfo:) contextInfo:contextInfo];
}

#pragma mark - read
- (BOOL)readFromData:(NSData *)data ofType:(NSString *)typeName error:(NSError **)outError {
    // Insert code here to read your document from the given data of the specified type. If outError != NULL, ensure that you create and set an appropriate error if you return NO.
    // Alternatively, you could remove this method and override -readFromFileWrapper:ofType:error: or -readFromURL:ofType:error: instead.
    // If you do, you should also override -isEntireFileLoaded to return NO if the contents are lazily loaded.
    //self.projectContents = [NSDictionary propertyList];
    NSError *error;
    NSPropertyListFormat propertyListFormat = NSPropertyListXMLFormat_v1_0;
    self.projectContents = (NSMutableDictionary *)[NSPropertyListSerialization propertyListWithData:data options:NSPropertyListMutableContainersAndLeaves format:&propertyListFormat error:&error];
    if (error) {
        NSLog(@"%@", error);
    }
    return YES;
}

-  (BOOL)readFromURL:(NSURL *)url ofType:(NSString *)typeName error:(NSError * _Nullable __autoreleasing *)outError {
    self.projectContents = [NSMutableDictionary dictionaryWithContentsOfURL:url];
    return YES;
}

#pragma mark - autosave
+ (BOOL)autosavesInPlace {
    return YES;
}

#pragma mark - open a new document and save
- (void)handleAIProjectViewStartViewOkButtonPressedNotification {
    AIProjectWindowController *projectWindowController = (AIProjectWindowController *)self.windowControllers[0];
    [projectWindowController dismissStartView];
    [self saveDocument:self];
}

- (void)handleAIProjectViewStartViewCancelButtonPressedNotification {
    AIProjectWindowController *projectWindowController = (AIProjectWindowController *)self.windowControllers[0];
    [projectWindowController dismissStartView];
    [self close];
}

@end
