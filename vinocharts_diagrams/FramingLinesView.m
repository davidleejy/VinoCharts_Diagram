//
//  FramingLinesView.m
//  vinocharts_diagrams
//
//  Created by Lee Jian Yi David on 4/1/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "FramingLinesView.h"

@interface FramingLinesView ()
@property (readwrite) UIColor *lineColor;
@property (readwrite) double thickness;
@property (readwrite,nonatomic) CGRect demarcatedFrame;
@property (readwrite) UIView *tL; //top line
@property (readwrite) UIView *bL; //bottom line
@property (readwrite) UIView *lL; //left line
@property (readwrite) UIView *rL; //right line
@end

@implementation FramingLinesView

@synthesize demarcatedFrame = _demarcatedFrame;

- (id)initToDemarcateFrame:(CGRect)demarcFrame LineColor:(UIColor*)lcolor Thickness:(double)thickness
{
    if (!self) return nil;
    
    _lineColor = lcolor;
    _demarcatedFrame = demarcFrame;
    _thickness = thickness;
    
    [self createAlignmentLinesAccordingToProperties];
    
    return self;
}


- (void)setDemarcatedFrame:(CGRect)frameToDemarcate{
    _demarcatedFrame = frameToDemarcate;
    
    //Adjust top line.
    _tL.frame = CGRectMake(_demarcatedFrame.origin.x,
                           _demarcatedFrame.origin.y,
                           _demarcatedFrame.size.width ,
                           _thickness);
    
    //Adjust bottom line.
    _bL.frame = CGRectMake(_demarcatedFrame.origin.x,
                           _demarcatedFrame.origin.y+_demarcatedFrame.size.height,
                           _demarcatedFrame.size.width,
                           _thickness);
    
    //Adjust left line.
    _lL.frame = CGRectMake(_demarcatedFrame.origin.x,
                           _demarcatedFrame.origin.y,
                           _thickness,
                           _demarcatedFrame.size.height);
    
    //Adjust right line.
    _rL.frame = CGRectMake(_demarcatedFrame.origin.x+_demarcatedFrame.size.width,
                           _demarcatedFrame.origin.y,
                           _thickness,
                           _demarcatedFrame.size.height+_thickness); //plus thickness for aesthetic purposes.
}

- (void)setThickness:(double)thickness {
    _thickness = thickness;
}

- (void)addTo:(UIView*)v{
    [v addSubview:_tL]; [v addSubview:_bL]; [v addSubview:_lL]; [v addSubview:_rL];
}


- (void)addToBottommostLayerOf:(UIView*)v{
    [self addTo:v];
    [v sendSubviewToBack:_tL]; [v sendSubviewToBack:_bL]; [v sendSubviewToBack:_lL]; [v sendSubviewToBack:_rL];
}


- (void)removeLines{
    [_tL removeFromSuperview]; [_bL removeFromSuperview]; [_lL removeFromSuperview]; [_rL removeFromSuperview];
}






/******** HELPER FUNCTIONS *********/

- (void)createAlignmentLinesAccordingToProperties{
    //Draw top line.
    _tL = [[UIView alloc]initWithFrame:CGRectMake(_demarcatedFrame.origin.x,
                                                  _demarcatedFrame.origin.y,
                                                  _demarcatedFrame.size.width ,
                                                  _thickness)];
    [_tL setBackgroundColor:_lineColor];
    
    //Draw bottom line.
    _bL = [[UIView alloc]initWithFrame:CGRectMake(_demarcatedFrame.origin.x,
                                                  _demarcatedFrame.origin.y+_demarcatedFrame.size.height,
                                                  _demarcatedFrame.size.width,
                                                  _thickness)];
    [_bL setBackgroundColor:_lineColor];
    
    //Draw left line.
    _lL = [[UIView alloc]initWithFrame:CGRectMake(_demarcatedFrame.origin.x,
                                                  _demarcatedFrame.origin.y,
                                                  _thickness,
                                                  _demarcatedFrame.size.height)];
    [_lL setBackgroundColor:_lineColor];
    
    //Draw right line.
    _rL = [[UIView alloc]initWithFrame:CGRectMake(_demarcatedFrame.origin.x+_demarcatedFrame.size.width,
                                                  _demarcatedFrame.origin.y,
                                                  _thickness,
                                                  _demarcatedFrame.size.height+_thickness)]; //plus thickness for aesthetic purposes.
    [_rL setBackgroundColor:_lineColor];
}



@end
