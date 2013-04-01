//
//  AlignmentView.h
//  vinocharts_diagrams
//
//  Created by Lee Jian Yi David on 3/29/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AlignmentLineView : UIView

@property (readwrite) UIColor *lineColor;
@property (readwrite) double thickness;
@property (readwrite) CGRect demarcatedFrame;
@property (readwrite) CGRect universe;
@property (readonly) UIView *tL; //top line
@property (readonly) UIView *bL; //bottom line
@property (readonly) UIView *lL; //left line
@property (readonly) UIView *rL; //right line

//4 lines demarcate the demarcatedFrame.
// Lines are:
//           Top Line
//         _|______|_
//    Left  |  Obj |    Right
//    Line _|______|_   Line
//          |      |
//           Btm Line
//
// Note that these lines stretch all the way out to the edge of the superview of the Obj.

- (id)initToDemarcateFrame:(CGRect)demarcFrame In:(CGRect)universe LineColor:(UIColor*)lcolor Thickness:(double)thickness;

- (void)redrawWithDemarcatedFrame:(CGRect)demarcFrame;

- (void)addTo:(UIView*)v;

- (void)addToBottommostOf:(UIView*)v;

- (void)removeLines;

@end
