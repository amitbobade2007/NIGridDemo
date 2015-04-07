//
//  GenericScrollView.m
//  NITableGridDemo
//
//  Created by Your Company Name on 25/04/13.
//  Copyright (c) 2015 Your Company Name. All rights reserved.
//

#import "GenericScrollView.h"
#import "GenericTableView.h"


#define SCROLLVIEWWIDTH  220
#define SCROLLVIEWHEIGHT 230
#define PAGECONTROLMARGIN 20

@implementation GenericScrollView

@synthesize scrollPageControl;
@synthesize graphs;
@synthesize addedViews;



- (void)scrollViewDidScroll:(UIScrollView *)_scrollView
{
    CGFloat pageWidth = _scrollView.frame.size.width;
    int page = floor((_scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    scrollPageControl.currentPage = page;
}


- (id)initWithOrigin:(CGPoint)origin size:(CGSize)size andParentView:(UIView*) view
{
    self = [super init];
    
    if (self) 
    {
        CGFloat scrollWidth, scrollHeight;
        
        if (size.width == 0 || size.height == 0)
        {
            scrollWidth = SCROLLVIEWWIDTH;
            scrollHeight = SCROLLVIEWHEIGHT;
        }
        else
        {
            scrollWidth  = size.width;
            scrollHeight = size.height;
        }
        
        
        self.frame = CGRectMake(origin.x, origin.y, scrollWidth, scrollHeight);
        self.delegate = self;
        [view addSubview:self];
        
        scrollPageControl = [[UIPageControl alloc] init];
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        {
            scrollPageControl.center = CGPointMake(origin.x + scrollWidth/2, origin.y + scrollHeight + PAGECONTROLMARGIN/2);
        }
        else
        {
            scrollPageControl.center = CGPointMake(origin.x + scrollWidth/2, origin.y + scrollHeight + PAGECONTROLMARGIN/2);
        }
        
        [view addSubview:scrollPageControl];
    }

    return self;
}



- (void)dealloc
{
    for (UIView* view in self.subviews)
    {
        [view removeFromSuperview];
    }
    
    self.graphs = nil;
    self.addedViews = nil;
//    [scrollPageControl release];
//    [super dealloc];
}


-(void) adjustPage
{
    NSInteger currentPage = scrollPageControl.currentPage;
    
    if (currentPage >= 0)
    { 
        self.contentOffset = CGPointMake(self.frame.size.width * currentPage, 0);
        
        scrollPageControl.currentPage = currentPage + 1;
        [scrollPageControl updateCurrentPageDisplay];
        
        scrollPageControl.currentPage = currentPage;
        [scrollPageControl updateCurrentPageDisplay];
        
        if (currentPage >= [graphs count])
        {
            scrollPageControl.currentPage = [graphs count] - 1;
            [scrollPageControl updateCurrentPageDisplay];
        }
    }
}


-(void) addView:(UIView*)view
{
    NSMutableArray* newViews = [NSMutableArray arrayWithArray:self.addedViews];
    [newViews addObject:view];
    
    self.addedViews = [NSArray arrayWithArray:newViews];
    
    scrollPageControl.numberOfPages = [self.addedViews count];
    [scrollPageControl updateCurrentPageDisplay];
    
    self.contentSize = CGSizeMake(0, 0);
    [self addSubview:view];
    
    for (UIView* t in addedViews)
    {
        self.contentSize = CGSizeMake(self.contentSize.width + self.frame.size.width, self.contentSize.height);
        self.pagingEnabled = YES;
    }
    
    [self adjustPage];

}



@end
