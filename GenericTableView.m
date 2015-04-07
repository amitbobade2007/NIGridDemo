//
//  GenericTableView.m
//  NITableGridDemo
//
//  Created by Your Company Name on 25/04/13.
//  Copyright (c) 2015 Your Company Name. All rights reserved.
//

#import "GenericTableView.h"
#import "ThemeManager.h"
#import "GenericTableViewCell.h"
#import "GenericTableColumn.h"
#import "Definitions.h"
#import <objc/runtime.h>

@implementation GenericButton

@synthesize dataSortOrder;
@synthesize isAscending;
@synthesize name;
@synthesize columnType;

-(void) dealloc
{
    self.name = nil;
//    [super dealloc];
}


@end


@implementation GenericTableView

@synthesize columns;
@synthesize parentView;
@synthesize columnsButtons;
@synthesize tableData;
@synthesize displayedTableData;
@synthesize fitleredData;
@synthesize selfReportType;
@synthesize dataCategories;
@synthesize divider;
@synthesize categoryDividers;

@synthesize currencyColumnName;
@synthesize dividerHeader;
@synthesize groupingDisabled;
@synthesize currentlySortingButton;


- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    [self exposedSearchService:searchBar];
}


- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    
    searchBar.text = @"";
    
    [self exposedSearchService:searchBar];
    [self applySorting];
    
}


- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self exposedSearchService:searchBar];
}


-(void) sort:(id)sender
{
    GenericButton* sortButton = (GenericButton*) sender;
    self.currentlySortingButton = sortButton;
    
    sortButton.alpha = 0.45;
    
    if (sortButton.dataSortOrder == Original)
    {
        sortButton.dataSortOrder = Ascending;
        sortButton.isAscending = YES;
        sortButton.backgroundColor = [UIColor yellowColor];
        
        for (GenericButton* button in columnsButtons)
        {
            if (button != sortButton)
            {
                button.dataSortOrder = Original;
                button.isAscending = NO;
                button.backgroundColor = [UIColor clearColor];
            }
        }
    }
    else if (sortButton.dataSortOrder == Ascending)
    {
        sortButton.dataSortOrder = Descending;
        sortButton.isAscending = NO;
        sortButton.backgroundColor = [UIColor redColor];
    }
    else 
    {
        sortButton.dataSortOrder = Original;
        sortButton.backgroundColor = [UIColor clearColor];
    }
    
    [self applySorting];
}




-(void) applySorting
{    
    int (^oneFrom)(int);
    
    oneFrom = ^(int anInt) {
        return anInt - 1;
    };
    
    
    NSComparisonResult (^NSComparator)(id obj1, id obj2);
    
    NSComparator = ^(id obj1, id obj2)
    {
        NSString* first = (NSString*) obj1;
        NSString* second = (NSString*) obj2;
        
        
        double firstNumber = [first doubleValue];
        double secondNumber = [second doubleValue];
        
        if (firstNumber < secondNumber) 
            return NSOrderedAscending;
        else if (firstNumber == secondNumber) 
            return NSOrderedSame;
        
        return NSOrderedDescending;
    };
    

    if (currentlySortingButton.dataSortOrder != Original)
    {
        NSArray *sortDescriptors;
        abnormalMode = YES;
        
        if (currentlySortingButton.columnType == Percentage || currentlySortingButton.columnType == Cash || currentlySortingButton.columnType == Number || currentlySortingButton.columnType == NonFormattedNumber || currentlySortingButton.columnType == Integer)
        {
            sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:currentlySortingButton.name  ascending:currentlySortingButton.isAscending comparator:NSComparator]];    
        }
        else
        {
            sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:currentlySortingButton.name  ascending:currentlySortingButton.isAscending]];    
        }
        
        self.displayedTableData =  (NSMutableArray*)[NSArray arrayWithArray:[self.fitleredData sortedArrayUsingDescriptors: sortDescriptors]];
    }
    else
    {
        if (multiCategory == YES && [self.fitleredData count] == [self.tableData count])
        {
            abnormalMode = NO;
            self.displayedTableData = self.dataCategories;
        }
        else
        {
            abnormalMode = YES;
            self.displayedTableData = (NSMutableArray *)[NSArray arrayWithArray:self.fitleredData];
        }
    }
    
    [self reloadData];
}




//Search logic is depen on your table data. This is just a example.
- (IBAction)exposedSearchService:(UISearchBar *)searchBar
{
    NSString* searchText = searchBar.text;
    tableSearchBar = searchBar;
    
   	if (searchText == nil)
		searchText = @"";
	
	if ([searchText isEqualToString:@""])
	{
        abnormalMode = NO;
        
        if (multiCategory == YES)
        {
            self.displayedTableData =  self.dataCategories;
        }
        else
        {
            self.displayedTableData =  (NSMutableArray *)[NSArray arrayWithArray:self.tableData];
        }
        
        self.fitleredData = [NSMutableArray arrayWithArray:self.tableData];
        [self reloadData];
        [searchBar resignFirstResponder];
		return;
	}
	
	self.fitleredData = [NSMutableArray arrayWithCapacity:0];
    abnormalMode = YES;
	
	for (NSDictionary *row in self.tableData)
	{
        for (GenericTableColumn* column in columns)
        {
            NSString* value = convertField([row objectForKey:column.name]);
            
            NSRange valueRange = [value rangeOfString:searchText options:NSCaseInsensitiveSearch];

            if (valueRange.location != NSNotFound && value != nil)
            {
                [self.fitleredData addObject:row];
                break;
            }
        }
	}
	
    self.displayedTableData = self.fitleredData;
	[self reloadData]; 
    [searchBar resignFirstResponder];
}




-(void) updateData:(NSArray*) datas
{
    
    //convert objects properties and values into dictionary
    NSMutableArray *data = [NSMutableArray arrayWithCapacity:0];
    for (GenericModelClass *a in datas) {
        [data addObject:[a allPropertyNamesAndValues]];
    }
    
    self.tableData = nil;    
    self.displayedTableData = nil;
    self.fitleredData = nil;
    
    self.tableData = data;    
    self.displayedTableData = [NSMutableArray arrayWithArray:data];
    self.fitleredData = self.displayedTableData;

    
    NSMutableSet* categoryDividersSet = [NSMutableSet setWithCapacity:0];
    
    for (NSDictionary* dict in tableData)
    {
        NSString* dividerObject = [dict objectForKey:self.divider];
        
        
        if (dividerObject)
        {
            [categoryDividersSet addObject:@"Grouping Is Available"];
        }
        else
        {
            [categoryDividersSet addObject:@"Grouping Not Available"];
        }
    }
    
    if ([categoryDividersSet count] > 0 && groupingDisabled == NO)
    {
        self.dataCategories = [NSMutableArray arrayWithCapacity:0];
        self.categoryDividers = [categoryDividersSet allObjects];
        self.categoryDividers =  [NSArray arrayWithArray:[categoryDividers sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)]];
                
        multiCategory = YES;
        
        for (NSString* dividerObject in categoryDividers)
        {
//            dividerObject = @"Grouping Not Available";//convertField(dividerObject);
            
            NSMutableArray* rowsInThisCategories = [NSMutableArray arrayWithCapacity:0];
            
            for (NSDictionary* dict in tableData)
            {
                NSString* value = [dict objectForKey:self.divider];
                
                if (value == nil)
                {
                    if ([dividerObject isEqualToString:@"Grouping Not Available"])
                    {
                        [rowsInThisCategories addObject:dict];
                    }
                }
                else
                {
                    if ([dividerObject isEqualToString:value])
                    {
                        [rowsInThisCategories addObject:dict];
                    }
                    
                }
            }
            
            [self.dataCategories addObject:rowsInThisCategories];
        }
        
        self.displayedTableData = self.dataCategories;
    }
    else
    {
        self.dataCategories = nil;
    }
    
    
    if (abnormalMode == YES)
    {
        if (tableSearchBar != nil)
        {
            [self exposedSearchService:tableSearchBar];
        }
        
        if (currentlySortingButton != nil)
        {
            [self applySorting];
        }
    }
    
//    if ([self.hostingGenericViewController respondsToSelector:@selector(calculateTotals:)])
//    {
//        [self.hostingGenericViewController performSelector:@selector(calculateTotals:) withObject:self.fitleredData];
//    }
    
    [self reloadData];
}





- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
    if (multiCategory == YES && abnormalMode == NO)
    {
        return [displayedTableData count]; 
    }
    
    return 1;
}




- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
    if (multiCategory == YES && abnormalMode == NO)
    {
        return [[displayedTableData objectAtIndex:section] count];
    }
    
    return [self.displayedTableData count];
}



- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{  
    if ([self.dividerHeader isEqualToString:@"isSections"])
    {
        return [NSString stringWithFormat:@"%@ - %li", @"TestSection", (long)section];

    }
    return nil;
}





- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellsIdentifier = @"GenericCell";
    GenericTableViewCell *cell = (GenericTableViewCell*) [tableView dequeueReusableCellWithIdentifier:cellsIdentifier];
	
    if (cell == nil) 
	{
		cell = [[GenericTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellsIdentifier columns:self.columns];
        cell.cellFontSize = tableFontSize;
    }
    
    for (int i = 0; i < [self.columns count]; i++)
    {
        UILabel* label = [cell.labels objectAtIndex:i];
        GenericTableColumn* column = [columns objectAtIndex:i];  
        
        NSDictionary* rowDict;

        rowDict = [displayedTableData objectAtIndex:indexPath.row];

        
        NSString* value = convertField([rowDict  objectForKey:column.name]);
                
        switch (column.columnType) 
        {
            case Date:
                value = @""; //put your logic to convert data into respected format
                break;
                
            case Cash:
                value = @""; //put your logic to convert data into respected format
                break;
                
            case Percentage:
               value = @""; //put your logic to convert data into respected format
                break;
                
            case Number:
               value = @""; //put your logic to convert data into respected format
                break;
                
            case Integer:
                value = @""; //put your logic to convert data into respected format
                break;
               
            case NonFormattedNumber:
                value = value;
                break;
                
            case Portfolio:
                value = @"Consolidated";
                break;
            case String:
                value = value;
                break;
            case Text:
                value = value;
                break;
                
            default:
                break;
        }
        
        label.text = value;
    }
    
    return cell;
}




- (void)dealloc
{
    self.currentlySortingButton = nil;
    self.parentView = nil;
    self.columns = nil;
    self.columnsButtons = nil;
    self.fitleredData = nil;
    self.displayedTableData = nil;
    self.categoryDividers = nil;
    self.dataCategories = nil;
    self.divider = nil;
    self.currencyColumnName = nil;
    self.dividerHeader = nil;
    
    self.tableData = nil;
    
}




- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style reportType:(ReportType)type parent:(UIView *)parent andObject:(Class) classObject
{
    NSUInteger buttonBarHeight = GENERICTABLEBUTTONBARHEIGHT;
    
    CGRect buttonBarRect = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, buttonBarHeight);
    CGRect tableRect = CGRectMake(frame.origin.x, frame.origin.y + buttonBarHeight, frame.size.width, frame.size.height - buttonBarHeight);
    
    self = [super initWithFrame:tableRect style:style];

    /////// Start Initialization here
    self.delegate = self;
    self.dataSource = self;
    
    self.parentView = parent;
    self.selfReportType = type;
    
    self.backgroundColor = [g_ThemeManager getThemeColor];

    buttonBar = [[UIView alloc] initWithFrame:buttonBarRect];
    buttonBar.backgroundColor = [g_ThemeManager getTableButtonBarColor];
    [parentView addSubview:buttonBar];
    
    //get columns for different object on rutime.
    SEL selector = NSSelectorFromString(@"getClassColumns");
    IMP imp = [classObject methodForSelector:selector];
    NSArray* (*func)(id, SEL) = (void *)imp;
    NSArray *result = func(classObject, selector);
    
    self.columns = result;
    tableFontSize = FULLTABLEFONTSIZE;
    
    NSUInteger progress = 0;
    NSUInteger counter = 0;
    
    self.separatorColor = [g_ThemeManager getThemeColor];
    
    self.columnsButtons = [NSMutableArray arrayWithCapacity:0];
    
    for (GenericTableColumn* column in columns)
    {
        CGRect columnRect = CGRectMake(progress, 0, [column.width unsignedIntegerValue], buttonBarHeight);
        progress += [column.width unsignedIntegerValue];
        
        UILabel* columnLabel = [[UILabel alloc] initWithFrame:columnRect];
        columnLabel.text = column.header;
        columnLabel.backgroundColor = [UIColor clearColor];
        columnLabel.lineBreakMode = NSLineBreakByWordWrapping;
        columnLabel.font = [UIFont boldSystemFontOfSize:STDTABLEFONTSIZE];
        columnLabel.adjustsFontSizeToFitWidth = YES;
        columnLabel.numberOfLines = 2;
        columnLabel.textAlignment = NSTextAlignmentCenter;
        columnLabel.textColor = [g_ThemeManager getButtonBarTextColor];
        [buttonBar addSubview:columnLabel];

        GenericButton* sortColumnButton = [GenericButton buttonWithType:UIButtonTypeCustom];
        sortColumnButton.frame = columnRect;
        [buttonBar addSubview:sortColumnButton];
        [sortColumnButton addTarget:self action:@selector(sort:) forControlEvents:UIControlEventTouchUpInside];
        sortColumnButton.tag = counter;
        sortColumnButton.dataSortOrder = Original;
        sortColumnButton.name = column.name;
        sortColumnButton.columnType = column.columnType;
        [columnsButtons addObject:sortColumnButton];
        
        self.backgroundColor = [UIColor clearColor];
        self.separatorColor = [UIColor clearColor];
        
        counter++;
    }
    
    classObject = nil;
        
    return self;
}



@end
