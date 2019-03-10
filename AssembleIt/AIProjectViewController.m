//
//  AIProjectViewController.m
//  AssembleIt
//
//  Created by Evian张 on 2019/3/4.
//  Copyright © 2019 Evian张. All rights reserved.
//

#import "AIProjectViewController.h"

@interface AIProjectViewController ()

typedef enum AISplitViewIndex {
    NAVIGATORVIEW = 0,
    CODEVIEW,
} AISplitViewIndex;

@end

@implementation AIProjectViewController

@synthesize navigatorViewController = _navigatorViewController;
@synthesize codeViewController = _codeViewController;
@synthesize startViewController = _startViewController;
@synthesize projectContents = _projectContents;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    self.startViewController = [[AIProjectStartViewController alloc] initWithNibName:@"AIProjectStartViewController" bundle:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleFileTableSelectionDidChangeNotification:) name:@"AIFileTableSelectionDidChangeNotification" object:nil];
}

- (void)viewDidAppear {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"AIProjectViewDidAppear" object:self];
}

- (void)buildViewWithProjectContents:(NSMutableDictionary *)projectContents {
    self.navigatorViewController = [[AINavigatorViewController alloc] initWithNibName:@"AINavigatorViewController" bundle:nil];
    self.navigatorViewController.root = [projectContents valueForKey:@"AIFileTree"];
    self.navigatorViewController.fileNodes = [projectContents valueForKey:@"AIFileNodes"];
    [self.splitView addArrangedSubview:self.navigatorViewController.view];
    
    
    self.codeViewController = [[AICodeViewController2 alloc] initWithNibName:@"AICodeViewController2" bundle:nil];
    self.codeViewController.content = [NSString string];
    [self.splitView addArrangedSubview:self.codeViewController.view];
}

- (void)handleFileTableSelectionDidChangeNotification:(NSNotification *)aNotification {
    NSDictionary *userInfo = aNotification.userInfo;
    AIFileNode *currentFileNode = [userInfo valueForKey:@"currentFileNode"];
    switch (currentFileNode.fileNodeType) {
        case AIFileNodeProjectType:
            break;
            
        case AIFileNodeASMType:
        {
            NSError *error;
            self.codeViewController.content = [NSString stringWithContentsOfURL:currentFileNode.nodeURL encoding:NSUTF8StringEncoding error:&error];
            [self.splitView removeArrangedSubview:self.splitView.arrangedSubviews[CODEVIEW]];
            [self.splitView insertArrangedSubview:self.codeViewController.view atIndex:CODEVIEW];
            if (error) {
                NSLog(@"%@", error);
            }
        }
            break;
            
        case AIFileNodeFolderType:
            break;
    }
}

@end
