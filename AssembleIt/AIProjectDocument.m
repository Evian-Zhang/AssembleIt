//
//  AIProjectDocument.m
//  AssembleIt
//
//  Created by Evian张 on 2019/3/4.
//  Copyright © 2019 Evian张. All rights reserved.
//

#import "AIProjectDocument.h"

@implementation AIProjectDocument

@synthesize projectViewController = _projectViewController;

@synthesize created = _created;
@synthesize projectContents = _projectContents;

- (instancetype)init {
    if (self = [super init]) {
        self.created = NO;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(windowDidAppear) name:@"AIProjectViewDidAppear" object:nil];
        return self;
    }
    return nil;
}

- (instancetype)initWithType:(NSString *)typeName error:(NSError * _Nullable __autoreleasing *)outError {
    if (self = [super initWithType:typeName error:outError]) {
        self.created = YES;
        return self;
    }
    return nil;
}

- (void)windowDidAppear {
    if (self.isCreated) {
        [self saveDocument:self];
    }
}

- (NSString *)windowNibName {
    // Override to return the nib file name of the document.
    // If you need to use a subclass of NSWindowController or if your document supports multiple NSWindowControllers, you should remove this method and override -makeWindowControllers instead.
    return @"AIProjectDocument";
}

- (void)windowControllerDidLoadNib:(NSWindowController *)aController {
    [super windowControllerDidLoadNib:aController];
    // Add any code here that needs to be executed once the windowController has loaded the document's window.
    self.projectViewController = [[AIProjectViewController alloc] initWithNibName:@"AIProjectViewController" bundle:nil];
    self.projectViewController.projectContents = [self.projectContents mutableCopy];
    aController.contentViewController = self.projectViewController;
}

- (NSData *)dataOfType:(NSString *)typeName error:(NSError **)outError {
    // Insert code here to write your document to data of the specified type. If outError != NULL, ensure that you create and set an appropriate error if you return nil.
    // Alternatively, you could remove this method and override -fileWrapperOfType:error:, -writeToURL:ofType:error:, or -writeToURL:ofType:forSaveOperation:originalContentsURL:error: instead.
    if (outError) {
        *outError = [NSError errorWithDomain:NSOSStatusErrorDomain code:unimpErr userInfo:nil];
    }
    return nil;
}

- (BOOL)readFromData:(NSData *)data ofType:(NSString *)typeName error:(NSError **)outError {
    // Insert code here to read your document from the given data of the specified type. If outError != NULL, ensure that you create and set an appropriate error if you return NO.
    // Alternatively, you could remove this method and override -readFromFileWrapper:ofType:error: or -readFromURL:ofType:error: instead.
    // If you do, you should also override -isEntireFileLoaded to return NO if the contents are lazily loaded.
    //self.projectContents = [NSDictionary propertyList];
    
    return YES;
}

-  (BOOL)readFromURL:(NSURL *)url ofType:(NSString *)typeName error:(NSError * _Nullable __autoreleasing *)outError {
    self.projectContents = [NSDictionary dictionaryWithContentsOfURL:url];
    return YES;
}

- (void)runModalSavePanelForSaveOperation:(NSSaveOperationType)saveOperation delegate:(id)delegate didSaveSelector:(SEL)didSaveSelector contextInfo:(void *)contextInfo {
    NSSavePanel *savePanel = [NSSavePanel savePanel];
    [savePanel setNameFieldStringValue:@"Untitle.aiproj"];
    [savePanel setMessage:NSLocalizedString(@"Choose the path to save the document", @"string for NSSavePanel of AIPROJ file")];
    [savePanel setAllowsOtherFileTypes:NO];
    [savePanel setAllowedFileTypes:@[@"aiproj"]];
    [savePanel setExtensionHidden:NO];
    [savePanel setCanCreateDirectories:YES];
    [savePanel beginSheetModalForWindow:self.windowForSheet completionHandler:^(NSInteger result) {
        switch (result) {
            case NSModalResponseOK:
            {
                NSString *path = [[savePanel URL] path];
                [@"onecodego" writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:nil];
            }
                break;
                
            case NSModalResponseCancel:
            {
                if (self.isCreated) {
                    [self close];
                }
            }
                break;
                
            default:
                break;
        }
    }];
}

+ (BOOL)autosavesInPlace {
    return YES;
}

@end
