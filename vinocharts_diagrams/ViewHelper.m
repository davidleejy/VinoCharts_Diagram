//
//  ViewHelper.m
//  Game
//
//  Created by Lee Jian Yi David on 3/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "ViewHelper.h"

@implementation ViewHelper

+ (UIView*) embedText:(NSString*)txt
         WithFrame:(CGRect)frame
         TextColor:(UIColor*)color
      DurationSecs:(double)t
                In:(UIView*)view1
{
    UILabel *lbl = [[UILabel alloc]init];
    [lbl setFrame:frame];
    [lbl setText:txt];
    [lbl setAdjustsFontSizeToFitWidth:YES];
    [lbl setTextAlignment:UITextAlignmentCenter];
    [lbl setBackgroundColor:[UIColor clearColor]];
    [lbl setTextColor:color];
    [view1 addSubview:lbl];
    
    if (t <= 0.0) {
        return lbl;
    }
    else // lbl will remove itself from view1 after t seconds.
        [lbl performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:t];
    
    return lbl;
}


+(UIView*)embedMark:(CGPoint)coord
     WithColor:(UIColor*)color
  DurationSecs:(double)t
            In:(UIView*)view1
{
    UIView *mark = [[UIView alloc]initWithFrame:CGRectMake(coord.x, coord.y, 5, 5)];
    [mark setBackgroundColor:color];
    [view1 addSubview:mark];
    
    if (t <= 0.0) {
        return mark;
    }
    else // mark will remove itself from view1 after t seconds.
        [mark performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:t];
    
    return mark;
}


+(UIView*)embedRect:(CGRect)frame
          WithColor:(UIColor*)color
       DurationSecs:(double)t
                 In:(UIView*)view1
{
    UIView *rect = [[UIView alloc]initWithFrame:frame];
    [rect setBackgroundColor:color];
    [view1 addSubview:rect];
    
    if (t <= 0.0) {
        return rect;
    }
    else // mark will remove itself from view1 after t seconds.
        [rect performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:t];
    
    return rect;
}


+(UIColor*)invColorOf:(UIColor*)aColor{
    
    // White and black color are special cases.
    if ([aColor isEqual:[UIColor whiteColor]]) {
        return [UIColor blackColor];
    }
    
    if ([aColor isEqual:[UIColor blackColor]]) {
        return [UIColor whiteColor];
    }
    // End of special cases.
    
    const CGFloat *componentColors = CGColorGetComponents(aColor.CGColor);
    
    UIColor *invColor = [[UIColor alloc] initWithRed:(1.0 - componentColors[0])
                                               green:(1.0 - componentColors[1])
                                                blue:(1.0 - componentColors[2])
                                               alpha:componentColors[3]];
    return invColor;
}

+(CGRect)centeredFrameForScrollViewWithNoContentInset:(UIScrollView *)sV AndWithContentView:(UIView *)cV {
    CGSize boundsSize = sV.bounds.size;
    CGRect frameToCenter = cV.frame;
    
    // center horizontally
    if (frameToCenter.size.width < boundsSize.width)
        frameToCenter.origin.x = (boundsSize.width - frameToCenter.size.width) / 2;
    else
        frameToCenter.origin.x = 0;
    
    // center vertically
    if (frameToCenter.size.height < boundsSize.height)
        frameToCenter.origin.y = (boundsSize.height - frameToCenter.size.height) / 2;
    else
        frameToCenter.origin.y = 0;
    
    return frameToCenter; //apply this to cV!
}

@end
