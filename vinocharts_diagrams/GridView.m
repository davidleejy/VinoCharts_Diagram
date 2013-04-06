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
@property (readwrite) double thickness;

@end

@implementation GridView


- (id)initWithFrame:(CGRect)frame Step:(double)s LineColor:(UIColor*)lcolor
{
    self = [super initWithFrame:frame];
    if (self) {
        _step = s;
        [self setBackgroundColor:[UIColor clearColor]]; //Make background transparent
        _lineColor = lcolor;
        _thickness = 0.8;
        
        
        UIView *line;
        
        //draw vertical lines.
        for (int x = 0; x < self.frame.size.width; x+=_step) {
            line = [[UIView alloc]initWithFrame:CGRectMake(x, 0, _thickness, self.frame.size.height)];
            [line setBackgroundColor:_lineColor];
            [self addSubview:line];
        }
        
        //draw horizontal lines.
        for (int y = 0; y< self.frame.size.height; y+=_step) {
            line = [[UIView alloc]initWithFrame:CGRectMake(0, y, self.frame.size.width, _thickness)];
            [line setBackgroundColor:_lineColor];
            [self addSubview:line];
        }
        
        [self setAlpha:0.4];
        
        return self;
    }
    return nil;
}


//// Only override drawRect: if you perform custom drawing.
//// An empty implementation adversely affects performance during animation.
//- (void)drawRect:(CGRect)rect
//{
//    CGContextRef contextRef = UIGraphicsGetCurrentContext();
//    
//    CGContextClearRect(contextRef, self.bounds); //clearing is standard procedure in the event of redrawing.
//    
//    //Begin drawing grid lines
//    
//    //Set color of grid lines. Black and white colors have only 2 CGColor components.
//    if ([_lineColor isEqual:[UIColor blackColor]]) {
//        [[UIColor blackColor]setStroke];
//    }
//    else if ([_lineColor isEqual:[UIColor whiteColor]]) {
//        [[UIColor whiteColor]setStroke];
//    }
//    else {
//    CGContextSetStrokeColor(contextRef, CGColorGetComponents(_lineColor.CGColor)); //Colors that have 4 CGColor components.
//    }
//    
//    CGContextSetLineWidth(contextRef, 0.5); // Set thickness of stroke of grid lines.
//    
//    //draw vertical lines.
//    for (int i = 0; i < self.bounds.size.width; i+=_step) {
//        CGContextMoveToPoint(contextRef, i, 0);
//        CGContextAddLineToPoint(contextRef, i, self.bounds.size.height);
//        CGContextStrokePath(contextRef); //stroke path.
//    }
//    
//    //draw horizontal lines.
//    for (int i = 0; i < self.bounds.size.height; i+=_step) {
//        CGContextMoveToPoint(contextRef, 0, i);
//        CGContextAddLineToPoint(contextRef, self.bounds.size.width, i);
//        CGContextStrokePath(contextRef); //stroke path.
//    }
//    
//}

- (void)setColor:(UIColor *)lineColor{
    _lineColor = lineColor;
    for (int i = 0; i<self.subviews.count; i++) {
        [[self.subviews objectAtIndex:i] setBackgroundColor:_lineColor];
    }
}


@end
