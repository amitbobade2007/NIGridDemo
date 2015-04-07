//
//  PDFViewController.m
//  NIGridDemo
//
//  Created by Amit Bobade on 07/04/15.
//  Copyright (c) 2015 Amit Bobade. All rights reserved.
//

#import "PDFViewController.h"

@interface PDFViewController ()
{
    
    IBOutlet UIWebView *pdfWebView;
}

@end

@implementation PDFViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.fileUrl]];
    [pdfWebView loadRequest:request];
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
