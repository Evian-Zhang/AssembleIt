//
//  AIProjectWindowController.m
//  AssembleIt
//
//  Created by Evian张 on 2019/3/5.
//  Copyright © 2019 Evian张. All rights reserved.
//

#import "AIProjectWindowController.h"

@interface AIProjectWindowController ()

@end

@implementation AIProjectWindowController

@synthesize projectViewController = _projectViewController;

- (void)windowDidLoad {
    [super windowDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(windowDidAppear) name:@"AIProjectViewDidAppear" object:nil];
    
    self.projectViewController = [[AIProjectViewController alloc] initWithNibName:@"AIProjectViewController" bundle:nil];
    self.contentViewController = self.projectViewController;
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}

- (void)displayStartWindow {
    AIProjectStartViewController *startViewController = self.projectViewController.startViewController;
    [self.contentViewController presentViewControllerAsSheet:startViewController];
//    NSRect windowRect = self.window.frame;
//    NSRect startWindowRect = startViewController.view.frame;
//
//    NSPoint pos;
//    pos.x = windowRect.origin.x + windowRect.size.width / 2 - startWindowRect.size.width / 2;
//    pos.y = windowRect.origin.y + self.window.contentView.frame.size.height - startWindowRect.size.height;
//    [startViewController.view setFrameOrigin:pos];
//    startViewController.view.layer.backgroundColor = CFBridgingRetain([NSColor whiteColor]);
//    [startViewController.view display];
//    [startWindow beginSheet:self.window completionHandler:^(NSModalResponse returnCode) {
//
//    }];
//    [NSApp runModalForWindow:startWindow];
//    [self.contentViewController presentViewControllerAsSheet:startWindow.contentViewController];
}

- (NSRect)window:(NSWindow *)window willPositionSheet:(NSWindow *)sheet usingRect:(NSRect)rect {
    return NSMakeRect(0, 0, 100, 100);
}

- (void)windowDidAppear {
    self.window.delegate = self.document;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"AIProjectWindowSetUpComplete" object:nil];
}

@end
