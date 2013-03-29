//
//  AlignmentView.m
//  vinocharts_diagrams
//
//  Created by Lee Jian Yi David on 3/29/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "AlignmentLineView.h"

@interface AlignmentLineView ()
@property (readwrite) UIView *tL; //top line
@property (readwrite) UIView *bL; //bottom line
@property (readwrite) UIView *lL; //left line
@property (readwrite) UIView *rL; //right line
@end

@implementation AlignmentLineView


- (id)initToDemarcateFrame:(CGRect)demarcFrame In:(CGRect)universe LineColor:(UIColor*)lcolor Thickness:(double)thickness{ //alignment lines stretch to the edge of universe.
    if (!self) return nil;
    
    [self setBackgroundColor:[UIColor clearColor]]; //Make background transparent
    _lineColor = lcolor;
    _demarcatedFrame = demarcFrame;
    _universe = universe;
    _thickness = thickness;
    
    [self createAlignmentLinesAccordingToProperties];
    
    return self;
}


- (void)redrawWithDemarcatedFrame:(CGRect)demarcFrame{
    _demarcatedFrame = demarcFrame;
    
    //Adjust top line.
    _tL.frame = CGRectMake(0, _demarcatedFrame.origin.y, _universe.size.width, _thickness);
    
    //Adjust bottom line.
    _bL.frame = CGRectMake(0, _demarcatedFrame.origin.y+_demarcatedFrame.size.height, _universe.size.width, _thickness);
    
    //Adjust left line.
    _lL.frame = CGRectMake(_demarcatedFrame.origin.x,0,_thickness,_universe.size.height);
    
    //Adjust right line.
    _rL.frame = CGRectMake(_demarcatedFrame.origin.x+_demarcatedFrame.size.width, 0, _thickness, _universe.size.height);
}


- (void)addTo:(UIView*)v{
    [v addSubview:_tL]; [v addSubview:_bL]; [v addSubview:_lL]; [v addSubview:_rL];
}


- (void)addToBottommostOf:(UIView*)v{
    [self addTo:v];
    [v sendSubviewToBack:_tL]; [v sendSubviewToBack:_bL]; [v sendSubviewToBack:_lL]; [v sendSubviewToBack:_rL];
}


- (void)removeLines{
    [_tL removeFromSuperview]; [_bL removeFromSuperview]; [_lL removeFromSuperview]; [_rL removeFromSuperview];
}






/******** HELPER FUNCTIONS *********/

- (void)createAlignmentLinesAccordingToProperties{
    //Draw top line.
    _tL = [[UIView alloc]initWithFrame:CGRectMake(0, _demarcatedFrame.origin.y, _universe.size.width, _thickness)];
    [_tL setBackgroundColor:_lineColor];
    
    //Draw bottom line.
    _bL = [[UIView alloc]initWithFrame:CGRectMake(0,
                                                  _demarcatedFrame.origin.y+_demarcatedFrame.size.height,
                                                  _universe.size.width, _thickness)];
    [_bL setBackgroundColor:_lineColor];
    
    //Draw left line.
    _lL = [[UIView alloc]initWithFrame:CGRectMake(_demarcatedFrame.origin.x,
                                                  0,
                                                  _thickness,_universe.size.height)];
    [_lL setBackgroundColor:_lineColor];
    
    //Draw right line.
    _rL = [[UIView alloc]initWithFrame:CGRectMake(_demarcatedFrame.origin.x+_demarcatedFrame.size.width,
                                                  0,
                                                  _thickness,_universe.size.height)];
    [_rL setBackgroundColor:_lineColor];
}

- (void)adjustAlignmentLinesAccordingToProperties{
    //Adjust top line.
    _tL.frame = CGRectMake(0, _demarcatedFrame.origin.y, _universe.size.width, _thickness);
    [_tL setBackgroundColor:_lineColor];
    
    //Adjust bottom line.
    _bL.frame = CGRectMake(0, _demarcatedFrame.origin.y+_demarcatedFrame.size.height, _universe.size.width, _thickness);
    [_bL setBackgroundColor:_lineColor];
    
    //Adjust left line.
    _lL.frame = CGRectMake(_demarcatedFrame.origin.x,0,_thickness,_universe.size.height);
    [_lL setBackgroundColor:_lineColor];
    
    //Adjust right line.
    _rL.frame = CGRectMake(_demarcatedFrame.origin.x+_demarcatedFrame.size.width, 0, _thickness, _universe.size.height);
    [_rL setBackgroundColor:_lineColor];
}


@end
