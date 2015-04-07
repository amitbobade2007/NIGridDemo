//
//  Definitions.h
//  NITableGridDemo
//
//  Created by Your Company Name on 25/04/13.
//  Copyright (c) 2015 Your Company Name. All rights reserved.
//


#define VERBOSEOUTPUT 0

#define FULLWIDTH [UIScreen mainScreen].bounds.size.width
#define FULLHEIGHT [UIScreen mainScreen].bounds.size.height

#define STDTABLEFONTSIZE 11
#define FULLTABLEFONTSIZE 14

#define GENERICTABLEBUTTONBARHEIGHT 35


static NSString* transportProtocolPrefix = @"https://";
static NSString* alternateTransportProtocolPrefix = @"http://"; // this is the transport protocol prefix to be removed from the URL at the user input


typedef enum ReportType {DemoTable} ReportType;

extern char* reportNames[];

typedef enum SortOrder {Original, Ascending, Descending, FilterSearch} SortOrder;
typedef enum ColumnType {Text, String, Date, Cash, Percentage, Number, NonFormattedNumber, Portfolio, Integer} ColumnType;

typedef enum RedrawType {GraphHolder, PDF} RedrawType;

void displayMemoryWarning();
NSString* convertField(id field);


