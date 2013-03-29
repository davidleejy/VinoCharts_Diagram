//
//  AlignmentView.h
//  vinocharts_diagrams
//
//  Created by Lee Jian Yi David on 3/29/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AlignmentLineView : UIView

@property (readonly) UIColor *lineColor;
@property (readonly) CGRect demarcatedFrame;
@property (readonly) CGRect universe;

- (id)initToDemarcateFrame:(CGRect)demarcFrame In:(CGRect)universe LineColor:(UIColor*)lcolor;

- (void)redrawWithDemarcatedFrame:(CGRect)demarcFrame;

@end
