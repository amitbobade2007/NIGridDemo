//
//  GenericScrollView.h
//  NITableGridDemo
//
//  Created by Your Company Name on 25/04/13.
//  Copyright (c) 2015 Your Company Name. All rights reserved.
//

#import <Foundation/Foundation.h>


@class GenericTableView;

@interface GenericScrollView : UIScrollView <UIScrollViewDelegate>
{
    UIPageControl* scrollPageControl;
    NSArray* graphs;
    NSArray* addedViews;
}




@property (nonatomic, retain) UIPageControl* scrollPageControl;
@property (nonatomic, retain) NSArray* graphs;
@property (nonatomic, retain) NSArray* addedViews;


-(void) addView:(UIView*)table;
- (id)initWithOrigin:(CGPoint)origin size:(CGSize)size andParentView:(UIView*) view;
-(void) adjustPage;

@end
