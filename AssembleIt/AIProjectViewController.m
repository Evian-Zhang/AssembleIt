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
@synthesize fileInfos = _fileInfos;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    self.startViewController = [[AIProjectStartViewController alloc] initWithNibName:@"AIProjectStartViewController" bundle:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleFileTableSelectionDidChangeNotification:) name:@"AIFileTableSelectionDidChangeNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleAICodeViewTextDidChangeNotification) name:@"AICodeViewTextDidChange" object:nil];
}

- (void)viewDidAppear {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"AIProjectViewDidAppear" object:self];
}

- (void)buildViewWithProjectContents:(NSMutableDictionary *)projectContents fileInfo:(NSMutableDictionary<NSURL *, NSMutableDictionary *> *)fileInfos {
    self.projectContents = projectContents;
    self.fileInfos = fileInfos;
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
            NSMutableDictionary *fileInfoDict = [self.fileInfos objectForKey:currentFileNode.nodeURL];
            NSString *fileContent;
            if (fileInfoDict) {
                fileContent = [fileInfoDict objectForKey:@"fileContent"];
            } else {
                fileInfoDict = [NSMutableDictionary dictionary];
                [self.fileInfos setObject:fileInfoDict forKey:currentFileNode.nodeURL];
                [fileInfoDict setObject:[NSNumber numberWithBool:NO] forKey:@"hasChanged"];
                fileContent = [NSString stringWithContentsOfURL:currentFileNode.nodeURL encoding:NSUTF8StringEncoding error:&error];
                [fileInfoDict setObject:fileContent forKey:@"fileContent"];
            }
            self.codeViewController.content = fileContent;
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

- (void)handleAICodeViewTextDidChangeNotification {
    NSURL *fileURL = self.navigatorViewController.currentFileNode.nodeURL;
    NSMutableDictionary *fileInfoDict = [self.fileInfos objectForKey:fileURL];
    [fileInfoDict setObject:[NSNumber numberWithBool:YES] forKey:@"hasChanged"];
    [fileInfoDict setObject:[self.codeViewController.codeView.string copy] forKey:@"fileContent"];
}


@end
