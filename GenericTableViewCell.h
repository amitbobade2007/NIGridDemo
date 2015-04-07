//
//  GenericTableViewCell.h
//  NITableGridDemo
//
//  Created by Your Company Name on 25/04/13.
//  Copyright (c) 2015 Your Company Name. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface GenericTableViewCell : UITableViewCell 
{
    id parent;
    
    NSMutableArray* labels;
    NSMutableArray* backgrounds;
    
    CGFloat cellFontSize;
    
    NSArray* columns;
}


@property (nonatomic, retain) NSArray* columns;
@property (nonatomic, retain) NSMutableArray* labels;
@property (nonatomic, retain) NSMutableArray* backgrounds;
@property (nonatomic, assign) CGFloat cellFontSize;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier columns:(NSArray*)columnDicts;


@end
