//
//  Document.m
//  AssembleIt
//
//  Created by Evian张 on 2019/3/3.
//  Copyright © 2019 Evian张. All rights reserved.
//

#import "Document.h"

@interface Document ()

@end

@implementation Document

@synthesize codeViewController = _codeViewController;
@synthesize codeViewController2 = _codeViewController2;

@synthesize codeContent = _codeContent;
@synthesize codeLines = _codeLines;

- (instancetype)init {
    self = [super init];
    if (self) {
        // Add your subclass-specific initialization here.
    }
    return self;
}

- (void)windowControllerDidLoadNib:(NSWindowController *)windowController {
//    self.codeViewController = [[AICodeViewController alloc] initWithNibName:@"AICodeViewController" bundle:nil];
//    self.codeViewController.codeLines = [self.codeLines mutableCopy];
//    windowController.window.contentViewController = self.codeViewController;
    
    self.codeViewController2 = [[AICodeViewController2 alloc] initWithNibName:@"AICodeViewController2" bundle:nil];
    self.codeViewController2.content = self.codeContent;
    windowController.window.contentViewController = self.codeViewController2;
}

+ (BOOL)autosavesInPlace {
    return YES;
}


- (NSString *)windowNibName {
    // Override returning the nib file name of the document
    // If you need to use a subclass of NSWindowController or if your document supports multiple NSWindowControllers, you should remove this method and override -makeWindowControllers instead.
    return @"Document";
}


- (NSData *)dataOfType:(NSString *)typeName error:(NSError **)outError {
    // Insert code here to write your document to data of the specified type. If outError != NULL, ensure that you create and set an appropriate error if you return nil.
    // Alternatively, you could remove this method and override -fileWrapperOfType:error:, -writeToURL:ofType:error:, or -writeToURL:ofType:forSaveOperation:originalContentsURL:error: instead.
    NSData *data = [self.codeViewController2.codeView.textStorage.string dataUsingEncoding:NSUTF8StringEncoding];
    return data;
}


- (BOOL)readFromData:(NSData *)data ofType:(NSString *)typeName error:(NSError **)outError {
    // Insert code here to read your document from the given data of the specified type. If outError != NULL, ensure that you create and set an appropriate error if you return NO.
    // Alternatively, you could remove this method and override -readFromFileWrapper:ofType:error: or -readFromURL:ofType:error: instead.
    // If you do, you should also override -isEntireFileLoaded to return NO if the contents are lazily loaded.
//    if ([typeName isEqualToString:@"DocumentType"]) {
//        NSString *content = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//        NSArray<NSString*> *codeLines = [content componentsSeparatedByString:@"\n"];
//        self.codeLines = codeLines;
//    }
    if ([typeName isEqualToString:@"DocumentType"]) {
        self.codeContent = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    }
    return YES;
}

- (BOOL)writeToURL:(NSURL *)url ofType:(NSString *)typeName error:(NSError * _Nullable __autoreleasing *)outError {
    return [self.codeViewController2.codeView.textStorage.string writeToURL:url atomically:YES encoding:NSUTF8StringEncoding error:outError];
}

@end
