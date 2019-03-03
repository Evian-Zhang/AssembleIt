//
//  AICodeViewController.m
//  AssembleIt
//
//  Created by Evian张 on 2019/3/3.
//  Copyright © 2019 Evian张. All rights reserved.
//

#import "AICodeViewController.h"

@interface AICodeViewController ()

enum AICodeTableColumn {
    AICodeTableNumberColumn = 0,
    AICodeTableCodeColumn = 1
};

@end

@implementation AICodeViewController

@synthesize codeTable = _codeTable;

@synthesize codeLines = _codeLines;

- (instancetype)init {
    if (self = [super init]) {
        
        return self;
    }
    return nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.codeTable.delegate = self;
    self.codeTable.dataSource = self;
    self.codeTable.usesAutomaticRowHeights = YES;
    [self updateTable];
}

- (void)updateTable {
    [self.codeTable reloadData];
    
    if (self.codeLines && self.codeLines.count > 0) {
        [self.codeTable.tableColumns[AICodeTableNumberColumn] sizeToFit];
        NSTableCellView *tableCell = [self.codeTable viewAtColumn:AICodeTableNumberColumn row:self.codeTable.numberOfRows - 1 makeIfNecessary:YES];
        CGFloat maxNumberWidth = [tableCell.textField.stringValue sizeWithAttributes:@{NSFontAttributeName: tableCell.textField.font}].width;
        [self.codeTable.tableColumns[AICodeTableNumberColumn] setWidth:maxNumberWidth + 10];
    }
}

#pragma mark - Conform to <NSTableViewDelegate. NSTableViewDataSource>
- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    if (self.codeLines && self.codeLines.count > 0) {
        return self.codeLines.count;
    }
    return 0;
}

- (id)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    if (self.codeLines && self.codeLines.count > 0) {
        NSTableCellView *tableCell;
        if ([tableColumn.identifier isEqualToString:@"AINumberCellIdentifier"]) {
            tableCell = [tableView makeViewWithIdentifier:@"AINumberCellIdentifier" owner:self];
            tableCell.textField.stringValue = [NSString stringWithFormat:@"%ld", (long)row + 1];
            tableCell.textField.alignment = NSTextAlignmentRight;
        } else if ([tableColumn.identifier isEqualToString:@"AICodeCellIdentifier"]) {
            tableCell = [tableView makeViewWithIdentifier:@"AICodeCellIdentifier" owner:self];
            tableCell.textField.stringValue = self.codeLines[row];
            tableCell.textField.lineBreakMode = NSLineBreakByCharWrapping;
            tableCell.textField.usesSingleLineMode = NO;
            tableCell.textField.preferredMaxLayoutWidth = tableCell.textField.frame.size.width;
        }
        return tableCell;
    }
    return nil;
}

- (void)tableView:(NSTableView *)tableView didAddRowView:(NSTableRowView *)rowView forRow:(NSInteger)row {
    NSTableCellView *cellView = [rowView viewAtColumn:AICodeTableCodeColumn];
    [rowView addConstraint:[NSLayoutConstraint constraintWithItem:rowView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:cellView.textField.frame.size.height]];
}

@end
