//
//  AIProjectDocument.m
//  AssembleIt
//
//  Created by Evian张 on 2019/3/4.
//  Copyright © 2019 Evian张. All rights reserved.
//

#import "AIProjectDocument.h"

@implementation AIProjectDocument

@synthesize startAlert = _startAlert;

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
        

//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(startAlertDidClose) name:NSWindowDidEndSheetNotification object:nil];
//        [self.startAlert beginSheetModalForWindow:self.windowForSheet completionHandler:^(NSModalResponse returnCode) {
//            switch (returnCode) {
//                case NSAlertFirstButtonReturn:
//                {
//                    [self saveDocument:self];
//                }
//                    break;
//
//                case NSAlertSecondButtonReturn:
//                {
//
//                }
//                    break;
//
//                default:
//                    break;
//            }
//        }];
        AIProjectViewController *viewController = self.windowForSheet.contentViewController;
        [viewController.startWindow awakeFromNib];
        NSWindow *startWindow = viewController.startWindow;
        NSRect windowRect = self.windowForSheet.frame;
        NSRect startWindowRect = startWindow.frame;
        
        NSPoint pos;
        pos.x = windowRect.origin.x + windowRect.size.width / 2 - startWindowRect.size.width / 2;
        pos.y = windowRect.origin.y + self.windowForSheet.contentView.frame.size.height - startWindowRect.size.height;
        [startWindow setFrameOrigin:pos];
//        [viewController.startWindow beginSheet:self.windowForSheet completionHandler:^(NSModalResponse returnCode) {
//
//        }];
        startWindow.backgroundColor = [NSColor whiteColor];
        [startWindow makeKeyAndOrderFront:self];
    }
}

//- (NSRect)window:(NSWindow *)window willPositionSheet:(NSWindow *)sheet usingRect:(NSRect)rect {
//    return NSMakeRect(0, 0, 200, 100);
//}

- (void)startAlertDidClose {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NSWindowDidEndSheetNotification object:self.windowForSheet];
    [self close];
}

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
    aController.projectViewController.projectContents = [self.projectContents mutableCopy];
    self.startAlert = [[NSAlert alloc] init];
    self.startAlert.alertStyle = NSAlertStyleInformational;
    self.startAlert.messageText = NSLocalizedString(@"Create a new AssembleIt project", @"Message text in start alert of new aiproj");
    
    NSButton *okButton = [self.startAlert addButtonWithTitle:NSLocalizedString(@"Next", @"Title of OK button in start alert of new aiproj")];
    okButton.keyEquivalent = @"\r";
    
    NSButton *cancelButton = [self.startAlert addButtonWithTitle:NSLocalizedString(@"Cancel", @"Title of cancel button in start alert of new aiproj")];
}

- (NSData *)dataOfType:(NSString *)typeName error:(NSError **)outError {
    // Insert code here to write your document to data of the specified type. If outError != NULL, ensure that you create and set an appropriate error if you return nil.
    // Alternatively, you could remove this method and override -fileWrapperOfType:error:, -writeToURL:ofType:error:, or -writeToURL:ofType:forSaveOperation:originalContentsURL:error: instead.
    if (outError) {
        *outError = [NSError errorWithDomain:NSOSStatusErrorDomain code:unimpErr userInfo:nil];
    }
    return nil;
}

- (BOOL)writeToURL:(NSURL *)url ofType:(NSString *)typeName error:(NSError * _Nullable __autoreleasing *)outError {
    self.created = NO;
    return [super writeToURL:url ofType:typeName error:outError];
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

+ (BOOL)autosavesInPlace {
    return YES;
}

@end
