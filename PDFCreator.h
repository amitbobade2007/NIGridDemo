//
//  PDFCreator.h
//  NIGridDemo
//
//  Created by Your Company Name.
//  Copyright (c) 2015 Your Company Name. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Definitions.h"


@interface PDFCreator : NSObject 
{
    ReportType reportType;
    NSArray* columns;
    NSArray* values;
    CGFloat lastYPos;
    CGRect pageRect;
    CGContextRef pdfContext;
    
    NSString* pdfFilePath;
    
    NSDictionary* performanceData;
    
    NSDate* reportDate;
    NSDate* fromDate;
    NSDate* toDate;
    CGFloat red, green, blue, alpha;
    CGFloat redText, greenText, blueText, alphaText;
}

@property (nonatomic, assign)   CGContextRef pdfContext;
@property (nonatomic, assign)   ReportType reportType;
@property (nonatomic, retain)   NSArray* columns;
@property (nonatomic, retain)   NSArray* values;
@property (nonatomic, retain)   NSArray* graphs;
@property (nonatomic, retain)   NSString* pdfFilePath;

@property (nonatomic, retain)   NSDate* reportDate;
@property (nonatomic, retain)   NSDate* fromDate;
@property (nonatomic, retain)   NSDate* toDate;

@property (nonatomic, retain)   NSDictionary* performanceData;

-(void) fillWithGradient;
-(void) drawTable;
-(void) createPDF:(NSString*)name;
-(void) finalizePDF;
-(void) writeHeader;
-(void) getPDFAndSaveWithName:(NSString*) name;
-(void) writeTextCenter:(NSString*)textString withFontSize:(CGFloat)size;
-(void) writeText:(NSString*)textString atPosition:(CGPoint)origin font:(NSInteger)font;

-(void)getColumns:(Class)tempClass;

@end
