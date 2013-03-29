//
//  GridView.h
//  vinocharts_diagrams
//
//  Created by Lee Jian Yi David on 3/29/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GridView : UIView

@property (readonly) double step;
@property (readonly) UIColor *lineColor;

- (id)initWithFrame:(CGRect)frame Step:(double)s LineColor:(UIColor*)lcolor;

- (void)redrawWithLineColor:(UIColor *)lineColor;

- (void)redrawWithStep:(double)myStep;

@end
