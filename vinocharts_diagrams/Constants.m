//
//  Constants.m
//  vinocharts_diagrams
//
//  Created by Lee Jian Yi David on 3/24/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "Constants.h"

@implementation Constants

/* Limits */

//Notes
NSUInteger NOTE_CONTENT_CHAR_LIM = 140;
NSString *STR_WITH_140_CHARS =
    @"\"Imagine a world in which every single human being can freely share in the sum of all knowledge. That's our commitment.\" –Wikipedia VisState";
NSUInteger NOTE_DEFAULT_WIDTH = 260;
NSUInteger NOTE_DEFAULT_HEIGHT = 90;

//Canvas
NSUInteger CANVAS_NOTE_COUNT_LIM = 100;

//Easel (Easel is the thing that holds up the canvas)
double EASEL_BORDER_CANVAS_BORDER_OFFSET = 260;


/* Constants that aren't limits */

//Notes
NSUInteger NOTE_DEFAULT_FONT_SIZE = 12;

/* Font Families*/
NSString *FONT_HELVETICA = @"Helvetica";
NSString *FONT_TIMESNEWROMAN = @"Times New Roman";
NSString *FONT_COURIER = @"Courier";
NSString *FONT_NOTEWORTHY = @"Noteworthy";
NSString *FONT_VERDANA = @"Verdana";
NSString *FONT_ARIAL = @"Arial";
NSString *FONT_TREBUCHETMS = @"Trebuchet MS";

@end
