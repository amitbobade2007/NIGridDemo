//
//  ViewController.m
//  NIGridDemo
//
//  Created by Your Company Name.
//  Copyright (c) 2015 Your Company Name. All rights reserved.
//

#import "ViewController.h"
#import "PDFViewController.h"
#import "objects.h"
#import "PDFCreator.h"

@interface ViewController ()
{
    objects *a1;
}
@end

@implementation ViewController

#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(FULLWIDTH - 220, 0, 200, 30)];
    searchBar.showsCancelButton = YES;
    UIBarButtonItem *barSearchButton = [[UIBarButtonItem alloc]initWithCustomView:searchBar];
    self.navigationItem.rightBarButtonItem = barSearchButton;
    
    GenericScrollView* journalScrollView = [[GenericScrollView alloc] initWithOrigin:CGPointMake(self.view.bounds.origin.x, 64)  size:CGSizeMake(self.view.bounds.size.width, self.view.bounds.size.height) andParentView:self.view];
    [self.view addSubview:journalScrollView];
    
    GenericTableView* journalTable = [[GenericTableView alloc] initWithFrame:CGRectMake(0, 0, FULLWIDTH, 400) style:UITableViewStylePlain reportType:DemoTable parent:journalScrollView andObject:[objects class]];
    //    journalTable.delegate = self;
    journalTable.groupingDisabled = YES;
    journalTable.rowHeight = 50;
    [journalScrollView addView:journalTable];
    
    searchBar.delegate = journalTable;
    
    a1 = [[objects alloc]init];
    a1.subject = @"SAME";
    a1.description = @"DDESDDD";
    
    [journalTable updateData:@[a1]];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIStoryBoard Segue
-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    PDFViewController *pdfViewController = (PDFViewController*)segue.destinationViewController;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    pdfViewController.fileUrl = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.pdf", @"Test"]];
}

#pragma mark - Instance methods

-(IBAction) createPDF
{
    PDFCreator* pdfCreator = [[PDFCreator alloc] init];
    [pdfCreator getColumns:[objects class]];
    pdfCreator.values = @[a1];
    pdfCreator.reportType = DemoTable;
    [pdfCreator getPDFAndSaveWithName:@"Test"];
}




@end
