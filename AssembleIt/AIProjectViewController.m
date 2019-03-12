//
//  AIProjectViewController.m
//  AssembleIt
//
//  Created by Evian张 on 2019/3/4.
//  Copyright © 2019 Evian张. All rights reserved.
//

#import "AIProjectViewController.h"

@interface AIProjectViewController ()

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
    self.navigatorViewController.projectNode = [projectContents valueForKey:@"AIProjectNode"];
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
            NSString *fileContent = [NSString stringWithContentsOfURL:currentFileNode.nodeURL encoding:NSUTF8StringEncoding error:&error];
            self.codeViewController.content = fileContent;
            NSValue *value = [self.projectContents objectForKey:currentFileNode.nodeURL];
            if (!value) {
                
            }
            [self.codeViewController.view setFrame:self.splitView.subviews[CODEVIEW].frame];
            [self.splitView replaceSubview:self.splitView.subviews[CODEVIEW] with:self.codeViewController.view];
            [self.codeViewController updateContent];
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
