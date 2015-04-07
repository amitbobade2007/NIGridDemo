//
//  GenericTableView.h
//  NITableGridDemo
//
//  Created by Your Company Name on 25/04/13.
//  Copyright (c) 2015 Your Company Name. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Definitions.h"
#import "GenericModelClass.h"


@interface GenericButton : UIButton 
{
    NSString* name;
    SortOrder dataSortOrder;
    BOOL isAscending;
    ColumnType columnType;
}

@property (nonatomic, retain) NSString* name;
@property (nonatomic, assign) SortOrder dataSortOrder;
@property (nonatomic, assign) BOOL isAscending;
@property (nonatomic, assign) ColumnType columnType;
@end



@interface GenericTableView : UITableView  <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>
{
    // Include table and the sort button bar at the top.
    // All must be parametrized - cells, table, buttons, sorting, etc..
    
    UIView* buttonBar;
    NSArray* columns;
    NSMutableArray* columnsButtons;
    
    UIView* parentView;
    GenericButton* currentlySortingButton;
    
    NSArray* tableData; 
    NSMutableArray* fitleredData; 
    NSMutableArray* displayedTableData; 
    
    ReportType selfReportType;
    
    CGFloat tableFontSize;
    
    NSArray* categoryDividers;
    NSMutableArray* dataCategories;
    NSString* divider;
    NSString* dividerHeader;
    
    BOOL multiCategory;
    BOOL abnormalMode;
    
    UISearchBar *tableSearchBar;
    NSString* currencyColumnName;
    
    BOOL groupingDisabled;
}

@property (nonatomic, retain) GenericButton* currentlySortingButton;
@property (nonatomic) UIView* parentView;
@property (nonatomic, retain) NSArray* columns;
@property (nonatomic, retain) NSMutableArray* columnsButtons;
@property (nonatomic, retain) NSArray* tableData;
@property (nonatomic, retain) NSMutableArray* fitleredData; 
@property (nonatomic, retain) NSMutableArray* displayedTableData;
@property (nonatomic, assign) ReportType selfReportType;
@property (nonatomic, retain) NSArray* categoryDividers;

@property (nonatomic, retain) NSMutableArray* dataCategories;
@property (nonatomic, retain) NSString* divider;
@property (nonatomic, retain) NSString* currencyColumnName;
@property (nonatomic, retain) NSString* dividerHeader;
@property (nonatomic, assign) BOOL groupingDisabled;

- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style reportType:(ReportType)type parent:(UIView *)parent andObject:(Class)classObject;
-(void) sort:(id)sender;
-(IBAction) exposedSearchService:(UISearchBar *)searchBar;
-(void) applySorting;
-(void) updateData:(NSArray*) data;

@end
