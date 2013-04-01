//
//  FramingLinesView.h
//  vinocharts_diagrams
//
//  Created by Lee Jian Yi David on 4/1/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FramingLinesView : NSObject

@property (readonly) UIColor *lineColor;
@property (readonly,nonatomic) double thickness;
@property (readonly,nonatomic) CGRect demarcatedFrame;
@property (readonly) UIView *tL; //top line
@property (readonly) UIView *bL; //bottom line
@property (readonly) UIView *lL; //left line
@property (readonly) UIView *rL; //right line

//4 lines demarcate the demarcatedFrame.
// Lines are:
//           Top Line
//         _______
//    Left |  Obj |    Right
//    Line |______|  Line
//                
//           Btm Line
//

- (id)initToDemarcateFrame:(CGRect)demarcFrame LineColor:(UIColor*)lcolor Thickness:(double)thickness;

- (void)setDemarcatedFrame:(CGRect)frameToDemarcate;

- (void)setThickness:(double)thickness;

- (void)addTo:(UIView*)v;

- (void)addToBottommostLayerOf:(UIView*)v;

- (void)removeLines;


@end
