//
//  PDFCreator.m
//  NIGridDemo
//
//  Created by Your Company Name.
//  Copyright (c) 2015 Your Company Name. All rights reserved.
//

#import "PDFCreator.h"
#import "GenericTableColumn.h"
#import "GenericModelClass.h"
#import "ThemeManager.h"

#define A4_HEIGHT 842
#define A4_WIDTH 595
#define REPORT_HEADER_HEIGHT 780
#define ROW_HEIGHT 22
#define CONTENT_MARGIN 50
#define TABLE_MARGIN 5
#define REPORT_FONT_SIZE 7



@implementation PDFCreator


@synthesize reportType;
@synthesize columns;
@synthesize pdfContext;
@synthesize values;
@synthesize graphs;
@synthesize pdfFilePath;
@synthesize reportDate;
@synthesize fromDate, toDate;
@synthesize performanceData;


-(void)getColumns:(Class)tempClass
{
    //get columns for different object on rutime.
    SEL selector = NSSelectorFromString(@"getClassColumns");
    IMP imp = [tempClass methodForSelector:selector];
    NSArray* (*func)(id, SEL) = (void *)imp;
    columns = func(tempClass, selector);
    //////
}


-(void) dealloc
{
    self.columns = nil;
    self.values = nil;
    self.graphs = nil;
    self.pdfFilePath = nil;
    self.reportDate = nil;
    self.fromDate = nil;
    self.toDate = nil;
    self.performanceData = nil;
    

}

-(void)setValues:(NSArray *)tempValues
{
    //convert objects properties and values into dictionary
    NSMutableArray *data = [NSMutableArray arrayWithCapacity:0];
    for (GenericModelClass *a in tempValues) {
        [data addObject:[a allPropertyNamesAndValues]];
    }
    values = data;
}


-(void) getPDFAndSaveWithName:(NSString*) name
{
    [self createPDF:name];
    lastYPos = REPORT_HEADER_HEIGHT;
    if ([self.values count] > 0)
    {
//        [self writeHeader];
        [self drawTable];
    }
    
    lastYPos -= 20;
    
    [self finalizePDF];
}


-(void) drawTable
{
    CGFloat ypos = lastYPos;
    
    [self fillWithGradient];
    
    NSUInteger columnsWidth = 0;
    
    for (GenericTableColumn* column in columns)
    {
        columnsWidth += [column.width unsignedIntegerValue];
    }
    
    
    CGFloat columnMultiplier = ((CGFloat)A4_WIDTH - 2 * (CGFloat)CONTENT_MARGIN) / columnsWidth;
                                               
    CGContextSelectFont (pdfContext, "Helvetica", REPORT_FONT_SIZE, kCGEncodingMacRoman);
    
    CGContextSetTextDrawingMode (pdfContext, kCGTextFill);
    [[UIColor whiteColor] getRed:&redText green:&greenText blue:&blueText alpha:&alphaText];
    CGContextSetRGBFillColor (pdfContext, redText, greenText, blueText, 1);
    
   // CGContextStrokeRect(pdfContext, CGRectMake(CONTENT_MARGIN, ypos - ROW_HEIGHT/2 , pageRect.size.width - 2*CONTENT_MARGIN, ROW_HEIGHT));
    
    CGFloat x = CONTENT_MARGIN + TABLE_MARGIN;

    for (GenericTableColumn* column in columns)
    {
        const char* columnName = [column.header cStringUsingEncoding:NSUTF8StringEncoding];
        CGContextShowTextAtPoint (pdfContext, x, ypos, columnName, strlen(columnName));
         x += [column.width floatValue] * columnMultiplier;
    }
   
    
    ypos -= ROW_HEIGHT;
    lastYPos = ypos;
    
    for (int i = 0; i < [values count]; i++)
    {
        NSDictionary* dict = [values objectAtIndex:i];
        
        if (ypos - i * ROW_HEIGHT - ROW_HEIGHT/2 < CONTENT_MARGIN)
        {
            CGContextEndPage (pdfContext);
            CGContextBeginPage (pdfContext, &pageRect);
            
            ypos = A4_HEIGHT - 2 * CONTENT_MARGIN + i * ROW_HEIGHT;
            
            CGContextSelectFont (pdfContext, "Helvetica", REPORT_FONT_SIZE, kCGEncodingMacRoman);
            CGContextSetTextDrawingMode (pdfContext, kCGTextFill);
            CGContextSetRGBFillColor (pdfContext, 1, 1, 1, 1);
        }
        
        
        CGFloat x = CONTENT_MARGIN + TABLE_MARGIN;
        NSUInteger count = 0;
        
        for (GenericTableColumn* column in columns)
        {

            CGContextSaveGState(pdfContext);
            
           // float red, green, blue, alpha;
            
            if (i % 2 == 0)
            {
                [[UIColor lightGrayColor] getRed:&red green:&green blue:&blue alpha:&alpha];
                [[UIColor blackColor] getRed:&redText green:&greenText blue:&blueText alpha:&alphaText];
                //CGContextSetRGBFillColor(pdfContext, 0.8, 0.8, 0.8, 1);
                CGContextSetRGBFillColor(pdfContext, red, green, blue, 1);
            }
            else 
            {
                [[UIColor darkGrayColor] getRed:&red green:&green blue:&blue alpha:&alpha];
                [[UIColor blackColor] getRed:&redText green:&greenText blue:&blueText alpha:&alphaText];
               // CGContextSetRGBFillColor(pdfContext, 0.9, 0.9, 0.9, 1);
                CGContextSetRGBFillColor(pdfContext, red, green, blue, 1);
            }
            
            CGRect myrect =  CGRectMake(x - TABLE_MARGIN, ypos - i * ROW_HEIGHT - ROW_HEIGHT/2, ceilf([column.width floatValue] * columnMultiplier), ROW_HEIGHT);
            
            CGContextClipToRect(pdfContext, myrect);
            CGContextFillRect(pdfContext, myrect);
            CGContextRestoreGState(pdfContext);
            
            NSString* value = convertField([dict objectForKey:column.name]);

            switch (column.columnType) 
            {
                case Date:
                    value = value;
                    break;
                    
                case Cash:
                    value = value;
                    break;
                    
                case Percentage:
                    value = value;
                    break;

                    
                default:
                    break;
            }
            [self writeText:value atPosition:CGPointMake(x, ypos - i * ROW_HEIGHT) font:0];
            x += [column.width floatValue] * columnMultiplier;
            
            count++;
        }
        
      //  CGContextStrokeRect(pdfContext, CGRectMake(CONTENT_MARGIN, ypos - i * ROW_HEIGHT - ROW_HEIGHT/2, pageRect.size.width - 2*CONTENT_MARGIN, ROW_HEIGHT));
        
        lastYPos = ypos - i * ROW_HEIGHT;
    }
}




-(void) fillWithGradient 
{
    [[g_ThemeManager getTableButtonBarColor] getRed:&red green:&green blue:&blue alpha:&alpha];
    CGContextSetRGBFillColor(pdfContext, red, green, blue, 1);
    
    CGRect myrect =  CGRectMake(CONTENT_MARGIN, lastYPos - ROW_HEIGHT/2, pageRect.size.width - 2*CONTENT_MARGIN, ROW_HEIGHT);
    CGContextSaveGState(pdfContext);
    CGContextSelectFont (pdfContext, "Helvetica", REPORT_FONT_SIZE, kCGEncodingMacRoman);
    CGContextClipToRect(pdfContext, myrect);
    CGContextFillRect(pdfContext, myrect);
    CGContextRestoreGState(pdfContext);   
}



-(void) createPDF:(NSString*) name
{
    self.pdfFilePath = [self createPdfFile:name reportType:reportType];
    
    NSDictionary* pdfCreationDictionary =  [NSDictionary dictionaryWithObjectsAndKeys:@"Client PDF", kCGPDFContextTitle, kCGPDFContextCreator, @"Client", nil];
	CFStringRef path = CFStringCreateWithCString (NULL, [pdfFilePath cStringUsingEncoding:NSUTF8StringEncoding], kCFStringEncodingUTF8);
    CFURLRef url = CFURLCreateWithFileSystemPath (NULL, path, kCFURLPOSIXPathStyle, 0);
    
    pageRect = CGRectMake(0, 0, A4_WIDTH, A4_HEIGHT );
    pdfContext = CGPDFContextCreateWithURL (url, &pageRect, (CFDictionaryRef)pdfCreationDictionary);
	CGContextBeginPage (pdfContext, &pageRect);
    
    CFRelease(path);
    CFRelease(url);
}

-(NSString*) createPdfFile:(NSString*)name reportType:(ReportType)treportType
{
    //http://developer.apple.com/library/mac/#documentation/GraphicsImaging/Conceptual/drawingwithquartz2d/dq_pdf_scan/dq_pdf_scan.html
    
    
    NSString* tpdfFilePath;
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    if (name != nil && ![name isEqualToString:@""])
    {
        tpdfFilePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.pdf", name]];
    }
    else
    {
        NSString* reportName = [NSString stringWithCString:reportNames[treportType] encoding:NSUTF8StringEncoding];
        tpdfFilePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.pdf", reportName]];
    }
    
    
    NSInteger count = 0;
    NSString *filename = tpdfFilePath;
    
    while (count < NSIntegerMax)
    {
        if ([[NSFileManager defaultManager] fileExistsAtPath:filename])
        {
            filename = [NSString stringWithFormat:@"%@%li.pdf", [tpdfFilePath stringByDeletingPathExtension], (long)count];
        }
        else
        {
            break;
        }
        
        count++;
    }
    
    pdfFilePath = filename;
    
    //NSLog(@"%i Path: %@", NSIntegerMax, pdfFilePath);
    
    return  pdfFilePath;
}


-(void) writeTextCenter:(NSString*)textString withFontSize:(CGFloat)size
{
    const char *text = [textString cStringUsingEncoding:NSUTF8StringEncoding];
    
    CGContextSelectFont (pdfContext, "Helvetica", size, kCGEncodingMacRoman);
    CGContextSetTextDrawingMode(pdfContext, kCGTextInvisible);
    CGContextShowTextAtPoint(pdfContext, 0, 0, text, strlen(text));
    CGPoint pt = CGContextGetTextPosition(pdfContext);
    CGContextSetTextDrawingMode(pdfContext, kCGTextFill);
	CGContextSetRGBFillColor (pdfContext, redText, greenText, blueText, 1);
    
    CGContextShowTextAtPoint (pdfContext, (A4_WIDTH - pt.x)/2, lastYPos, text, strlen(text));
    
    lastYPos -= ROW_HEIGHT;
}



-(void) writeHeader
{
    CGContextSelectFont (pdfContext, "Helvetica", 16, kCGEncodingMacRoman);
	CGContextSetTextDrawingMode (pdfContext, kCGTextFill);
   // CGFloat red, green, blue, alpha;
   // [[g_ThemeManager getButtonBarTextColor] getRed:&redText green:&greenText blue:&blueText alpha:&alphaText];
    CGContextSetRGBFillColor (pdfContext, 0, 0, 0, 1);
    
    
    [self writeTextCenter:[NSString stringWithFormat:@"%@ - %@", [NSString stringWithCString:reportNames[reportType] encoding:NSUTF8StringEncoding], @"$"]  withFontSize:16];
//    [self writeTextCenter:[NSString stringWithFormat:@"Portfolio %@", g_PortfolioManager.currentPortfolioCodes] withFontSize:14];
    
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
//    [dateFormatter release];
    
//    if (reportDate != nil)
//    {
//        [self writeTextCenter:reportDate withFontSize:12];
//    }
//    else
//    {
        [self writeTextCenter:[NSString stringWithFormat:@"Test Report"] withFontSize:12];
//    }
    
    
    lastYPos -= ROW_HEIGHT;
    
}



-(void) writeText:(NSString*)textString atPosition:(CGPoint)origin font:(NSInteger)font
{
    const char *text = [textString UTF8String];
    
    if (text != nil)
    {
        if (font == 0)
        {
            CGContextSelectFont (pdfContext, "Helvetica", REPORT_FONT_SIZE, kCGEncodingMacRoman);
        }
        else
        {
            CGContextSelectFont (pdfContext, "Helvetica", font, kCGEncodingMacRoman);
        }
        
        CGContextSetTextDrawingMode (pdfContext, kCGTextFill);
        CGContextSetRGBFillColor (pdfContext, redText, greenText, blueText, 1);
        CGContextShowTextAtPoint (pdfContext, origin.x, origin.y, text, strlen(text));
    }
}



-(void) writeTextAndReturn:(NSString*)textString secondString:(NSString*)numberString
{
    [self writeText:textString atPosition:CGPointMake(CONTENT_MARGIN, lastYPos) font:12];
    [self writeText:numberString atPosition:CGPointMake(CONTENT_MARGIN + 200, lastYPos) font:12];
    lastYPos -= ROW_HEIGHT;
}

-(void) finalizePDF
{
    CGContextEndPage (pdfContext);
	CGContextRelease (pdfContext);
}




@end
