//
//  GridView.m
//  vinocharts_diagrams
//
//  Created by Lee Jian Yi David on 3/29/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "GridView.h"
#import <QuartzCore/QuartzCore.h>
#import <CoreGraphics/CoreGraphics.h>

@interface GridView ()

@property (readwrite) double step;
@property (readwrite) UIColor *lineColor;

@end

@implementation GridView


- (id)initWithFrame:(CGRect)frame Step:(double)s LineColor:(UIColor*)lcolor
{
    self = [super initWithFrame:frame];
    if (self) {
        _step = s;
        [self setBackgroundColor:[UIColor clearColor]]; //Make background transparent
        _lineColor = lcolor;
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    
    CGContextClearRect(contextRef, self.bounds); //clearing is standard procedure in the event of redrawing.
    
    //Begin drawing grid lines
    
    //Set color of grid lines. Black and white colors have only 2 CGColor components.
    if ([_lineColor isEqual:[UIColor blackColor]]) {
        [[UIColor blackColor]setStroke];
    }
    else if ([_lineColor isEqual:[UIColor whiteColor]]) {
        [[UIColor whiteColor]setStroke];
    }
    else {
    CGContextSetStrokeColor(contextRef, CGColorGetComponents(_lineColor.CGColor)); //Colors that have 4 CGColor components.
    }
    
    CGContextSetLineWidth(contextRef, 0.5); // Set thickness of stroke of grid lines.
    
    //draw vertical lines.
    for (int i = 0; i < self.bounds.size.width; i+=_step) {
        CGContextMoveToPoint(contextRef, i, 0);
        CGContextAddLineToPoint(contextRef, i, self.bounds.size.height);
        CGContextStrokePath(contextRef); //stroke path.
    }
    
    //draw horizontal lines.
    for (int i = 0; i < self.bounds.size.height; i+=_step) {
        CGContextMoveToPoint(contextRef, 0, i);
        CGContextAddLineToPoint(contextRef, self.bounds.size.width, i);
        CGContextStrokePath(contextRef); //stroke path.
    }
    
}

- (void)redrawWithLineColor:(UIColor *)lineColor{
    _lineColor = lineColor;
    [self setNeedsDisplay];
}

- (void)redrawWithStep:(double)myStep {
    _step = myStep;
    [self setNeedsDisplay];
}

@end
