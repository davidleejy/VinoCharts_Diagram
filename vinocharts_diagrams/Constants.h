//
//  Constants.h
//  vinocharts_diagrams
//
//  Created by Lee Jian Yi David on 3/24/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Constants : NSObject


/* Limits */

//Notes
FOUNDATION_EXPORT NSUInteger NOTE_CONTENT_CHAR_LIM;
FOUNDATION_EXPORT NSString *STR_WITH_140_CHARS;
FOUNDATION_EXPORT NSUInteger NOTE_DEFAULT_WIDTH;
FOUNDATION_EXPORT NSUInteger NOTE_DEFAULT_HEIGHT;


//Canvas

//Easel (Thing that holds up canvas)
FOUNDATION_EXPORT double EASEL_BORDER_CANVAS_BORDER_OFFSET;


/* Constants that aren't limits */

//Notes
FOUNDATION_EXPORT NSUInteger NOTE_DEFAULT_FONT_SIZE;


/* Font Families */
FOUNDATION_EXPORT NSString *FONT_HELVETICA;
FOUNDATION_EXPORT NSString *FONT_TIMESNEWROMAN;
FOUNDATION_EXPORT NSString *FONT_COURIER;
FOUNDATION_EXPORT NSString *FONT_NOTEWORTHY;
FOUNDATION_EXPORT NSString *FONT_VERDANA;
FOUNDATION_EXPORT NSString *FONT_ARIAL;
FOUNDATION_EXPORT NSString *FONT_TREBUCHETMS;


@end
