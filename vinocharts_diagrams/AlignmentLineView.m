//
//  AlignmentView.m
//  vinocharts_diagrams
//
//  Created by Lee Jian Yi David on 3/29/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "AlignmentLineView.h"

@interface AlignmentLineView ()
@property (readwrite) UIColor *lineColor;
@property (readwrite) CGRect demarcatedFrame;
@property (readwrite) CGRect universe;
@end

@implementation AlignmentLineView


- (id)initToDemarcateFrame:(CGRect)demarcFrame In:(CGRect)universe LineColor:(UIColor*)lcolor{
    self = [super initWithFrame:universe]; //alignment lines stretch to the edge of universe.
    if (!self) return nil;
    
    [self setBackgroundColor:[UIColor clearColor]]; //Make background transparent
    _lineColor = lcolor;
    _demarcatedFrame = demarcFrame;
    _universe = universe;
    
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    
    CGContextClearRect(contextRef, self.bounds); //clearing is standard procedure in the event of redrawing.
    
    //Begin drawing alignment lines.
    
    //Set color of alignment lines. Black and white colors have only 2 CGColor components.
    if ([_lineColor isEqual:[UIColor blackColor]]) {
        [[UIColor blackColor]setStroke];
    }
    else if ([_lineColor isEqual:[UIColor whiteColor]]) {
        [[UIColor whiteColor]setStroke];
    }
    else {
        CGContextSetStrokeColor(contextRef, CGColorGetComponents(_lineColor.CGColor)); //Colors that have 4 CGColor components.
    }
    
    CGContextSetLineWidth(contextRef, 1.5); // Set thickness of lines.
    
    //4 lines demarcate the demarcatedFrame.
    // Lines are:
    //          Top Line
    //         ______
    //    Left|  Obj |Right
    //    Line|______|Line
    //          Btm Line
    //
    // Note that these lines stretch all the way out to the edge of the superview of the Obj.
    
    //Draw left line.
    CGContextMoveToPoint(contextRef, _demarcatedFrame.origin.x, 0);
    CGContextAddLineToPoint(contextRef, _demarcatedFrame.origin.x, _universe.size.height);
    CGContextStrokePath(contextRef);
    
    //Draw right line.
    CGContextMoveToPoint(contextRef, _demarcatedFrame.origin.x+_demarcatedFrame.size.width, 0);
    CGContextAddLineToPoint(contextRef, _demarcatedFrame.origin.x+_demarcatedFrame.size.width, _universe.size.height);
    CGContextStrokePath(contextRef);
    
    //Draw top line.
    CGContextMoveToPoint(contextRef, 0, _demarcatedFrame.origin.y);
    CGContextAddLineToPoint(contextRef, _universe.size.width, _demarcatedFrame.origin.y);
    CGContextStrokePath(contextRef);

    //Draw bottom line.
    CGContextMoveToPoint(contextRef, 0, _demarcatedFrame.origin.y+_demarcatedFrame.size.height);
    CGContextAddLineToPoint(contextRef, _universe.size.width, _demarcatedFrame.origin.y+_demarcatedFrame.size.height);
    CGContextStrokePath(contextRef);
}

- (void)redrawWithDemarcatedFrame:(CGRect)demarcFrame{
    _demarcatedFrame = demarcFrame;
    [self setNeedsDisplay];
}


@end
