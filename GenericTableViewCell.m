//
//  GenericTableViewCell.m
//  NITableGridDemo
//
//  Created by Your Company Name on 25/04/13.
//  Copyright (c) 2015 Your Company Name. All rights reserved.
//

#import "GenericTableViewCell.h"
#import "GenericTableColumn.h"
#import "ThemeManager.h"
#import "Definitions.h"

@implementation GenericTableViewCell

@synthesize columns;
@synthesize labels;
@synthesize cellFontSize;
@synthesize backgrounds;

-(void) setCellFontSize:(CGFloat)size
{
    for (UILabel* columnLabel in labels)
    {
        columnLabel.font = [UIFont systemFontOfSize:size];
    }
}


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier columns:(NSArray*)columnDicts
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) 
    {
        // Initialization code
        UIColor *light = [UIColor colorWithWhite:0.96 alpha:1];
        UIColor *dark = [UIColor colorWithWhite:0.9 alpha:1];
        
        NSUInteger columnHeight = 44;
        NSUInteger labelBuffer = 1;
        
        NSUInteger progress = 0;
        NSUInteger counter = 0;
        
        self.columns = columnDicts;
        self.labels = [NSMutableArray arrayWithCapacity:0];
        self.backgrounds = [NSMutableArray arrayWithCapacity:0];
        
        for (GenericTableColumn* column in columns)
        {
            CGRect columnRect = CGRectMake(progress, 0, [column.width unsignedIntegerValue] + 10 /* add 10 px to compensate for fractions of percentages of width*/, columnHeight);
            CGRect columnTextRect = CGRectMake(progress + labelBuffer, 0, [column.width unsignedIntegerValue]+10, columnHeight);
            
            progress += [column.width unsignedIntegerValue];
         
            UIView* columnBackground = [[UIView alloc] initWithFrame:columnRect];
            
            if (counter % 2 == 0)
            {
                columnBackground.backgroundColor = light;
            }
            else
            {
                columnBackground.backgroundColor = dark;    
            }
            
            columnBackground.alpha = 1;
            [self addSubview:columnBackground];
            [backgrounds addObject:columnBackground];

            UILabel* columnLabel = [[UILabel alloc] initWithFrame:columnTextRect];
            columnLabel.text = column.name;
            columnLabel.backgroundColor = [UIColor clearColor];
            columnLabel.font = [UIFont systemFontOfSize:STDTABLEFONTSIZE];
            columnLabel.adjustsFontSizeToFitWidth = YES;
            columnLabel.textAlignment = column.alignment;
            

            columnLabel.textColor = [g_ThemeManager getCellTextColor];
            [self addSubview:columnLabel];
            [self.labels addObject:columnLabel];
            
            counter++;
        }
    }
        
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



- (void)dealloc
{
    parent = nil;
    self.columns = nil;
    self.labels = nil;
    self.backgrounds = nil;
//    [super dealloc];
}

@end
